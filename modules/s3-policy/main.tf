resource "aws_s3_bucket_policy" "allow_access_to_central_lf_admin" {
  for_each = { for b in var.central_catalogs : b.layer => b }
  bucket   = each.value.s3_bucket
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "${each.value.lf_admin}"
        }
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::${each.value.s3_bucket}",
          "arn:aws:s3:::${each.value.s3_bucket}/*"
        ]
      }
    ]
    }
  )
}
