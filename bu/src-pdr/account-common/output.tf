output "airflow_environment" {
  value       = module.account_common_daas_platform.mwaa_env_url
  description = "MWAA environment URL"
}