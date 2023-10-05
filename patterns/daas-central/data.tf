data "aws_caller_identity" "current" {}
data "aws_iam_session_context" "current" { arn = data.aws_caller_identity.current.arn }
data "aws_region" "current" {}
data "aws_partition" "current" {}
data "aws_iam_role" "deployment_role" {
  name = var.deployment_role
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
  statement {
    effect = "Allow"
    actions = [
      "kms:Decrypt",
      "kms:Encrypt",
      "kms:GenerateDataKey",
    ]
    #resources = ["arn:${data.aws_partition.current.partition}:kms:us-east-1:${local.producer_account_id[0]}:key/*"]
    resources = setunion(formatlist("arn:%s:kms:%s:%s:key/*", data.aws_partition.current.partition, data.aws_region.current.id, local.producer_account_id))
  }
}



