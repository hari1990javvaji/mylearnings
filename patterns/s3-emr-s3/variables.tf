variable "pipeline_name" {
  type        = string
  description = "Pipeline or report or function name. Usually represented by the folder (example: ems)"
}

variable "data_encryption_key_alias" {
  type        = string
  description = "Data encryption key alias"
  default     = "data-encryption-key"
}

variable "route_table_id" {
  type        = string
  description = "Route table ID for the VPC S3 Endpoint when launching the EMR cluster in a private subnet. Required when `subnet_type` is `private`"
  default     = ""
}

variable "data_processing_key_alias" {
  type        = string
  description = "Data processing key alias"
  default     = "data-processing-key"
}

variable "vpc_id" {
  type        = string
  description = "Customer account vpc id"
}

variable "vpc_sg_id" {
  type        = string
  description = "KMS vpc endpoint security id"
}


## TO-DO convert vpc, subnet, availability zone into a single map
variable "subnet_id" {
  type        = string
  description = "subnet id"
}

variable "datalake_buckets" {
  type = map(object({
    versioning = bool
    sensitive  = bool
    layer      = bool
  }))
  description = "Data Lake buckets to be created. P.S.:The keys will be used to compose the bucket name."

  default = {
    bronze = {
      versioning = true
      sensitive  = false
      layer      = true
    },
    silver = {
      versioning = true
      sensitive  = false
      layer      = true
    }
  }
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

# variable "glueservice_role_name" {
#   type    = string
#   default = "glue-service-role"
#   description = "Use default unless, you need to override the newly created IAM role for glue service role name. Each resource name will automatically be prefixed with bu, pipeline, environment parameters"
# }

# variable "stepfunction_role_name" {
#   type    = string
#   default = "step-function-role"
#   description = "Use default unless, you need to override the newly created IAM role for step function. Each resource name will automatically be prefixed with bu, pipeline, environment parameters"
# }

# variable "lambda_archiver_role_name" {
#   type        = string
#   description = "Use default unless, you need to override. IAM role for the lambda function used in archival"
#   default     = "lambda-archiver-role"
# }

# variable "lambda_trigger_role_name" {
#   type        = string
#   description = "Use default unless, you need to override. IAM role for the lambda function used in archival"
#   default     = "lambda-trigger-role"
# }

variable "sns_topics" {
  type        = set(string)
  default     = ["pipeline-error", "pipeline-success"]
  description = "SNS topic name. the resource_prefix will be prefixed to any aws resource created"
}

variable "secret_name" {
  type        = string
  description = "secret id name. the resource_prefix will be prefixed to any aws resource created"
}

variable "glue_connection_name" {
  type        = string
  default     = "glue-network-connection"
  description = "Use default unless, you need to override the glue connector name."
}


### emr variables ###

variable "emr_config" {
  description = "configuration to build emr clusters"
}

variable "athena_workgroups" {
  description = "athena workgroups in a map of objects data type. example, data engineer, analyst, scientist"
  default = {
    "data-engineering" = {
      "description" : "Data Engineering team workgroup"
      "bytes_scanned" : 21474836480
      "workgroup" : true
      "cloudwatch_enabled" : false
    },
    "data-architecture" = {
      "description" : "Data Architecture team workgroup"
    },
    "data-science" = {
      "description" : "Data Science team workgroup"
    },
    "data-analysis" = {
      "description" : "Data Analysis team workgroup"
    }
  }
}

variable "central_config" {
  type        = string
  description = "variable to input the central config. Refer to examples for concret central.json configuration"
  default     = ""
}