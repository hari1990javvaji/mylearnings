resource "aws_s3_bucket" "datalake_access_log_bucket" {
  #checkov:skip=CKV_AWS_21: Versioning is selectively enabled based on the input parameter. Checkov is unable to recognize it
  #checkov:skip=CKV_AWS_144: Cross region replication is not needed for access logs bucket
  #checkov:skip=CKV_AWS_18: Access log bucket is created here. It should not point to itself or other log bucket

  bucket = format(var.bucket_name_label, var.resource_prefix, "logs", var.region_name, var.account_id)
  tags = merge(
    {
      "Description" = "Datalake S3 bucket for logs"
    },
  var.tags)
}

resource "aws_s3_bucket_public_access_block" "datalake_access_log_bucket" {

  bucket = aws_s3_bucket.datalake_access_log_bucket.bucket

  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

resource "aws_s3_bucket_versioning" "datalake_access_log_bucket" {
  bucket = aws_s3_bucket.datalake_access_log_bucket.bucket

  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "datalake_access_log_bucket" {
  bucket = aws_s3_bucket.datalake_access_log_bucket.bucket

  rule {
    bucket_key_enabled = var.bucket_key_enabled
    apply_server_side_encryption_by_default {
      sse_algorithm     = var.bucket_encryption["algorithm"]
      kms_master_key_id = var.kms_key_arn
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "datalake_access_log_bucket" {
  bucket = aws_s3_bucket.datalake_access_log_bucket.bucket

  rule {
    id = "datalake-logs-expiration"

    expiration {
      days = 7
    }

    status = "Enabled"
  }
}

## Data Lake Landing Layer
resource "aws_s3_bucket" "datalake_buckets" {
  for_each = var.buckets
  #checkov:skip=CKV_AWS_21: Versioning is selectively enabled based on the input parameter. Checkov is unable to recognize it
  #checkov:skip=CKV_AWS_144: Cross region replication will incur cost. Current implementation does not CRR
  #checkov:skip=CKV_AWS_18: Access log bucket is created here. Also data lake bucket do not need access log at this point in time.
  #If access log is needed, we need to separate out the access log bucket creation and then add the terraform resource 
  # resource "aws_s3_bucket_logging" "example" {
  # bucket = aws_s3_bucket.example.id

  # target_bucket = aws_s3_bucket.log_bucket.id
  # target_prefix = "log/"
  # }
  # this involves additional cost. hence need to test with customer before resolving

  bucket = format(var.bucket_name_label, var.resource_prefix, each.key, var.region_name, var.account_id)
  tags = merge(
    {
      "Description" = "Datalake S3 bucket for ${each.key}"
    },
  var.tags)
}

resource "aws_s3_bucket_public_access_block" "datalake_buckets" {
  for_each = aws_s3_bucket.datalake_buckets

  bucket = each.value.bucket

  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

resource "aws_s3_bucket_versioning" "datalake_buckets" {
  for_each = aws_s3_bucket.datalake_buckets

  bucket = each.value.bucket

  versioning_configuration {
    status = var.buckets[each.key].versioning == true ? "Enabled" : "Disabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "datalake_buckets" {
  for_each = aws_s3_bucket.datalake_buckets

  bucket = each.value.bucket

  rule {
    bucket_key_enabled = var.bucket_key_enabled
    apply_server_side_encryption_by_default {
      sse_algorithm     = var.bucket_encryption["algorithm"]
      kms_master_key_id = var.kms_key_arn
    }
  }
}

resource "aws_s3_bucket_logging" "datalake_buckets" {
  for_each = aws_s3_bucket.datalake_buckets

  bucket        = each.value.bucket
  target_bucket = aws_s3_bucket.datalake_access_log_bucket.id
  target_prefix = format("%s/%s", "log", "${each.key}")
}

resource "aws_s3_bucket_lifecycle_configuration" "datalake_raw" {
  bucket = aws_s3_bucket.datalake_buckets["raw"].id

  rule {
    id = "datalake-raw-movement"

    transition {
      days          = 360
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 720
      storage_class = "DEEP_ARCHIVE"
    }

    status = "Enabled"
  }
  depends_on = [aws_s3_bucket_versioning.datalake_buckets["raw"]]
}

resource "aws_s3_bucket_lifecycle_configuration" "datalake_stage" {
  bucket = aws_s3_bucket.datalake_buckets["stage"].id

  rule {
    id = "datalake-stage-delete-ninety-days"

    noncurrent_version_expiration {
      noncurrent_days = 7
    }

    expiration {
      days = 90
    }

    status = "Enabled"
  }

  depends_on = [aws_s3_bucket_versioning.datalake_buckets["stage"]]
}

resource "aws_s3_bucket_lifecycle_configuration" "datalake_analytics" {
  bucket = aws_s3_bucket.datalake_buckets["analytics"].id

  rule {
    id = "datalake-analytics-movement"

    transition {
      days          = 360
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 720
      storage_class = "GLACIER"
    }

    transition {
      days          = 1080
      storage_class = "DEEP_ARCHIVE"
    }

    status = "Enabled"
  }

  depends_on = [aws_s3_bucket_versioning.datalake_buckets["analytics"]]
}

