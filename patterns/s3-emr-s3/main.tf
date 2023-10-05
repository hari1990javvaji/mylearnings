
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
#   sns_topics      = var.sns_topics
# }

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

## Update S3 bucket policy with central lf admin to access
module "s3_policy" {
  source           = "../../modules/s3-policy"
  resource_prefix  = module.constants.resource_prefix
  tags             = module.constants.common_tags
  central_catalogs = local.central_catalogs
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

## All IAM roles needed for Datalake. Includes glue service, crawler, lake formation administrator etc
module "iam" {
  source                    = "../../modules/iam"
  resource_prefix           = module.constants.resource_prefix
  tags                      = module.constants.common_tags
  buckets_nonsensitive_arns = module.s3.buckets_nonsensitive_arns
  lakeformation_role_name   = var.lakeformation_role_name
  gluecrawler_role_name     = var.gluecrawler_role_name
  lf_role_policy            = data.aws_iam_policy_document.lakeformation_administrator_inline.json
}

## Lake Formation with administrator role and user
module "lakeformation" {
  source                  = "../../modules/lakeformation"
  resource_prefix         = module.constants.resource_prefix
  tags                    = module.constants.common_tags
  administrator_role      = module.iam.lakeformation_administrator_role
  datalake_layers_buckets = module.s3.buckets_nonsensitive
  glue_crawler_arn        = module.iam.glue_crawler_arn
  glue_databases          = module.glue_catalog.databases
  deployment_role         = data.aws_iam_role.deployment_role
  central_catalogs        = local.central_catalogs
  ## In Innovation account, the users are not assuming any role to login. Hence the users are required to get explicit lake formation admin role
  administrator_users = var.administrator_users
  depends_on          = [data.aws_iam_role.deployment_role, module.iam.lakeformation_administrator_role]
}

# Glue catalogg databases raw, stage, analytics etc
module "glue_catalog" {
  source                  = "../../modules/glue/catalog"
  resource_prefix         = module.constants.resource_prefix
  tags                    = module.constants.common_tags
  datalake_layers_buckets = module.s3.buckets_nonsensitive
}

# Glue crawler for raw, stage, analytics etc
module "glue_crawler" {
  source                     = "../../modules/glue/crawler"
  resource_prefix            = module.constants.resource_prefix
  tags                       = module.constants.common_tags
  datalake_layers_buckets    = module.s3.buckets_nonsensitive
  datalake-glue-connector-id = split(":", module.datalake_glue_connector.datalake-glue-connector-id)[1]
  glue_crawler_role          = module.iam.glue_crawler_arn
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
  glue_crawler_role          = module.iam.glue_crawler_arn
  glue_crawler_name          = "cross-crawler"
  depends_on                 = [module.lakeformation]
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

# module "datalake_sm_template" {
#   source          = "../../modules/sm-template/"
#   resource_prefix = module.constants.resource_prefix
#   tags            = module.constants.common_tags
#   secret_name     = var.secret_name
#   kms_key_id      = module.data_encryption_key.key_id
# }

### emr module ###
module "emr_cluster" {
  for_each        = var.emr_config
  source          = "../../modules/emr/"
  resource_prefix = module.constants.resource_prefix
  tags            = merge(module.constants.common_tags, try(each.value.tags, {}))
  account_id      = data.aws_caller_identity.current.account_id
  region_name     = data.aws_region.current.id
  #master_allowed_security_groups                 = [module.vpc.vpc_default_security_group_id]
  #slave_allowed_security_groups                  = [module.vpc.vpc_default_security_group_id]
  region                                         = data.aws_region.current.id
  vpc_id                                         = var.vpc_id
  subnet_id                                      = var.subnet_id
  route_table_id                                 = var.route_table_id
  subnet_type                                    = "private"
  ebs_root_volume_size                           = each.value.ebs_root_volume_size
  visible_to_all_users                           = each.value.visible_to_all_users
  release_label                                  = each.value.release_label
  applications                                   = each.value.applications
  configurations_json                            = try(each.value.configurations_json, "")
  core_instance_group_instance_type              = each.value.core_instance_group_instance_type
  core_instance_group_instance_count             = each.value.core_instance_group_instance_count
  core_instance_group_ebs_size                   = each.value.core_instance_group_ebs_size
  core_instance_group_ebs_type                   = each.value.core_instance_group_ebs_type
  core_instance_group_ebs_volumes_per_instance   = each.value.core_instance_group_ebs_volumes_per_instance
  master_instance_group_instance_type            = each.value.master_instance_group_instance_type
  master_instance_group_instance_count           = each.value.master_instance_group_instance_count
  master_instance_group_ebs_size                 = each.value.master_instance_group_ebs_size
  master_instance_group_ebs_type                 = each.value.master_instance_group_ebs_type
  master_instance_group_ebs_volumes_per_instance = each.value.master_instance_group_ebs_volumes_per_instance
  create_task_instance_group                     = each.value.create_task_instance_group
  #log_uri                                        = format("s3://%s/", module.s3_log_storage.bucket_id)
  log_uri                 = format("s3://%s/", module.s3.bucket_emr_logs.bucket)
  cidr_egress             = each.value.cidr_egress
  data_processing_key_arn = module.data_processing_key.key_arn
  vpc_sg_id               = var.vpc_sg_id
}