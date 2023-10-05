output "mwaa_env_url" {
  description = "webserver url for each mwaa environemnt"
  value = {
    for k, env in module.mwaa_env : k => env.mwaa_env_url
  }
}