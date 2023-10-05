resource "aws_glue_catalog_database" "datalake_databases" {
  for_each = { for b in var.datalake_layers_buckets : b.layer => b }

  name         = format(var.glue_database_mask, var.resource_prefix, each.key)
  description  = "Data Lake ${each.key} layer database"
  location_uri = "s3://${each.value.bucket}"
  #depends_on = [var.lakeformation_settings]
}