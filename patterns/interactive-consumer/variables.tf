variable "lakeformation_service_endpoint" {
  type        = string
  default     = "lakeformation.amazonaws.com"
  description = "Lake formation service end point. Do not override unless it is GCR (China)"
}

variable "lakeformation_role_name" {
  type        = string
  default     = "lake-formation-admin-role"
  description = "Use default unless, you need to override the newly created IAM role for lake formation administration. Each resource name will automatically be prefixed with bu, pipeline, environment parameters"
}

variable "analyst_role_name" {
  type        = string
  default     = "data-analyst-role"
  description = "Use default unless, you need to override the newly created IAM role for data analyst. Each resource name will automatically be prefixed with bu, pipeline, environment parameters"
}

variable "pipeline_name" {
  type        = string
  description = "Pipeline or report or function name. Usually represented by the folder (example: ems)"
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

variable "central_config" {
  type        = string
  description = "variable to input the central config. Refer to central.json for format"
  default     = ""
}

variable "athena_workgroups" {
  description = "athena workgroups in a map of objects data type. example, data engineer, analyst, scientist"
}

variable "athena_query_bucket" {
  type        = map(string)
  description = "Athena query bucket to be created. P.S.:The keys will be used to compose the bucket name."

  default = {
    bucket_name       = "athena-query"
    bucket_versioning = "Disabled"
  }
}