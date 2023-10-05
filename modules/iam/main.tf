resource "aws_iam_role" "lakeformation_administrator" {
  name                  = format("%s-%s", var.resource_prefix, var.lakeformation_role_name)
  force_detach_policies = true

  assume_role_policy = data.aws_iam_policy_document.lakeformation_assume_role.json

  inline_policy {
    name   = format("%s-%s-%s", var.resource_prefix, var.lakeformation_role_name, "policy")
    policy = var.lf_role_policy
  }
  tags = merge(
    {
      "Description" = "Lake Formation administrator role"
    },
  var.tags)
}

resource "aws_iam_role" "glue_crawler" {
  name                  = format("%s-%s", var.resource_prefix, var.gluecrawler_role_name)
  assume_role_policy    = data.aws_iam_policy_document.glue_assume_role.json
  force_detach_policies = true

  inline_policy {
    name   = format("%s-%s", var.resource_prefix, "glue-crawler-policy")
    policy = data.aws_iam_policy_document.glue_crawler_inline.json
  }
  tags = merge(
    {
      "Description" = "IAM role for datalake glue crawler to assume"
    },
  var.tags)
}
