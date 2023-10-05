# Name of the pipeline / function / report for which this pattern is being created
pipeline_name = "patient-care"

# Console login user should be added to lake formation administrator group in development environments. 
# else console user will not be able to view the glue db and tables managed by Lake Formation
administrator_users = ["arn:aws:iam::705158173663:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_AWSAdministratorAccess_e7674a7314c656b1"]

# Lake Formation administrator IAM role ARN. This is generated in account-common terraform module
lf_admin_role_arn = "arn:aws:iam::705158173663:role/src-pdr-dev-common-lf-admin-role"

## Existing VPC ID. Create all lake house resources in same VPC
vpc_id = "vpc-0dd4ae3a8a4fb4826"

## Existing KMS vpc id ##
vpc_sg_id = "sg-0b491bb9c3261f99b"

# Subnet ID (eg, to create Glue Connector)
# TODO convert it to a list and accept private_subnet_ids
subnet_id = "subnet-0ada0733bf079e63c"


# List of SNS topics to be created. To be used by various other AWS resources for notification
sns_topics = ["pipeline-error", "pipeline-success"]

## Secret ID. To be used by ETL jobs to store secrets. Secrets are keyed in manually
secret_name = "patient-care-etl-1"


## List of S3 buckets part of Lake house
## Layer - if layer is true, glue crawler is created, registered in lake formation etc
datalake_buckets = {
  raw = {
    versioning = true
    sensitive  = false
    layer      = true
  },
  stage = {
    versioning = true
    sensitive  = false
    layer      = true
  },
  analytics = {
    versioning = true
    sensitive  = false
    layer      = true
  }
  athena = {
    versioning = true
    sensitive  = false
    layer      = false
  },
  assets = {
    versioning = true
    sensitive  = false
    layer      = false
  }
  emrlogs = {
    versioning = true
    sensitive  = false
    layer      = false
  }
}

athena_workgroups = {
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
