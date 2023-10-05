output "lakeformation_administrator_role" {
  value = aws_iam_role.lakeformation_administrator
}

output "glue_crawler_arn" {
  value = aws_iam_role.glue_crawler.arn
}