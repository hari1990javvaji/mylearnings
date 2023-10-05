
## Change account number for each environment. Ensure the IAM role is created and has the priveldges to create the needed resources
## A strict one-to-one mapping between terraform workspace and AWS environment
## An AWS account has host multiple environments. Make sure that every resource that gets created is environment specific. Else ResourceAlreadyExists exception
## Workspace is a combination of business unit and environment in the format <bu>-<env>
## Change workspace to BU-CustomerName-Environment if the customer specific resources are to be created

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
