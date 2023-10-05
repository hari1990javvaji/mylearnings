output "common_tags" {
  value = {
    bu_name       = lower(split("-", terraform.workspace)[0])
    account_role  = lower(split("-", terraform.workspace)[1])
    env_name      = lower(split("-", terraform.workspace)[2])
    pipeline_name = var.pipeline_name
    executor      = var.executor
    cost-center   = "src-delivery-group"
  }
}

output "bu_name" {
  value = lower(split("-", terraform.workspace)[0])
}

output "account_role" {
  value = lower(split("-", terraform.workspace)[1])
}

output "env_name" {
  value = lower(split("-", terraform.workspace)[2])
}

output "pipeline_name" {
  value = var.pipeline_name
}

output "resource_prefix" {
  value = format("%s-%s", terraform.workspace, var.pipeline_name)
}