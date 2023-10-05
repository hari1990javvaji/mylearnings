# Name of the pipeline / function / report for which this pattern is being created
pipeline_name = "cpap-report"

# Console login user should be added to lake formation administrator group in development environments. 
# else console user will not be able to view the glue db and tables managed by Lake Formation
administrator_users = ["arn:aws:iam::705158173663:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_AWSAdministratorAccess_e7674a7314c656b1"]


## Existing VPC ID. Create all lake house resources in same VPC
vpc_id = "vpc-0dd4ae3a8a4fb4826"

## Existing KMS vpc id ##
vpc_sg_id = "sg-0b491bb9c3261f99b"

# Subnet ID (eg, to create Glue Connector)
# TODO convert it to a list and accept private_subnet_ids
subnet_id = "subnet-0ada0733bf079e63c"


# Route Table ID (eg, to create S3 gatewat end point
# TODO End point creation should be outside entire lake house. 
route_table_id = "rtb-02db4ab6a540f513d"


# List of SNS topics to be created. To be used by various other AWS resources for notification
sns_topics = ["pipeline-error", "pipeline-success"]

## Secret ID. To be used by ETL jobs to store secrets. Secrets are keyed in manually
secret_name = "ad-score-etl-1"


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


### emr configs ###
emr_config = {
  ad-score-emr = {
    name                 = "report-emr"
    region               = "us-east-1"
    availability_zones   = ["us-east-1a"]
    ebs_root_volume_size = 10
    visible_to_all_users = true
    # https://docs.aws.amazon.com/emr/latest/ReleaseGuide/emr-release-components.html
    release_label = "emr-6.7.0"
    # https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-plan-ha-applications.html
    # https://docs.aws.amazon.com/emr/latest/ReleaseGuide/emr-670-release.html
    # https://github.com/hashicorp/terraform-provider-aws/issues/23226
    applications                                   = ["Hive", "Presto", "Spark"]
    core_instance_group_instance_type              = "m4.2xlarge"
    core_instance_group_instance_count             = 2
    core_instance_group_ebs_size                   = 10
    core_instance_group_ebs_type                   = "gp2"
    core_instance_group_ebs_volumes_per_instance   = 1
    master_instance_group_instance_type            = "m4.large"
    master_instance_group_instance_count           = 1
    master_instance_group_ebs_size                 = 10
    master_instance_group_ebs_type                 = "gp2"
    master_instance_group_ebs_volumes_per_instance = 1
    create_task_instance_group                     = false
    ssh_public_key_path                            = "/secrets"
    generate_ssh_key                               = true
    configurations_json                            = ""
    cidr_egress                                    = ["0.0.0.0/0"]
    vpc_sg_id                                      = "sg-0b491bb9c3261f99b"
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
