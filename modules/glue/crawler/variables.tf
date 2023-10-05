#-----------------------------------------------------------
# Global or/and default variables
#-----------------------------------------------------------
variable "resource_prefix" {
  type        = string
  description = "Prefix should be buName-customerNamer-envName"
}

variable "tags" {
  description = "Mandatory normalized tags to tag the resources accordingly."
  type        = map(string)
}

variable "glue_crawler_name" {
  description = "Mandatory crawler name."
  type        = string
}

variable "datalake-glue-connector-id" {
  description = "Name to be glue network connection"
}

variable "glue_crawler_database_name" {
  description = "Glue database where results are written."
  default     = ""
}

variable "glue_crawler_role" {
  description = "(Required) The IAM role friendly name (including path without leading slash), or ARN of an IAM role, used by the crawler to access other resources."
  default     = ""
}

variable "glue_crawler_description" {
  description = "(Optional) Description of the crawler."
  default     = null
}

variable "glue_crawler_classifiers" {
  description = "(Optional) List of custom classifiers. By default, all AWS classifiers are included in a crawl, but these custom classifiers always override the default classifiers for a given classification."
  default     = null
}

variable "glue_crawler_configuration" {
  description = "(Optional) JSON string of configuration information."
  default     = null
}

variable "glue_crawler_schedule" {
  description = "(Optional) A cron expression used to specify the schedule. For more information, see Time-Based Schedules for Jobs and Crawlers. For example, to run something every day at 12:15 UTC, you would specify: cron(15 12 * * ? *)."
  default     = null
}

variable "use_lake_formation_credentials" {
  description = "Govern access through Lake Formation Credentials"
  default     = true
}

variable "glue_crawler_security_configuration" {
  description = "(Optional) The name of Security Configuration to be used by the crawler"
  default     = null
}

variable "glue_crawler_table_prefix" {
  description = "(Optional) The table prefix used for catalog tables that are created."
  default     = null
}

variable "datalake_layers_buckets" {
  type = list(object({
    layer  = string
    bucket = string
    arn    = string
  }))
}

variable "glue_crawler_schema_change_policy" {
  description = "(Optional) Policy for the crawler's update and deletion behavior."
  default     = []
}

variable "glue_crawler_recrawl_policy" {
  description = "Optional) A policy that specifies whether to crawl the entire dataset again, or to crawl only folders that were added since the last crawler run."
  default     = []
}

variable "glue_crawler_lineage_configuration" {
  description = "(Optional) Specifies data lineage configuration settings for the crawler."
  default     = []
}