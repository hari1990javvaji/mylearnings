output "key_arn" {
  value       = aws_kms_key.key.arn
  description = "KMS Key ARN"
}
output "key_id" {
  value       = aws_kms_key.key.key_id
  description = "KMS Key ID"
}
