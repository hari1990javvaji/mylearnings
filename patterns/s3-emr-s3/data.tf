locals {
  ## Generate the list of EMR cluster output
  emr_service_role_arn_list = [for key, value in var.emr_config : module.emr_cluster[key].emr_service_role_arn]
  emr_ec2_role_arn_list     = [for key, value in var.emr_config : module.emr_cluster[key].emr_ec2_role_arn]
}

data "aws_caller_identity" "current" {}

data "aws_iam_session_context" "current" {
  arn = data.aws_caller_identity.current.arn
}

data "aws_region" "current" {}
data "aws_partition" "current" {}

data "aws_iam_role" "deployment_role" {
  name = var.deployment_role
}

data "aws_iam_policy_document" "encryption_key_data_policy" {
  #checkov:skip=CKV_AWS_111: astrisk represent current KMS key. https://docs.aws.amazon.com/kms/latest/developerguide/key-policy-overview.html
  #checkov:skip=CKV_AWS_109: astrisk represent current KMS key. https://docs.aws.amazon.com/kms/latest/developerguide/key-policy-overview.html
  # astrisk repreent the current KMS key and hence it is okay with have *

  statement {
    sid    = "Enable IAM User Permissions"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    actions   = ["kms:*"]
    resources = ["*"]
  }
  statement {
    sid    = "Allow access for lake formation Administrators"
    effect = "Allow"
    principals {
      type = "AWS"

      identifiers = concat([module.iam.lakeformation_administrator_role.arn, module.iam.glue_crawler_arn], local.emr_service_role_arn_list, local.emr_ec2_role_arn_list, local.central_account_lf_admin_arn, [data.aws_iam_role.deployment_role.arn, data.aws_caller_identity.current.arn])

    }
    actions = [
      "kms:DescribeKey",
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*"
    ]
    resources = ["*"]
  }
}


data "aws_iam_policy_document" "processing_key_data_policy" {
  #checkov:skip=CKV_AWS_111: astrisk represent current KMS key. https://docs.aws.amazon.com/kms/latest/developerguide/key-policy-overview.html
  #checkov:skip=CKV_AWS_109: astrisk represent current KMS key. https://docs.aws.amazon.com/kms/latest/developerguide/key-policy-overview.html
  # astrisk repreent the current KMS key and hence it is okay with have *

  statement {
    sid    = "Enable IAM User Permissions"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    actions   = ["kms:*"]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "lakeformation_administrator_inline" {
  #checkov:skip=CKV_AWS_111: Create table need * resource access

  statement {
    effect = "Allow"
    actions = [
      "s3:Get*",
      "s3:List*"
    ]
    resources = local.bucket_resources
  }
  statement {
    effect = "Allow"
    actions = [
      "lakeformation:*",
      "cloudtrail:DescribeTrails",
      "cloudtrail:LookupEvents",
      "glue:GetDatabase",
      "glue:GetDatabases",
      "glue:CreateDatabase",
      "glue:UpdateDatabase",
      "glue:DeleteDatabase",
      "glue:GetConnections",
      "glue:SearchTables",
      "glue:GetTable",
      "glue:CreateTable",
      "glue:UpdateTable",
      "glue:DeleteTable",
      "glue:GetTableVersions",
      "glue:GetPartitions",
      "glue:GetTables",
      "glue:GetWorkflow",
      "glue:ListWorkflows",
      "glue:BatchGetWorkflows",
      "glue:DeleteWorkflow",
      "glue:GetWorkflowRuns",
      "glue:StartWorkflowRun",
      "glue:GetWorkflow",
      "s3:ListBucket",
      "s3:GetBucketLocation",
      "s3:ListAllMyBuckets",
      "s3:GetBucketAcl",
      "iam:ListUsers",
      "iam:ListRoles",
      "iam:GetRole",
      "iam:GetRolePolicy"
    ]
    resources = ["*"]
  }
}
