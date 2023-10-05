locals {
  bu_name      = lower(split("-", terraform.workspace)[0])
  account_role = lower(split("-", terraform.workspace)[1])
  env_name     = lower(split("-", terraform.workspace)[2])
  executor     = element(split("/", data.aws_caller_identity.current.arn), 1)
  tags = {
    bu_name      = lower(split("-", terraform.workspace)[0])
    account_role = lower(split("-", terraform.workspace)[1])
    env_name     = lower(split("-", terraform.workspace)[2])
    executor     = element(split("/", data.aws_caller_identity.current.arn), 1)
    cost-center  = "src-delivery-group"
  }
}

module "security_group" {
  source      = "terraform-aws-modules/security-group/aws"
  version     = "4.17.1"
  name        = "${local.bu_name}-${local.env_name}-vpc-sg"
  description = "${local.bu_name}-vpc security group for ${local.env_name} env"
  vpc_id      = var.vpc_id
  tags        = local.tags
}

module "vpc_endpoints" {
  source  = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version = "4.0.0"

  vpc_id             = var.vpc_id
  security_group_ids = [module.security_group.security_group_id]
  endpoints = {
    kms = {
      service             = "kms"
      private_dns_enabled = true
      subnet_ids          = var.private_subnet_ids
      tags                = { Name = "kms-vpce-${local.env_name}" }
    },
    airflow_api = {
      service             = "airflow.api"
      private_dns_enabled = true
      subnet_ids          = var.private_subnet_ids
      tags                = { Name = "airflowapi-vpce-${local.env_name}" }
    },
    airflow_env = {
      service             = "airflow.env"
      private_dns_enabled = true
      subnet_ids          = var.private_subnet_ids
      tags                = { Name = "airflowenv-vpce-${local.env_name}" }
    },
    lakeformation = {
      service             = "lakeformation"
      private_dns_enabled = true
      subnet_ids          = var.private_subnet_ids
      tags                = { Name = "lakeformation-vpce-${local.env_name}" }
    },
    airflow_ops = {
      service             = "airflow.ops"
      private_dns_enabled = true
      subnet_ids          = var.private_subnet_ids
      tags                = { Name = "airflowops-vpce-${local.env_name}" }
    }
  }
  tags = local.tags
}