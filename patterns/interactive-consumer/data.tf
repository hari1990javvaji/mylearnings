data "aws_caller_identity" "current" {}
data "aws_iam_session_context" "current" { arn = data.aws_caller_identity.current.arn }
data "aws_region" "current" {}
data "aws_partition" "current" {}

data "aws_iam_role" "deployment_role" {
  name = var.deployment_role
}

data "aws_iam_policy_document" "lakeformation_assume_role" {
  statement {
    effect  = "Allow"
    sid     = "LakeFormationAssumeRole"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = [var.lakeformation_service_endpoint]
    }
  }
}

data "aws_iam_policy_document" "lakeformation_administrator_inline" {
  #checkov:skip=CKV_AWS_111: Create table need * resource access

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


data "aws_iam_policy_document" "analyst_assume_role" {
  statement {
    effect  = "Allow"
    sid     = "DataAnalystAssumeRole"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }
}

data "aws_iam_policy_document" "athena_kms_key_policy" {
  #checkov:skip=CKV_AWS_111: astrisk represent current KMS key. https://docs.aws.amazon.com/kms/latest/developerguide/key-policy-overview.html
  #checkov:skip=CKV_AWS_109: astrisk represent current KMS key. https://docs.aws.amazon.com/kms/latest/developerguide/key-policy-overview.html
  statement {
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    actions   = ["kms:*"]
    resources = ["*"]
  }
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["logs.${data.aws_region.current.id}.amazonaws.com"]
    }
    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*"
    ]
    resources = ["*"]
    condition {
      test     = "ArnLike"
      variable = "kms:EncryptionContext:aws:logs:arn"
      values = [
        "arn:${data.aws_partition.current.partition}:logs:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:*"
      ]
    }
  }
}

data "aws_iam_policy_document" "analyst_inline" {
  #checkov:skip=CKV_AWS_111: Create table need * resource access

  statement {
    effect = "Allow"
    actions = [
      "lakeformation:GetDataAccess",
      "lakeformation:GetResourceLFTags",
      "lakeformation:ListLFTags",
      "lakeformation:GetLFTag",
      "lakeformation:SearchTablesByLFTags",
      "lakeformation:SearchDatabasesByLFTags",
      "lakeformation:StartQueryPlanning",
      "lakeformation:GetWorkUnits",
      "lakeformation:GetWorkUnitResults",
      "lakeformation:GetQueryState",
      "glue:GetTable",
      "glue:GetTables",
      "glue:SearchTables",
      "glue:GetDatabase",
      "glue:GetDatabases",
      "glue:GetPartitions",
      "athena:*",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucketMultipartUploads",
      "s3:ListMultipartUploadParts",
      "s3:AbortMultipartUpload",
      "s3:CreateBucket",
      "s3:PutObject",
      "s3:PutBucketPublicAccessBlock",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListAllMyBuckets",
      "sns:ListTopics",
      "sns:GetTopicAttributes",
      "cloudwatch:PutMetricAlarm",
      "cloudwatch:DescribeAlarms",
      "cloudwatch:DeleteAlarms",
      "cloudwatch:GetMetricData",
      "kms:Decrypt",
      "kms:Encrypt",
      "kms:GenerateDataKey"
    ]
    resources = ["*"]
  }
}


