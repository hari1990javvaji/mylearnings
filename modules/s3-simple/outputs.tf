output "bucket_info" {
  value = {
    arn    = aws_s3_bucket.bucket.arn
    bucket = aws_s3_bucket.bucket.bucket
  }
}