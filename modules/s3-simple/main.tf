locals {
  bucket = format(var.bucket_name_label, var.resource_prefix, var.bucket.bucket_name, data.aws_region.current.id, data.aws_caller_identity.current.account_id)
}

resource "aws_s3_bucket" "bucket" {
  #checkov:skip=CKV_AWS_21: Versioning is selectively enabled based on the input parameter. Checkov is unable to recognize it
  #checkov:skip=CKV_AWS_144: Cross region replication is not needed for access logs bucket
  #checkov:skip=CKV_AWS_18: Access log bucket is created here. It should not point to itself or other log bucket

  bucket = format(var.bucket_name_label, var.resource_prefix, var.bucket.bucket_name, data.aws_region.current.id, data.aws_caller_identity.current.account_id)
  tags = merge(
    {
      "Description" = "Datalake S3 bucket for logs"
    },
  var.tags)
}

resource "aws_s3_bucket_public_access_block" "bucket_access" {

  bucket = aws_s3_bucket.bucket.bucket

  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.bucket.bucket

  versioning_configuration {
    status = var.bucket.bucket_versioning
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_encryption" {
  bucket = aws_s3_bucket.bucket.bucket

  rule {
    bucket_key_enabled = var.bucket_key_enabled
    apply_server_side_encryption_by_default {
      sse_algorithm     = var.bucket_encryption["algorithm"]
      kms_master_key_id = var.kms_key_arn
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "bucket_lifecycle" {
  bucket = aws_s3_bucket.bucket.bucket

  rule {
    id = "datalake-logs-expiration"

    expiration {
      days = 7
    }

    status = "Enabled"
  }
}

resource "aws_s3_bucket_logging" "bucket_access_log" {
  count         = var.bucket_access_log["enable_bucket_access_log"] ? 1 : 0
  bucket        = aws_s3_bucket.bucket.bucket
  target_bucket = var.bucket_access_log["bucket_access_log"]
  target_prefix = format("%s/%s", "log", "${aws_s3_bucket.bucket.bucket}")
}
