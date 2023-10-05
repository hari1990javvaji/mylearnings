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

variable "deployment_role" {
  type = any
}

variable "analyst_role_name" {
  type = any
}


variable "consumer_database_permissions" {
  type = set(string)

  default = ["CREATE_TABLE", "ALTER", "DESCRIBE"]
}

variable "consumer_table_permissions" {
  type = set(string)

  default = ["SELECT", "INSERT", "ALTER", "DESCRIBE"]
}

variable "central_database_permissions" {
  type = set(string)

  default = ["DESCRIBE"]
}

variable "link_database_permissions" {
  type = set(string)

  default = ["ALL", "DESCRIBE", "DROP"]
  #default = ["ALL", "DESCRIBE", "DROP"]
}

variable "central_catalogs" {
  type = list(object({
    central    = string
    account_id = string
    catalog    = string
    glue_db    = string
    s3_bucket  = string
    layer      = string
  }))
}

