resource "aws_iam_policy" "mwaa_iam_policy" {
  name = "${var.mwaa_env_name}-mwaa-policy"
  policy = jsonencode(
    {
      "Version" : "2012-10-17"
      "Statement" : [
        {
          "Action" : "airflow:PublishMetrics",
          "Effect" : "Allow",
          "Resource" : "arn:${data.aws_partition.current.partition}:airflow:${var.region}:${var.account_id}:environment/${var.mwaa_env_name}",
        },
        {
          "Action" : "s3:ListAllMyBuckets",
          "Effect" : "Deny",
          "Resource" : [
            "${var.mwaa_bucket["arn"]}",
            "${var.mwaa_bucket["arn"]}/*"
          ]
        },
        {
          "Action" : [
            "s3:List*",
            "s3:GetObject*",
            "s3:GetEncryptionConfiguration",
            "s3:GetBucket*"
          ],
          "Effect" : "Allow",
          "Resource" : [
            "${var.mwaa_bucket["arn"]}",
            "${var.mwaa_bucket["arn"]}/*"
          ]
        },
        {
          "Action" : [
            "logs:PutLogEvents",
            "logs:GetQueryResults",
            "logs:GetLogRecord",
            "logs:GetLogGroupFields",
            "logs:GetLogEvents",
            "logs:CreateLogStream",
            "logs:CreateLogGroup"
          ],
          "Effect" : "Allow",
          "Resource" : "arn:${data.aws_partition.current.partition}:logs:${var.region}:${var.account_id}:log-group:airflow-${var.mwaa_env_name}-*"
        },
        {
          "Action" : "logs:DescribeLogGroups",
          "Effect" : "Allow",
          "Resource" : "*",
          "Sid" : ""
        },
        {
          "Action" : "s3:GetAccountPublicAccessBlock",
          "Effect" : "Allow",
          "Resource" : "*",
          "Sid" : ""
        },
        {
          "Action" : "cloudwatch:PutMetricData",
          "Effect" : "Allow",
          "Resource" : "*",
          "Sid" : ""
        },
        {
          "Action" : [
            "sqs:SendMessage",
            "sqs:ReceiveMessage",
            "sqs:GetQueueUrl",
            "sqs:GetQueueAttributes",
            "sqs:DeleteMessage",
            "sqs:ChangeMessageVisibility"
          ],
          "Effect" : "Allow",
          "Resource" : "arn:${data.aws_partition.current.partition}:sqs:${var.region}:*:airflow-celery-*"
        },
        {
          "Action" : [
            "kms:GenerateDataKey*",
            "kms:Encrypt",
            "kms:DescribeKey",
            "kms:Decrypt"
          ],
          "Condition" : {
            "StringLike" : {
              "kms:ViaService" : [
                "sqs.${var.region}.amazonaws.com",
                "s3.${var.region}.amazonaws.com"
              ]
            }
          },
          "Effect" : "Allow",
          "Resource" : var.kms_key
        },
        {
          "Effect" : "Allow",
          "Action" : "eks:DescribeCluster",
          "Resource" : "arn:${data.aws_partition.current.partition}:eks:us-east-1:425326896067:cluster/*"
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "elasticmapreduce:*",
            "ec2:DescribeRouteTables"
          ],
          "Resource" : "*"
        },
        {
          "Sid" : "VisualEditor1",
          "Effect" : "Allow",
          "Action" : [
            "iam:PassRole"
          ],
          "Resource" : [
            "arn:${data.aws_partition.current.partition}:iam::${var.account_id}:role/${var.resource_prefix}*"
          ]
        }
      ]
    }
  )
}