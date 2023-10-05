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

variable "producer_catalogs" {
  type = list(object({
    producer   = string
    account_id = string
    catalog    = string
    bucket     = string
    layer      = string
  }))
}

variable "consumer_catalogs" {
  type = list(object({
    consumer   = string
    account_id = string
    catalog    = string
    glue_db    = string
    layer      = string
  }))
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


variable "producer_database_permissions" {
  type = set(string)

  default = ["CREATE_TABLE", "ALTER", "DESCRIBE"]
}

variable "consumer_database_permissions" {
  type = set(string)

  default = ["DESCRIBE"]
}

variable "table_permissions" {
  type = set(string)

  default = ["SELECT", "INSERT", "ALTER", "DESCRIBE"]
}

