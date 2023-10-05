variable "create_vpc" {
  type        = string
  description = "the flag to create the VPC if set to true. In this project, create_vpc should be false as Fiesta team will pre create the VPC"
  default     = false
}

variable "vpc_cidr" {
  type        = string
  description = "the IPV4 cidr block used for creating the VPC and subnets. The VPC, subnets, CIDR should all be pre created before veritas execution"
  default     = "10.0.0.0/16"
}

variable "vpc_id" {
  type        = string
  description = "exsiting vpc id to be used"
  default     = ""
}

variable "intra_subnet_ids" {
  type        = list(string)
  description = "two exsiting intra subent ids without internet access"
  default     = []
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "two exsiting private subent ids with egress internet access through NAT"
  default     = []
}

variable "vpc_sg_id" {
  type        = string
  description = "security group id attached to the VPC endpoints (used by intra subntes)"
  default     = ""
}

variable "mwaa_env_version" {
  type        = string
  description = "the version of apache Airflow supported by MWAA"
  default     = "2.2.2"
}

variable "mwaa_logs_retention_in_days" {
  type        = number
  description = "amazon MWAA logs retenton period in days"
  default     = 30
}

variable "kms_deletion_window_in_days" {
  type        = number
  description = "Amazon KMS key deletion window in days"
  default     = 7
}

variable "airflow_cli_runner_func_name" {
  type        = string
  description = "the name of the lambda fucntion for creating airflow conn, varaible, pool"
  default     = "airflow_cli_runner"
}

variable "resource_prefix" {
  type        = string
  description = "Prefix should be buName-customerNamer-envName"
  default     = "dev"
}

variable "mwaa_config" {
  type        = string
  description = "variable to input the mwaa config as string"
  default     = ""
}

variable "bucket_mwaa" {
  type        = map(string)
  description = "MWAA bucket to be created. P.S.:The keys will be used to compose the bucket name."

  default = {
    bucket_name       = "mwaa"
    bucket_versioning = "Enabled"
  }
}

variable "access_log_bucket" {
  type        = map(string)
  description = "MWAA bucket to be created. P.S.:The keys will be used to compose the bucket name."

  default = {
    bucket_name       = "access-logs"
    bucket_versioning = "Disabled"
  }
}

variable "lakeformation_role_name" {
  type        = string
  default     = "lf-admin-role"
  description = "Use default unless, you need to override the newly created IAM role for lake formation administration. Each resource name will automatically be prefixed with bu, pipeline, environment parameters"
}

variable "lakeformation_service_endpoint" {
  type        = string
  default     = "lakeformation.amazonaws.com"
  description = "Lake formation service end point. Do not override unless it is GCR (China)"
}

variable "deployment_role" {
  type        = string
  default     = "veritas-terraform-deploy-role"
  description = "This user should preexist, should have priviledges to create all aws resources mentioned in this repository. This user gets added as LF admin as well to perform LF operations."
}

variable "administrator_users" {
  type        = list(string)
  description = "List of existing users/roles who require an explitcit lake formation administrative priviledges. Note: account administrator does not automatically get LF administrative priviledges."
}