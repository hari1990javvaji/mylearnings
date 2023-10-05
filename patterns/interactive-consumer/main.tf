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

## Lake Formation administrator IAM role
module "lakeformation_admin_role" {
  source          = "../../modules/iam-simple"
  resource_prefix = module.constants.resource_prefix
  tags            = module.constants.common_tags
  assume_policy   = data.aws_iam_policy_document.lakeformation_assume_role.json
  inline_policy   = data.aws_iam_policy_document.lakeformation_administrator_inline.json
  role_name       = var.lakeformation_role_name
}

# KMS CMK for Athena workgroups
module "athena_encryption_key" {
  source          = "../../modules/kms"
  resource_prefix = module.constants.resource_prefix
  tags            = module.constants.common_tags
  description     = "Customer managed kms key for Athena encryption"
  policy          = data.aws_iam_policy_document.athena_kms_key_policy.json
  alias           = local.athena_encryption_key_alias
}

## Athena S3 buckets
module "athena_s3" {
  source          = "../../modules/s3-simple"
  resource_prefix = module.constants.resource_prefix
  tags            = module.constants.common_tags
  bucket          = var.athena_query_bucket
  kms_key_arn     = module.athena_encryption_key.key_arn
}

## Data Lake work groups for various roles data science, analytics, architecture etc
module "athena" {
  source              = "../../modules/athena/workgroups"
  resource_prefix     = module.constants.resource_prefix
  tags                = module.constants.common_tags
  bucket_query_result = module.athena_s3.bucket_info
  kms_key_arn         = module.athena_encryption_key.key_arn
  athena_workgroups   = var.athena_workgroups
}

## Data Analyst IAM role
module "data_analyst_role" {
  source          = "../../modules/iam-simple"
  resource_prefix = module.constants.resource_prefix
  tags            = module.constants.common_tags
  assume_policy   = data.aws_iam_policy_document.analyst_assume_role.json
  inline_policy   = data.aws_iam_policy_document.analyst_inline.json
  role_name       = var.analyst_role_name
}

## Lake formation permissions for producer catalog to both producer and consumer accounts
module "lakeformation_permissions" {
  source              = "../../modules/lakeformation-consumer"
  resource_prefix     = module.constants.resource_prefix
  tags                = module.constants.common_tags
  administrator_role  = module.lakeformation_admin_role.iam_role
  deployment_role     = data.aws_iam_role.deployment_role
  administrator_users = var.administrator_users
  analyst_role_name   = module.data_analyst_role.iam_role.arn
  central_catalogs    = local.central_catalogs
  depends_on          = [data.aws_iam_role.deployment_role, module.lakeformation_admin_role.iam_role]
}