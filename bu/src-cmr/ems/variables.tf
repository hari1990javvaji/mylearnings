variable "pipeline_name" {
  type        = string
  description = "Pipeline or report or function name. Usually represented by the folder (example: ems)"
}

variable "administrator_users" {
  type        = list(string)
  description = "List of existing users/roles who require an explitcit lake formation administrative priviledges. Note: account administrator does not automatically get LF administrative priviledges."
}

variable "athena_workgroups" {
  type        = any
  description = "athena workgroups in a map of objects data type. example, data engineer, analyst, scientist"
}