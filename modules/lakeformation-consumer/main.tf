# Base Configuration
# Set lake formation administrators under "administrative roles and tasks"
resource "aws_lakeformation_data_lake_settings" "base" {
  admins = concat([var.administrator_role.arn, var.deployment_role.arn], var.administrator_users)
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

## Grant on link glue database to analyst role
resource "aws_lakeformation_permissions" "grant_on_link_db" {
  for_each = { for b in var.central_catalogs : b.layer => b }

  permissions                   = var.central_database_permissions
  permissions_with_grant_option = var.central_database_permissions
  principal                     = var.analyst_role_name

  database {
    name = format("%s-%s-%s", "link", var.resource_prefix, each.key)
  }
  depends_on = [aws_glue_catalog_database.link_databases]
}

## Grant on link glue database to console user role
resource "aws_lakeformation_permissions" "grant_on_link_db_to_console_user" {
  for_each = { for b in var.central_catalogs : b.layer => b }

  permissions                   = var.link_database_permissions
  permissions_with_grant_option = var.link_database_permissions
  principal                     = var.administrator_users[0]

  database {
    name = format("%s-%s-%s", "link", var.resource_prefix, each.key)
  }
  depends_on = [aws_glue_catalog_database.link_databases]
}

## Grant on shared glue database to analyst role
resource "aws_lakeformation_permissions" "grant_on_shared_db_analyst" {
  for_each = { for b in var.central_catalogs : b.layer => b }

  permissions                   = var.central_database_permissions
  permissions_with_grant_option = var.central_database_permissions
  principal                     = var.analyst_role_name

  database {
    name       = each.value.glue_db
    catalog_id = each.value.account_id
  }
  depends_on = [aws_glue_catalog_database.link_databases]
}

## Grant on shared glue database to console user role
resource "aws_lakeformation_permissions" "grant_on_shared_db_to_console_user" {
  for_each = { for b in var.central_catalogs : b.layer => b }

  permissions                   = var.central_database_permissions
  permissions_with_grant_option = var.central_database_permissions
  principal                     = var.administrator_users[0]

  database {
    name       = each.value.glue_db
    catalog_id = each.value.account_id
  }
  depends_on = [aws_glue_catalog_database.link_databases]
}


## Grant on link glue database (all tables) to analyst role
# resource "aws_lakeformation_permissions" "grant_on_link_db_tables" {
#   for_each = { for b in var.central_catalogs : b.layer => b }

#   permissions                   = var.central_database_permissions
#   permissions_with_grant_option = var.central_database_permissions
#   principal                     = var.analyst_role_name

#   table {
#     target_database = each.value.glue_db
#     wildcard      = "true"
#   }
#   depends_on = [aws_glue_catalog_database.link_databases]
# }