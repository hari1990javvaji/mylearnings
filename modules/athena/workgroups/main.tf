resource "aws_athena_workgroup" "workgroups" {
  for_each = local.athena_workgroups

  name          = format("%s-%s", var.resource_prefix, each.key)
  description   = each.value.description
  force_destroy = true

  configuration {
    bytes_scanned_cutoff_per_query     = lookup(each.value, "bytes_scanned", 10737418240)
    enforce_workgroup_configuration    = true
    publish_cloudwatch_metrics_enabled = lookup(each.value, "cloudwatch_enabled", true)

    result_configuration {
      output_location = "s3://${var.bucket_query_result.bucket}/${each.key}/output/"

      encryption_configuration {
        encryption_option = var.encrypt_algorithm_athena
        kms_key_arn       = var.kms_key_arn
      }
    }
  }
  tags = merge(
    {
      "Description" = "Athena workgroups for datalake"
    },
  var.tags)
}