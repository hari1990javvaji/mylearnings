variable "resource_prefix" {
  type        = string
  description = "Prefix should be buName-customerNamer-envName"
}

variable "tags" {
  description = "Mandatory normalized tags to tag the resources accordingly."
  type        = map(string)
}

variable "buckets" {
  type = map(object({
    versioning = bool
    sensitive  = bool
    layer      = bool
  }))
}

variable "bucket_name_label" {
  type    = string
  default = "%s-%s-%s-%s" #oprefix-bucketkey-awsregion-awsaccountid
}

variable "region_name" {
  type        = string
  description = "AWS Region name"
}

variable "kms_key_arn" {
  type        = string
  description = "KMS key ARN for S3 SSE KMS"
}

variable "account_id" {
  type        = string
  description = "AWS account id."
}

variable "bucket_key_enabled" {
  type        = string
  default     = "true"
  description = "Reduce calls to KMS by enabling bucket key"
}

variable "bucket_encryption" {
  type = map(string)
  default = {
    algorithm : "aws:kms"
    kms_id : ""
  }
}