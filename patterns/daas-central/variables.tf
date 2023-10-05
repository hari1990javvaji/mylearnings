variable "lakeformation_role_name" {
  type        = string
  default     = "lake-formation-admin-role"
  description = "Use default unless, you need to override the newly created IAM role for lake formation administration. Each resource name will automatically be prefixed with bu, pipeline, environment parameters"
}

variable "gluecrawler_role_name" {
  type        = string
  default     = "glue-crawler-role"
  description = "Use default unless, you need to override the newly created IAM role for glue crawler. Each resource name will automatically be prefixed with bu, pipeline, environment parameters"
}

variable "producers_config" {
  type        = string
  description = "variable to input the central config. Refer to examples for concret producers.json configuration"
  default     = ""
}

variable "consumers_config" {
  type        = string
  description = "variable to input the central config. Refer to examples for concret consumers.json configuration"
  default     = ""
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

variable "pipeline_name" {
  type        = string
  description = "Pipeline or report or function name. Usually represented by the folder (example: ems)"
}