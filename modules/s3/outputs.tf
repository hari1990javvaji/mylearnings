output "buckets" {
  value = aws_s3_bucket.datalake_buckets
}


output "bucket_access_logs" {
  value = {
    bucket = aws_s3_bucket.datalake_access_log_bucket.bucket
    arn    = aws_s3_bucket.datalake_access_log_bucket.arn
  }
}

output "bucket_athena" {
  value = {
    bucket = aws_s3_bucket.datalake_buckets["athena"].bucket
    arn    = aws_s3_bucket.datalake_buckets["athena"].arn
  }
}

output "bucket_assets" {
  value = {
    bucket = aws_s3_bucket.datalake_buckets["assets"].bucket
    arn    = aws_s3_bucket.datalake_buckets["assets"].arn
  }
}

output "bucket_raw" {
  value = {
    bucket = aws_s3_bucket.datalake_buckets["raw"].bucket
    arn    = aws_s3_bucket.datalake_buckets["raw"].arn
  }
}

output "bucket_emr_logs" {
  value = {
    bucket = aws_s3_bucket.datalake_buckets["emrlogs"].bucket
    arn    = aws_s3_bucket.datalake_buckets["emrlogs"].arn
  }
}

output "bucket_stage" {
  value = {
    bucket = aws_s3_bucket.datalake_buckets["stage"].bucket
    arn    = aws_s3_bucket.datalake_buckets["stage"].arn
  }
}

output "bucket_analytics" {
  value = {
    bucket = aws_s3_bucket.datalake_buckets["analytics"].bucket
    arn    = aws_s3_bucket.datalake_buckets["analytics"].arn
  }
}

output "buckets_nonsensitive" {
  value = [
    for key, value in aws_s3_bucket.datalake_buckets : {
      layer  = key
      bucket = value.bucket
      arn    = value.arn
    } if var.buckets[key].layer && !var.buckets[key].sensitive
  ]
}

output "buckets_nonsensitive_arns" {
  value = [
    for key, value in aws_s3_bucket.datalake_buckets : value.arn
    if var.buckets[key].layer && !var.buckets[key].sensitive
  ]
}