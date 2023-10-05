variable "pipeline_name" {
  type        = string
  description = "Pipeline name"
}

variable "vpc_id" {
  type        = string
  description = "Customer account vpc id"
}

variable "vpc_sg_id" {
  type        = string
  description = "vpc endpoing security id"
}

## TO-DO convert vpc, subnet, availability zone into a single map
variable "subnet_id" {
  type        = string
  description = "subnet id"
}

variable "route_table_id" {
  type        = string
  description = "route table id used for gateway vpc end points"
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
    },
    gold = {
      versioning = true
      sensitive  = false
      layer      = true
    }
    athena = {
      versioning = false
      sensitive  = false
      layer      = false
    },
    logs = {
      versioning = false
      sensitive  = false
      layer      = false
    },
    assets = {
      versioning = true
      sensitive  = false
      layer      = false
    }
  }
}

variable "administrator_users" {
  type        = list(string)
  description = "List of existing users/roles who require an explitcit lake formation administrative priviledges. Note: account administrator does not automatically get LF administrative priviledges."
}

variable "sns_topics" {
  type        = set(string)
  description = "SNS topic name. the resource_prefix will be prefixed to any aws resource created"
}

variable "secret_name" {
  type        = string
  description = "secret id name. the resource_prefix will be prefixed to any aws resource created"
}

# ### emr variables ###
variable "emr_config" {
  description = "configuration to build emr clusters"
}

variable "athena_workgroups" {
  description = "athena workgroups"
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
    }
  }
}