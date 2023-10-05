# Require TF version to be same as or greater than 1.3.1
# Teraform state S3 bucket and lock dynamoDB tables should exists prior to execution
# the backend is a combination of backend.tf and backend.hcl
terraform {
  required_version = ">=1.3.1"
  backend "s3" {
    bucket         = "veritas-daas-dev-terraform-state-705158173663-use1"
    dynamodb_table = "philips-veritas-terraform-execution-lock"
    encrypt        = true
  }
}