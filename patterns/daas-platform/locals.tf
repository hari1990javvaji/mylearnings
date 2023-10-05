locals {
  mwaa_configs                    = jsondecode(var.mwaa_config)
  subnets                         = var.create_vpc ? cidrsubnets(var.vpc_cidr, 4, 4, 4, 4, 4, 4) : []
  access_log_encryption_key_alias = "access-logs-key"
  mwaa_encryption_key_alias       = "mwaa-app-key"
  sns_topics                      = ["mwaa-alerts"]
  mwaa_bucket = {
    bucket_name       = "mwaa"
    bucket_versioning = "Enabled"
  }

}

