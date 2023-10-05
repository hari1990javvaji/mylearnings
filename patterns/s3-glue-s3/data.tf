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

      identifiers = concat([var.lf_admin_role_arn, module.glue_crawler_role.iam_role.arn], local.central_account_lf_admin_arn, [data.aws_iam_role.deployment_role.arn, module.glue_service_role.iam_role.arn])

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

data "aws_iam_policy_document" "glue_assume_role" {
  statement {
    effect  = "Allow"
    sid     = "GlueAssumeRole"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = [var.glue_service_endpoint]
    }
  }
}

data "aws_iam_policy_document" "glue_crawler_inline" {
  #checkov:skip=CKV_AWS_111: Lake Formation GetDataAcces can have astrisk as resource.
  #checkov:skip=CKV_AWS_110:https://docs.aws.amazon.com/glue/latest/dg/create-service-policy.html
  #checkov:skip=CKV_AWS_109:https://docs.aws.amazon.com/glue/latest/dg/create-service-policy.html
  statement {
    effect = "Allow"
    actions = [
      "lakeformation:GetDataAccess",
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "glue:*",
      "s3:GetBucketLocation",
      "s3:ListBucket",
      "s3:ListAllMyBuckets",
      "s3:GetBucketAcl",
      "ec2:DescribeVpcEndpoints",
      "ec2:DescribeRouteTables",
      "ec2:CreateNetworkInterface",
      "ec2:DeleteNetworkInterface",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSubnets",
      "ec2:DescribeVpcAttribute",
      "iam:ListRolePolicies",
      "iam:GetRole",
      "iam:GetRolePolicy",
      "cloudwatch:PutMetricData"
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]
    resources = local.bucket_resources
  }
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["arn:${data.aws_partition.current.partition}:logs:*:*:/aws-glue/*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "ec2:CreateTags",
      "ec2:DeleteTags"
    ]
    resources = [
      "arn:${data.aws_partition.current.partition}:ec2:*:*:network-interface/*",
      "arn:${data.aws_partition.current.partition}:ec2:*:*:security-group/*",
      "arn:${data.aws_partition.current.partition}:ec2:*:*:instance/*"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "kms:Decrypt",
      "kms:Encrypt",
      "kms:GenerateDataKey",
    ]
    resources = ["*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]
    resources = ["${local.asset_bucket_resources}", "${local.asset_bucket_resources}/*"]
  }
}
