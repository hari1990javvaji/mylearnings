output "mwaa_env_url" {
  value = "https://${aws_mwaa_environment.mwaa_env.webserver_url}/home"
}