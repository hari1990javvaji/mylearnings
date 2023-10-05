
variable "mwaa_bucket_name" {
  type        = string
  description = "mwaa bucket name"
}

variable "raw_bucket" {
  type = string

  description = "raw s3 bucket"
}

variable "mwaa_config" {
  description = "mwaa configuration inputs from tfvars"
}

variable "sample_file_pattern" {
  description = "file pattern to copy into the raw bucket"
}

  