## Constants modules
module "constants" {
  source        = "../../modules/constants"
  pipeline_name = "common"
  executor      = element(split("/", data.aws_caller_identity.current.arn), 1)
}


# assertion for valid VPC variables (vpc_id, intra_subnet_ids, private_subnet_ids) if user chooses to use existing VPC and subnets
# will fail the trafform plan/apply if the create_vpc is set to false but one of above variables are not provided. 
resource "null_resource" "are_vpc_vars_valid" {
  count = (!var.create_vpc && (var.vpc_id == "" || var.vpc_sg_id == "" || length(var.intra_subnet_ids) == 0 || length(var.private_subnet_ids) == 0)) ? "ERROR: VPC variables are not valid" : 0
}

# KMS CMK for for access logs 
module "access_log_encryption_key" {
  source          = "../../modules/kms"
  resource_prefix = module.constants.resource_prefix
  tags            = module.constants.common_tags
  description     = "Customer managed kms key for access logs encryption"
  policy          = data.aws_iam_policy_document.access_logs_key_policy.json
  alias           = local.access_log_encryption_key_alias

}

# KMS CMK for for MWAA 
module "mwaa_encryption_key" {
  source          = "../../modules/kms"
  resource_prefix = module.constants.resource_prefix
  tags            = module.constants.common_tags
  description     = "Customer managed kms key for MWAA encryption"
  policy          = data.aws_iam_policy_document.mwaa_kms_key_policy.json
  alias           = local.mwaa_encryption_key_alias
}

## Global access logs S3 buckets
module "access_log_s3" {
  source          = "../../modules/s3-simple"
  resource_prefix = module.constants.resource_prefix
  tags            = module.constants.common_tags
  bucket          = var.access_log_bucket
  kms_key_arn     = module.mwaa_encryption_key.key_arn
}

## MWAA S3 buckets
module "mwaa_s3" {
  source            = "../../modules/s3-simple"
  resource_prefix   = module.constants.resource_prefix
  tags              = module.constants.common_tags
  bucket            = var.bucket_mwaa
  kms_key_arn       = module.mwaa_encryption_key.key_arn
  bucket_access_log = { bucket_access_log = module.access_log_s3.bucket_info.bucket, enable_bucket_access_log = true }
}

## Data Lake SNS topics to send success and failure events
module "sns" {
  source          = "../../modules/sns"
  resource_prefix = module.constants.resource_prefix
  tags            = module.constants.common_tags
  sns_topics      = local.sns_topics
}

module "mwaa_env" {
  for_each = {
    # merging environemnt specific config into the default config (overriding the default config)
    for key, env_config in local.mwaa_configs["mwaa_envs"] : key =>
    merge(
      local.mwaa_configs["default_configs"],
      env_config,
      { "name" = key },
      { airflow_configs = merge(
        local.mwaa_configs["default_configs"]["airflow_configs"],
        lookup(env_config, "airflow_configs", {})
        )
      }
    )
  }
  source                      = "../../modules/mwaa"
  resource_prefix             = module.constants.resource_prefix
  mwaa_env_name               = format("%s-%s", module.constants.resource_prefix, each.value.name)
  vpc_id                      = var.vpc_id
  intra_subnet_ids            = var.intra_subnet_ids
  private_subnet_ids          = var.private_subnet_ids
  vpc_sg_id                   = var.vpc_sg_id
  account_id                  = data.aws_caller_identity.current.account_id
  region                      = data.aws_region.current.id
  mwaa_logs_retention_in_days = var.mwaa_logs_retention_in_days
  kms_deletion_window_in_days = var.kms_deletion_window_in_days
  airflow_version             = each.value.mwaa_env_version
  airflow_configs             = each.value.airflow_configs
  mwaa_env_class              = each.value.mwaa_env_class
  mwaa_max_workers            = each.value.max_workers
  mwaa_min_workers            = each.value.min_workers
  mwaa_logging_enabled        = each.value.logging_enabled
  mwaa_logging_level          = each.value.logging_level
  webserver_access_mode       = each.value.webserver_access_mode
  dags_local_path             = each.value.dags_local_path
  req_file_local_path         = each.value.req_file_local_path
  plugins_local_path          = each.value.plugins_local_path
  mwaa_alerts_sns_topic_arn   = element(module.sns.sns_topics_arn, 0)
  kms_key                     = module.mwaa_encryption_key.key_arn
  mwaa_bucket                 = module.mwaa_s3.bucket_info
  #airflow_cli_runner_sg_id    = module.airflow_cli_runner_sg.security_group_id
  tags = module.constants.common_tags
}

resource "aws_iam_role" "alerts_topic_publish_role" {
  description = "this role is assumable by CloudWatch service to publish Alarms to the SNS topic"
  tags        = module.constants.common_tags
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = ["cloudwatch.amazonaws.com"]
        }
      }
    ]
  })
  managed_policy_arns = [
    aws_iam_policy.alerts_topic_publish_policy.arn
  ]
}

resource "aws_iam_policy" "alerts_topic_publish_policy" {
  description = "allows cloudwatch to publish alarms to the alerts topic"
  tags        = module.constants.common_tags
  policy = jsonencode(
    {
      "Version" : "2012-10-17"
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : "sns:Publish",
          "Resource" : element(module.sns.sns_topics_arn, 0)
          "Condition" : {
            "ArnLike" : {
              "aws:SourceArn" : [
                "arn:${data.aws_partition.current.partition}:cloudwatch:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:alarm:${module.constants.resource_prefix}*"
              ]
            }
          }
        }
      ]
    }
  )
}

## Lake Formation administrator IAM role - Common for the entire account
module "lakeformation_admin_role" {
  source          = "../../modules/iam-simple"
  resource_prefix = module.constants.resource_prefix
  tags            = module.constants.common_tags
  assume_policy   = data.aws_iam_policy_document.lakeformation_assume_role.json
  inline_policy   = data.aws_iam_policy_document.lakeformation_administrator_inline.json
  role_name       = var.lakeformation_role_name
}

## Add Lake Formation IAM role to Lake Formation as administrator
module "lakeformation_permissions" {
  source              = "../../modules/lakeformation-common"
  resource_prefix     = module.constants.resource_prefix
  tags                = module.constants.common_tags
  administrator_role  = module.lakeformation_admin_role.iam_role
  deployment_role     = data.aws_iam_role.deployment_role
  administrator_users = var.administrator_users
  depends_on          = [data.aws_iam_role.deployment_role, module.lakeformation_admin_role.iam_role]
}
