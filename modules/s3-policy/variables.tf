variable "resource_prefix" {
  type        = string
  description = "Prefix should be buName-customerNamer-envName"
}

variable "tags" {
  description = "Mandatory normalized tags to tag the resources accordingly."
  type        = map(string)
}

variable "central_catalogs" {
  type = list(object({
    central    = string
    account_id = string
    lf_admin   = string
    catalog    = string
    glue_db    = string
    s3_bucket  = string
    layer      = string
  }))
}