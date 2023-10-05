#---------------------------------------------------
# AWS Glue crawler
#---------------------------------------------------
resource "aws_glue_crawler" "glue_crawler" {

  for_each      = { for b in var.central_catalogs : b.layer => b }
  name          = format("%s-%s", var.glue_crawler_name, each.value.glue_db)
  database_name = format("%s-%s-%s", "link", var.resource_prefix, each.key)
  role          = var.glue_crawler_role

  description            = var.glue_crawler_description
  classifiers            = var.glue_crawler_classifiers
  configuration          = var.glue_crawler_configuration
  schedule               = var.glue_crawler_schedule
  security_configuration = var.glue_crawler_security_configuration
  table_prefix           = var.glue_crawler_table_prefix
  lake_formation_configuration {
    use_lake_formation_credentials = var.use_lake_formation_credentials
  }

  s3_target {
    path            = format("%s://%s", "s3", each.value.s3_bucket)
    connection_name = var.datalake-glue-connector-id
  }

  dynamic "schema_change_policy" {
    iterator = schema_change_policy
    for_each = var.glue_crawler_schema_change_policy

    content {
      delete_behavior = lookup(schema_change_policy.value, "delete_behavior", null)
      update_behavior = lookup(schema_change_policy.value, "update_behavior", null)
    }
  }

  dynamic "lineage_configuration" {
    iterator = lineage_configuration
    for_each = var.glue_crawler_lineage_configuration

    content {
      crawler_lineage_settings = lookup(lineage_configuration.value, "crawler_lineage_settings", null)
    }
  }

  dynamic "recrawl_policy" {
    iterator = recrawl_policy
    for_each = var.glue_crawler_recrawl_policy

    content {
      recrawl_behavior = lookup(recrawl_policy.value, "recrawl_behavior", null)
    }
  }

  tags = merge(
    {
      Name   = var.glue_crawler_name
      Prefix = var.resource_prefix
    },
    var.tags
  )

  lifecycle {
    create_before_destroy = true
    ignore_changes        = []
  }
}