## Base Configuration
## Set lake formation administrators under "administrative roles and tasks"
## Based on the organizational need, lake formation administrator can be common or specific to data pipeline

resource "aws_lakeformation_data_lake_settings" "base" {
  admins = concat([var.administrator_role.arn, var.deployment_role.arn], var.administrator_users)
}