variable "pipeline_name" {
  type        = string
  description = "Pipeline or report or function name. Usually represented by the folder (example: ems)"
}

variable "data_encryption_key_alias" {
  type        = string
  description = "Data encryption key alias"
  default     = "data-encryption-key"
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

variable "gluecrawler_role_name" {
  type        = string
  default     = "glue-crawler-role"
  description = "Use default unless, you need to override the newly created IAM role for glue crawler. Each resource name will automatically be prefixed with bu, pipeline, environment parameters"
}

variable "lf_admin_role_arn" {
  type        = string
  description = "ARN of the lake formation administrator IAM role in the current account. accout-common terraform module creates lf admin role"
}

variable "glueservice_role_name" {
  type        = string
  default     = "glue-service-role"
  description = "Use default unless, you need to override the newly created IAM role for glue service role name. Each resource name will automatically be prefixed with bu, pipeline, environment parameters"
}

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

variable "glue_service_endpoint" {
  type        = string
  default     = "glue.amazonaws.com"
  description = "This is used for iam role assignment, changes for china"
}

variable "datalake_glue_jobs" {
  type = map(object({
    glue_job_name        = string
    glue_job_description = string
    script_name          = string
    job_bookmark         = string
  }))
  description = "Create multiple glue jobs for datalake"

  default = {
    hello_world = {
      glue_job_name        = "hello_world"
      glue_job_description = "Job to write hello world csv to S3 bucket"
      script_name          = "hello-world.py"
      job_bookmark         = "job-bookmark-disable"
    }
  }
}

variable "lib_name" {
  type        = string
  description = "glue job library name"
  default     = "ojdbc8.jar"
}

variable "max_concurrent_runs" {
  type        = number
  default     = 5
  description = "Max concurrent glue jobs"
}