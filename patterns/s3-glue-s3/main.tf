
## Constants modules
module "constants" {
  source        = "../../modules/constants"
  pipeline_name = var.pipeline_name
  executor      = element(split("/", data.aws_caller_identity.current.arn), 1)
}

# KMS CMK for all data at rest (S3, dynamoDB, Secret Manager etc)
module "data_encryption_key" {
  source          = "../../modules/kms"
  resource_prefix = module.constants.resource_prefix
  tags            = module.constants.common_tags
  description     = "Customer managed kms key for data encryption in data lake"
  policy          = data.aws_iam_policy_document.encryption_key_data_policy.json
  alias           = var.data_encryption_key_alias
}

# KMS CMK for all processors (Glue, Lambda etc)
module "data_processing_key" {
  source          = "../../modules/kms"
  resource_prefix = module.constants.resource_prefix
  tags            = module.constants.common_tags
  description     = "Customer managed kms key for data processing in data lake"
  policy          = data.aws_iam_policy_document.processing_key_data_policy.json
  alias           = var.data_processing_key_alias
}

# Glue network connector for Data Lake Glue Jobs
# TO-DO vpc, region, AZ, subnet to be converted into a map
module "datalake_glue_connector" {
  source          = "../../modules/glue/connector"
  resource_prefix = module.constants.resource_prefix
  tags            = module.constants.common_tags
  vpc_id          = var.vpc_id
  aws_region      = data.aws_region.current.id
  subnet_id       = var.subnet_id
  name            = var.glue_connection_name
}

## Data Lake S3 buckets. raw, stage, analytics, etc. To add new bucket, edit variables.tf
module "s3" {
  source          = "../../modules/s3"
  resource_prefix = module.constants.resource_prefix
  tags            = module.constants.common_tags
  buckets         = var.datalake_buckets
  account_id      = data.aws_caller_identity.current.account_id
  region_name     = data.aws_region.current.id
  kms_key_arn     = module.data_encryption_key.key_arn
}

## Data Lake work groups for various roles data science, analytics, architecture etc
module "athena" {
  source              = "../../modules/athena/workgroups"
  resource_prefix     = module.constants.resource_prefix
  tags                = module.constants.common_tags
  bucket_query_result = module.s3.bucket_athena
  kms_key_arn         = module.data_encryption_key.key_arn
  athena_workgroups   = var.athena_workgroups
}

## Glue Crawler IAM role
module "glue_crawler_role" {
  source          = "../../modules/iam-simple"
  resource_prefix = module.constants.resource_prefix
  tags            = module.constants.common_tags
  assume_policy   = data.aws_iam_policy_document.glue_assume_role.json
  inline_policy   = data.aws_iam_policy_document.glue_crawler_inline.json
  role_name       = var.gluecrawler_role_name
}

# Glue catalogg databases raw, stage, analytics etc
module "glue_catalog" {
  source                  = "../../modules/glue/catalog"
  resource_prefix         = module.constants.resource_prefix
  tags                    = module.constants.common_tags
  datalake_layers_buckets = module.s3.buckets_nonsensitive
}

## Lake Formation with administrator role and user
module "lakeformation" {
  source                  = "../../modules/lakeformation-producer"
  resource_prefix         = module.constants.resource_prefix
  tags                    = module.constants.common_tags
  administrator_role      = var.lf_admin_role_arn
  datalake_layers_buckets = module.s3.buckets_nonsensitive
  glue_crawler_arn        = module.glue_crawler_role.iam_role.arn
  glue_databases          = module.glue_catalog.databases
  deployment_role         = data.aws_iam_role.deployment_role
  central_catalogs        = local.central_catalogs
  ## In Innovation account, the users are not assuming any role to login. Hence the users are required to get explicit lake formation admin role
  administrator_users = var.administrator_users
  depends_on          = [data.aws_iam_role.deployment_role, module.glue_crawler_role.iam_role, module.glue_catalog.databases]
}

# Glue crawler for raw, stage, analytics etc
module "glue_crawler" {
  source                     = "../../modules/glue/crawler"
  resource_prefix            = module.constants.resource_prefix
  tags                       = module.constants.common_tags
  datalake_layers_buckets    = module.s3.buckets_nonsensitive
  datalake-glue-connector-id = split(":", module.datalake_glue_connector.datalake-glue-connector-id)[1]
  glue_crawler_role          = module.glue_crawler_role.iam_role.arn
  glue_crawler_name          = "glue-crawler"
  depends_on                 = [module.lakeformation]
}

# Glue crawler to populate central DB from producer account
module "glue_crawler_cross_account" {
  source                     = "../../modules/glue/crawler-cross-account"
  resource_prefix            = module.constants.resource_prefix
  tags                       = module.constants.common_tags
  central_catalogs           = local.central_catalogs
  datalake-glue-connector-id = split(":", module.datalake_glue_connector.datalake-glue-connector-id)[1]
  glue_crawler_role          = module.glue_crawler_role.iam_role.arn
  glue_crawler_name          = "cross-crawler"
  depends_on                 = [module.lakeformation]
}

## Glue Service IAM role
module "glue_service_role" {
  source          = "../../modules/iam-simple"
  resource_prefix = module.constants.resource_prefix
  tags            = module.constants.common_tags
  assume_policy   = data.aws_iam_policy_document.glue_assume_role.json
  inline_policy   = data.aws_iam_policy_document.glue_crawler_inline.json
  role_name       = var.glueservice_role_name
}

## Glue service/job
## Glue jobs are serverless. It is recommeneded to make it part of application development lifecycle
## and not part of infrastructure provisioning
module "glue_service_job" {
  source                = "../../modules/glue/job"
  resource_prefix       = module.constants.resource_prefix
  tags                  = module.constants.common_tags
  jobs                  = var.datalake_glue_jobs
  glue_meta_s3_bucket   = module.s3.bucket_assets.bucket
  glue_service_iam_role = module.glue_service_role.iam_role.arn
  glue_connector        = split(":", module.datalake_glue_connector.datalake-glue-connector-id)[1]
  lib_name              = var.lib_name
  max_concurrent_runs   = var.max_concurrent_runs
}