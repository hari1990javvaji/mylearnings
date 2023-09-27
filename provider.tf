# -- provider.tf (Provider) -- #
terraform {
  required_version = ">=1.5.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.9.0"
    }
  }
}


provider "aws" {
  region  = var.aws_region
  profile = "javvaji"
}