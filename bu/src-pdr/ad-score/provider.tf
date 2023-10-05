## Terraform workspace should be in the format <bu>-<account_role>-<env>
## Example: src-pdr-dev. Here SRC is business unit. PDR is producer account role. DEV is environment
## veritas-terraform-deploy-role iam role with administrative priviledges is a prequisite
## GitHub environments and secrets is a prequisite
variable "workspace_iam_roles" {
  default = {
    src-pdr-dev = "arn:aws:iam::705158173663:role/veritas-terraform-deploy-role"
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  assume_role {
    role_arn = var.workspace_iam_roles[terraform.workspace]
  }
}
