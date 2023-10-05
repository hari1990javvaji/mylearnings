variable "resource_prefix" {
  type        = string
  description = "Prefix should be buName-customerNamer-envName"
}

variable "tags" {
  description = "Mandatory normalized tags to tag the resources accordingly."
  type        = map(string)
}

variable "glue_database_mask" {
  type    = string
  default = "%s-%s" #prefix_datalakeS3Bucket
}

variable "datalake_layers_buckets" {
  type = list(object({
    layer  = string
    bucket = string
    arn    = string
  }))
}