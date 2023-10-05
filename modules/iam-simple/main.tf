resource "aws_iam_role" "iam_role" {
  name                  = format("%s-%s", var.resource_prefix, var.role_name)
  force_detach_policies = true

  assume_role_policy = var.assume_policy

  inline_policy {
    name   = format("%s-%s-%s", var.resource_prefix, var.role_name, "policy")
    policy = var.inline_policy
  }
  tags = merge(
    {
      "Description" = "Lake Formation administrator role"
    },
  var.tags)
}