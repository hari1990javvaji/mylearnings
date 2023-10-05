variable "jobs" {
  type = map(object({
    glue_job_name        = string
    glue_job_description = string
    script_name          = string
    job_bookmark         = string
  }))
}
variable "glue_meta_s3_bucket" {
  type        = string
  description = "Library Used for Glue Job"
}

variable "glue_connector" {
  type        = string
  description = "Glue Connector Name"
}

variable "glue_service_iam_role" {
  type        = string
  description = "IAM Role for Glue service to assume"
}

variable "lib_name" {
  type        = string
  description = "Library Used for Glue Jo"
}

variable "max_concurrent_runs" {
  type        = number
  description = "Max glue concurrent jobs"

}

variable "tags" {
  description = "Mandatory normalized tags to tag the resources accordingly."
  type        = map(string)
}

variable "resource_prefix" {
  type        = string
  description = "AWS resource prefix. It is a combination of various inputs to make the data pipeline unique"
}