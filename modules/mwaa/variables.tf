variable "resource_prefix" {
  type        = string
  description = "Prefix should be buName-customerNamer-envName"
}

variable "env" {
  type    = string
  default = "dev"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "mwaa_bucket" {
  type = map(string)
}

variable "account_id" {
  type = string
}

variable "tags" {
  type = map(any)
}

variable "mwaa_env_name" {
  type = string
}

variable "airflow_version" {
  type = string
}

variable "mwaa_env_class" {
  type    = string
  default = "mw1.small"
}

variable "tasks_per_worker" {
  type = map(any)
  default = {
    "mw1.small"  = 5
    "mw1.medium" = 10
    "mw1.large"  = 20
  }
}

variable "mwaa_min_workers" {
  type    = number
  default = 1
}

variable "mwaa_max_workers" {
  type    = number
  default = 2
}

variable "webserver_access_mode" {
  type = string
}

variable "airflow_configs" {
  type = map(any)
}

variable "mwaa_logging_enabled" {
  type    = bool
  default = true
}

variable "mwaa_logging_level" {
  type    = string
  default = "INFO"
}

# variable "req_file_s3_path" {
#   type    = string
#   default = "requirements.txt"
# }

# variable "plugins_s3_path" {
#   type    = string
#   default = "plugins.zip"
# }

variable "dags_local_path" {
  type    = string
  default = ""
}

variable "req_file_local_path" {
  type = string
}

variable "plugins_local_path" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "intra_subnet_ids" {
  type = list(any)
}

variable "private_subnet_ids" {
  type = list(any)
}

variable "mwaa_logs_retention_in_days" {
  type = number
}

variable "kms_deletion_window_in_days" {
  type = number
}

variable "vpc_sg_id" {
  type = string
}

variable "mwaa_alerts_sns_topic_arn" {
  type = string
}

variable "kms_key" {
  type = string
}
# variable "airflow_cli_runner_sg_id" {
#   type = string
# }