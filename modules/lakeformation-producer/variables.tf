variable "resource_prefix" {
  type        = string
  description = "Prefix should be buName-customerNamer-envName"
}

variable "tags" {
  description = "Mandatory normalized tags to tag the resources accordingly."
  type        = map(string)
}

variable "administrator_role" {
  type = any
}

variable "administrator_users" {
  type    = list(string)
  default = [""]
}

variable "glue_crawler_arn" {
  type = string
}

variable "datalake_layers_buckets" {
  type = list(object({
    layer  = string
    bucket = string
    arn    = string
  }))
}

variable "glue_databases" {
  type = map(object({
    name = string
  }))
}

variable "gluecrawler_database_permissions" {
  type = set(string)

  default = ["CREATE_TABLE", "ALTER", "DESCRIBE"]
}

variable "gluecrawler_table_permissions" {
  type = set(string)

  default = ["SELECT", "INSERT", "ALTER", "DESCRIBE"]
}

variable "glueservice_database_permissions" {
  type = set(string)

  default = ["DESCRIBE"]
}

variable "grant_on_target_database_permissions" {
  type = set(string)

  default = ["CREATE_TABLE", "ALTER", "DESCRIBE"]
}

variable "link_database_permissions" {
  type = set(string)

  default = ["DESCRIBE"]
}

variable "glueservice_table_permissions" {
  type = set(string)

  default = ["SELECT"]
}

variable "deployment_role" {
  type = any
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