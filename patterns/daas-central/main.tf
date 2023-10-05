## Constants modules
module "constants" {
  source        = "../../modules/constants"
  pipeline_name = var.pipeline_name
  executor      = element(split("/", data.aws_caller_identity.current.arn), 1)
}



## Data Lake SNS topics to send success and failure events
# module "sns" {
#   source          = "../../modules/sns"
#   resource_prefix = module.constants.resource_prefix
#   tags            = module.constants.common_tags
#   sns_topics      = local.sns_topics
# }

## All IAM roles needed for Datalake. Includes glue service, crawler, lake formation administrator etc
module "iam" {
  source                    = "../../modules/iam"
  resource_prefix           = module.constants.resource_prefix
  tags                      = module.constants.common_tags
  buckets_nonsensitive_arns = local.s3_bucket_arns
  lakeformation_role_name   = var.lakeformation_role_name
  gluecrawler_role_name     = var.gluecrawler_role_name
  lf_role_policy            = data.aws_iam_policy_document.lakeformation_administrator_inline.json
}

## Lake formation permissions for producer catalog to both producer and consumer accounts
module "lakeformation_permissions" {
  source              = "../../modules/lakeformation-central"
  resource_prefix     = module.constants.resource_prefix
  tags                = module.constants.common_tags
  producer_catalogs   = local.producer_catalogs
  consumer_catalogs   = local.consumer_catalogs
  administrator_role  = module.iam.lakeformation_administrator_role
  deployment_role     = data.aws_iam_role.deployment_role
  administrator_users = var.administrator_users
  depends_on          = [data.aws_iam_role.deployment_role, module.iam.lakeformation_administrator_role]
}