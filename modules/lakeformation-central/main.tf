# Base Configuration
# Set lake formation administrators under "administrative roles and tasks"
resource "aws_lakeformation_data_lake_settings" "base" {
  admins = concat([var.administrator_role.arn, var.deployment_role.arn], var.administrator_users)
}


## Register each S3 bucket in LF against the LF admin role "Data Lake Locations"
resource "aws_lakeformation_resource" "datalake_landing" {
  for_each = { for b in var.producer_catalogs : b.layer => b }

  arn      = format("%s%s", "arn:aws:s3:::", each.value.bucket)
  role_arn = var.administrator_role.arn
}


## Create the glue databases
resource "aws_glue_catalog_database" "datalake_databases" {
  for_each     = { for b in var.producer_catalogs : b.layer => b }
  name         = format(var.glue_database_mask, var.resource_prefix, each.key)
  description  = "Data Lake ${each.key} layer database"
  location_uri = "s3://${each.value.bucket}"
  depends_on   = [aws_lakeformation_data_lake_settings.base]
}

## Provide access to each glue database corresponding producer account id
resource "aws_lakeformation_permissions" "producer_cross_account_permissions" {
  for_each = { for b in var.producer_catalogs : b.layer => b }

  permissions                   = var.producer_database_permissions
  permissions_with_grant_option = var.producer_database_permissions
  principal                     = each.value.account_id

  database {
    name = format(var.glue_database_mask, var.resource_prefix, each.key)
  }
  depends_on = [aws_glue_catalog_database.datalake_databases]
}


## Provide access to each glue database corresponding central account lake formation administrator
resource "aws_lakeformation_permissions" "datalake_admin_permissions" {
  for_each = { for b in var.producer_catalogs : b.layer => b }

  permissions = var.producer_database_permissions
  #permissions_with_grant_option = var.producer_database_permissions
  principal = var.administrator_role.arn

  database {
    name = format(var.glue_database_mask, var.resource_prefix, each.key)
  }
  depends_on = [aws_glue_catalog_database.datalake_databases]
}


## Provide access to each glue database corresponding consumer account id
resource "aws_lakeformation_permissions" "consumer_cross_account_permissions" {
  for_each = { for b in var.consumer_catalogs : b.layer => b }

  permissions                   = var.consumer_database_permissions
  permissions_with_grant_option = var.consumer_database_permissions
  principal                     = each.value.account_id

  database {
    name = each.value.glue_db
  }
  depends_on = [aws_glue_catalog_database.datalake_databases]
}