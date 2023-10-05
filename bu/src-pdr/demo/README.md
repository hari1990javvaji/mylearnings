## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.3.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_src-co-report-s3-emr-s3"></a> [src-co-report-s3-emr-s3](#module\_src-co-report-s3-emr-s3) | ../../../patterns/s3-emr-s3 | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_administrator_users"></a> [administrator\_users](#input\_administrator\_users) | n/a | `list(string)` | n/a | yes |
| <a name="input_applications"></a> [applications](#input\_applications) | A list of applications for the cluster. Valid values are: Flink, Ganglia, Hadoop, HBase, HCatalog, Hive, Hue, JupyterHub, Livy, Mahout, MXNet, Oozie, Phoenix, Pig, Presto, Spark, Sqoop, TensorFlow, Tez, Zeppelin, and ZooKeeper (as of EMR 5.25.0). Case insensitive | `list(string)` | n/a | yes |
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | List of availability zones | `list(string)` | n/a | yes |
| <a name="input_configurations_json"></a> [configurations\_json](#input\_configurations\_json) | A JSON string for supplying list of configurations for the EMR cluster | `string` | `""` | no |
| <a name="input_core_instance_group_ebs_size"></a> [core\_instance\_group\_ebs\_size](#input\_core\_instance\_group\_ebs\_size) | Core instances volume size, in gibibytes (GiB) | `number` | n/a | yes |
| <a name="input_core_instance_group_ebs_type"></a> [core\_instance\_group\_ebs\_type](#input\_core\_instance\_group\_ebs\_type) | Core instances volume type. Valid options are `gp2`, `io1`, `standard` and `st1` | `string` | n/a | yes |
| <a name="input_core_instance_group_ebs_volumes_per_instance"></a> [core\_instance\_group\_ebs\_volumes\_per\_instance](#input\_core\_instance\_group\_ebs\_volumes\_per\_instance) | The number of EBS volumes with this configuration to attach to each EC2 instance in the Core instance group | `number` | n/a | yes |
| <a name="input_core_instance_group_instance_count"></a> [core\_instance\_group\_instance\_count](#input\_core\_instance\_group\_instance\_count) | Target number of instances for the Core instance group. Must be at least 1 | `number` | n/a | yes |
| <a name="input_core_instance_group_instance_type"></a> [core\_instance\_group\_instance\_type](#input\_core\_instance\_group\_instance\_type) | EC2 instance type for all instances in the Core instance group | `string` | n/a | yes |
| <a name="input_create_task_instance_group"></a> [create\_task\_instance\_group](#input\_create\_task\_instance\_group) | Whether to create an instance group for Task nodes. For more info: https://www.terraform.io/docs/providers/aws/r/emr_instance_group.html, https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-master-core-task-nodes.html | `bool` | n/a | yes |
| <a name="input_datalake_buckets"></a> [datalake\_buckets](#input\_datalake\_buckets) | Data Lake buckets to be created. P.S.:The keys will be used to compose the bucket name. | <pre>map(object({<br>    versioning = bool<br>    sensitive  = bool<br>    layer      = bool<br>  }))</pre> | <pre>{<br>  "assets": {<br>    "layer": false,<br>    "sensitive": false,<br>    "versioning": true<br>  },<br>  "athena": {<br>    "layer": false,<br>    "sensitive": false,<br>    "versioning": false<br>  },<br>  "bronze": {<br>    "layer": true,<br>    "sensitive": false,<br>    "versioning": true<br>  },<br>  "gold": {<br>    "layer": true,<br>    "sensitive": false,<br>    "versioning": true<br>  },<br>  "logs": {<br>    "layer": false,<br>    "sensitive": false,<br>    "versioning": false<br>  },<br>  "silver": {<br>    "layer": true,<br>    "sensitive": false,<br>    "versioning": true<br>  }<br>}</pre> | no |
| <a name="input_ebs_root_volume_size"></a> [ebs\_root\_volume\_size](#input\_ebs\_root\_volume\_size) | Size in GiB of the EBS root device volume of the Linux AMI that is used for each EC2 instance. Available in Amazon EMR version 4.x and later | `number` | n/a | yes |
| <a name="input_function_name"></a> [function\_name](#input\_function\_name) | Report name | `string` | n/a | yes |
| <a name="input_generate_ssh_key"></a> [generate\_ssh\_key](#input\_generate\_ssh\_key) | If set to `true`, new SSH key pair will be created | `bool` | n/a | yes |
| <a name="input_master_instance_group_ebs_size"></a> [master\_instance\_group\_ebs\_size](#input\_master\_instance\_group\_ebs\_size) | Master instances volume size, in gibibytes (GiB) | `number` | n/a | yes |
| <a name="input_master_instance_group_ebs_type"></a> [master\_instance\_group\_ebs\_type](#input\_master\_instance\_group\_ebs\_type) | Master instances volume type. Valid options are `gp2`, `io1`, `standard` and `st1` | `string` | n/a | yes |
| <a name="input_master_instance_group_ebs_volumes_per_instance"></a> [master\_instance\_group\_ebs\_volumes\_per\_instance](#input\_master\_instance\_group\_ebs\_volumes\_per\_instance) | The number of EBS volumes with this configuration to attach to each EC2 instance in the Master instance group | `number` | n/a | yes |
| <a name="input_master_instance_group_instance_count"></a> [master\_instance\_group\_instance\_count](#input\_master\_instance\_group\_instance\_count) | Target number of instances for the Master instance group. Must be at least 1 | `number` | n/a | yes |
| <a name="input_master_instance_group_instance_type"></a> [master\_instance\_group\_instance\_type](#input\_master\_instance\_group\_instance\_type) | EC2 instance type for all instances in the Master instance group | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Project name | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | n/a | yes |
| <a name="input_release_label"></a> [release\_label](#input\_release\_label) | The release label for the Amazon EMR release. https://docs.aws.amazon.com/emr/latest/ReleaseGuide/emr-release-5x.html | `string` | n/a | yes |
| <a name="input_route_table_id"></a> [route\_table\_id](#input\_route\_table\_id) | subnet id | `string` | n/a | yes |
| <a name="input_secret_name"></a> [secret\_name](#input\_secret\_name) | n/a | `string` | n/a | yes |
| <a name="input_sns_topics"></a> [sns\_topics](#input\_sns\_topics) | n/a | `set(string)` | n/a | yes |
| <a name="input_ssh_public_key_path"></a> [ssh\_public\_key\_path](#input\_ssh\_public\_key\_path) | Path to SSH public key directory (e.g. `/secrets`) | `string` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | subnet id | `string` | n/a | yes |
| <a name="input_visible_to_all_users"></a> [visible\_to\_all\_users](#input\_visible\_to\_all\_users) | Whether the job flow is visible to all IAM users of the AWS account associated with the job flow | `bool` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | Customer account vpc id | `string` | n/a | yes |
| <a name="input_workspace_iam_roles"></a> [workspace\_iam\_roles](#input\_workspace\_iam\_roles) | # Change account number for each environment. Ensure the IAM role is created and has the priveldges to create the needed resources # A strict one-to-one mapping between terraform workspace and AWS environment # An AWS account has host multiple environments. Make sure that every resource that gets created is environment specific. Else ResourceAlreadyExists exception | `map` | <pre>{<br>  "src-dev": "arn:aws:iam::194732148124:role/philips-fiesta-terraform-deploy-role",<br>  "src-prd": "arn:aws:iam::194732148124:role/philips-fiesta-terraform-deploy-role",<br>  "src-tst": "arn:aws:iam::194732148124:role/philips-fiesta-terraform-deploy-role"<br>}</pre> | no |

## Outputs

No outputs.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.3.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.66.1 |
| <a name="provider_local"></a> [local](#provider\_local) | 2.4.0 |
| <a name="provider_null"></a> [null](#provider\_null) | 3.2.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_s3_bucket_object.mwaa_upload](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object) | resource |
| [local_file.mwaa_config_file_template](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [null_resource.raw_s3_bucket_cp](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_mwaa_bucket_name"></a> [mwaa\_bucket\_name](#input\_mwaa\_bucket\_name) | mwaa bucket name | `string` | n/a | yes |
| <a name="input_mwaa_config"></a> [mwaa\_config](#input\_mwaa\_config) | mwaa configuration inputs from tfvars | `any` | n/a | yes |
| <a name="input_raw_bucket"></a> [raw\_bucket](#input\_raw\_bucket) | raw s3 bucket | `string` | n/a | yes |
| <a name="input_sample_file_pattern"></a> [sample\_file\_pattern](#input\_sample\_file\_pattern) | file pattern to copy into the raw bucket | `any` | n/a | yes |
| <a name="input_workspace_iam_roles"></a> [workspace\_iam\_roles](#input\_workspace\_iam\_roles) | n/a | `map` | <pre>{<br>  "src-pdr-dev": "arn:aws:iam::705158173663:role/veritas-terraform-deploy-role"<br>}</pre> | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->