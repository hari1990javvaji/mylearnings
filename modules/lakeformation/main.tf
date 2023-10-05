## Base Configuration
## Set lake formation administrators under "administrative roles and tasks"
## TODO Based on the organizational need, lake formation administrator can be common or specific to data pipeline
## TODO Granting administrative privileges to various IAM roles may be moved to lakeformation-common
## TODO If each data pipeline creates LF admin, then it overrides the lf admin added by the previous data pipeline

## This module should be renamed to lakeformation-producer

resource "aws_lakeformation_data_lake_settings" "base" {
  admins = concat([var.administrator_role.arn, var.deployment_role.arn], var.administrator_users)
}


## Register each S3 bucket in LF against the LF admin role "Data Lake Locations"
resource "aws_lakeformation_resource" "datalake_landing" {
  for_each = { for b in var.datalake_layers_buckets : b.layer => b }

  arn      = each.value.arn
  role_arn = var.administrator_role.arn
}


## Provide access to each S3 (Data Locations) to glue crawler ARN
resource "aws_lakeformation_permissions" "datalake_locations" {
  for_each = { for b in var.datalake_layers_buckets : b.layer => b }

  principal   = var.glue_crawler_arn
  permissions = ["DATA_LOCATION_ACCESS"]
  data_location {
    arn = each.value.arn
  }
}

## Provide access to each glue database to glue crawler ARN under "Data Lake Permisions"
resource "aws_lakeformation_permissions" "datalake_landing_database" {
  for_each = var.glue_databases

  permissions = var.gluecrawler_database_permissions
  principal   = var.glue_crawler_arn

  database {
    name = each.value.name
  }
}

## Provide access to all tables to glue crawler ARN under "Data Lake Permisions"
resource "aws_lakeformation_permissions" "datalake_landing_tables" {
  for_each = var.glue_databases

  principal   = var.glue_crawler_arn
  permissions = var.gluecrawler_table_permissions

  table {
    database_name = each.value.name
    wildcard      = "true"
  }
}


## Create Glue Link database for every database shared by central account
resource "aws_glue_catalog_database" "link_databases" {
  for_each = { for b in var.central_catalogs : b.layer => b }
  name     = format("%s-%s-%s", "link", var.resource_prefix, each.key)
  target_database {
    database_name = each.value.glue_db
    catalog_id    = each.value.account_id
  }
  lifecycle {
    ignore_changes = [
      # Ignore changes to description,
      # updates these based on some ruleset managed elsewhere.
      description,
    ]
  }
  depends_on = [aws_lakeformation_data_lake_settings.base]
}

## Grant on link glue database to glue crawler
resource "aws_lakeformation_permissions" "grant_on_link_db" {
  for_each = { for b in var.central_catalogs : b.layer => b }

  permissions                   = var.link_database_permissions
  permissions_with_grant_option = var.link_database_permissions
  principal                     = var.glue_crawler_arn

  database {
    name = format("%s-%s-%s", "link", var.resource_prefix, each.key)
  }
  depends_on = [aws_glue_catalog_database.link_databases]
}

## Grant on shared  glue database to glue crawler
resource "aws_lakeformation_permissions" "grant_on_shared_db" {
  for_each = { for b in var.central_catalogs : b.layer => b }

  permissions                   = var.grant_on_target_database_permissions
  permissions_with_grant_option = var.grant_on_target_database_permissions
  principal                     = var.glue_crawler_arn

  database {
    name       = each.value.glue_db
    catalog_id = each.value.account_id
  }
  depends_on = [aws_glue_catalog_database.link_databases]
}