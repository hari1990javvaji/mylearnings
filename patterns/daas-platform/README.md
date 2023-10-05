## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_access_log_encryption_key"></a> [access\_log\_encryption\_key](#module\_access\_log\_encryption\_key) | ../../modules/kms | n/a |
| <a name="module_access_log_s3"></a> [access\_log\_s3](#module\_access\_log\_s3) | ../../modules/s3-simple | n/a |
| <a name="module_constants"></a> [constants](#module\_constants) | ../../modules/constants | n/a |
| <a name="module_mwaa_encryption_key"></a> [mwaa\_encryption\_key](#module\_mwaa\_encryption\_key) | ../../modules/kms | n/a |
| <a name="module_mwaa_env"></a> [mwaa\_env](#module\_mwaa\_env) | ../../modules/mwaa | n/a |
| <a name="module_mwaa_s3"></a> [mwaa\_s3](#module\_mwaa\_s3) | ../../modules/s3-simple | n/a |
| <a name="module_sns"></a> [sns](#module\_sns) | ../../modules/sns | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.alerts_topic_publish_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.alerts_topic_publish_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [null_resource.are_vpc_vars_valid](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.access_logs_key_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.mwaa_kms_key_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_session_context.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_session_context) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_log_bucket"></a> [access\_log\_bucket](#input\_access\_log\_bucket) | MWAA bucket to be created. P.S.:The keys will be used to compose the bucket name. | `map(string)` | <pre>{<br>  "bucket_name": "access-logs",<br>  "bucket_versioning": "Disabled"<br>}</pre> | no |
| <a name="input_airflow_cli_runner_func_name"></a> [airflow\_cli\_runner\_func\_name](#input\_airflow\_cli\_runner\_func\_name) | the name of the lambda fucntion for creating airflow conn, varaible, pool | `string` | `"airflow_cli_runner"` | no |
| <a name="input_bucket_mwaa"></a> [bucket\_mwaa](#input\_bucket\_mwaa) | MWAA bucket to be created. P.S.:The keys will be used to compose the bucket name. | `map(string)` | <pre>{<br>  "bucket_name": "mwaa",<br>  "bucket_versioning": "Enabled"<br>}</pre> | no |
| <a name="input_create_vpc"></a> [create\_vpc](#input\_create\_vpc) | the flag to create the VPC if set to true | `string` | `false` | no |
| <a name="input_intra_subnet_ids"></a> [intra\_subnet\_ids](#input\_intra\_subnet\_ids) | two exsiting intra subent ids without internet access | `list(string)` | `[]` | no |
| <a name="input_kms_deletion_window_in_days"></a> [kms\_deletion\_window\_in\_days](#input\_kms\_deletion\_window\_in\_days) | Amazon KMS key deletion window in days | `number` | `7` | no |
| <a name="input_mwaa_env_version"></a> [mwaa\_env\_version](#input\_mwaa\_env\_version) | the version of apache Airflow supported by MWAA | `string` | `"2.2.2"` | no |
| <a name="input_mwaa_logs_retention_in_days"></a> [mwaa\_logs\_retention\_in\_days](#input\_mwaa\_logs\_retention\_in\_days) | amazon MWAA logs retenton period in days | `number` | `30` | no |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | two exsiting private subent ids with egress internet access through NAT | `list(string)` | `[]` | no |
| <a name="input_resource_prefix"></a> [resource\_prefix](#input\_resource\_prefix) | Prefix should be buName-customerNamer-envName | `string` | `"dev"` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | the IPV4 cidr block used for creating the VPC and subnets | `string` | `"10.0.0.0/16"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | exsiting vpc id to be used | `string` | `""` | no |
| <a name="input_vpc_sg_id"></a> [vpc\_sg\_id](#input\_vpc\_sg\_id) | security group id attached to the VPC endpoints (used by intra subntes) | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_mwaa_env_url"></a> [mwaa\_env\_url](#output\_mwaa\_env\_url) | webserver url for each mwaa environemnt |

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_access_log_encryption_key"></a> [access\_log\_encryption\_key](#module\_access\_log\_encryption\_key) | ../../modules/kms | n/a |
| <a name="module_access_log_s3"></a> [access\_log\_s3](#module\_access\_log\_s3) | ../../modules/s3-simple | n/a |
| <a name="module_constants"></a> [constants](#module\_constants) | ../../modules/constants | n/a |
| <a name="module_lakeformation_admin_role"></a> [lakeformation\_admin\_role](#module\_lakeformation\_admin\_role) | ../../modules/iam-simple | n/a |
| <a name="module_lakeformation_permissions"></a> [lakeformation\_permissions](#module\_lakeformation\_permissions) | ../../modules/lakeformation-common | n/a |
| <a name="module_mwaa_encryption_key"></a> [mwaa\_encryption\_key](#module\_mwaa\_encryption\_key) | ../../modules/kms | n/a |
| <a name="module_mwaa_env"></a> [mwaa\_env](#module\_mwaa\_env) | ../../modules/mwaa | n/a |
| <a name="module_mwaa_s3"></a> [mwaa\_s3](#module\_mwaa\_s3) | ../../modules/s3-simple | n/a |
| <a name="module_sns"></a> [sns](#module\_sns) | ../../modules/sns | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.alerts_topic_publish_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.alerts_topic_publish_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [null_resource.are_vpc_vars_valid](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.access_logs_key_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.lakeformation_administrator_inline](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.lakeformation_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.mwaa_kms_key_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_role.deployment_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_role) | data source |
| [aws_iam_session_context.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_session_context) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_log_bucket"></a> [access\_log\_bucket](#input\_access\_log\_bucket) | MWAA bucket to be created. P.S.:The keys will be used to compose the bucket name. | `map(string)` | <pre>{<br>  "bucket_name": "access-logs",<br>  "bucket_versioning": "Disabled"<br>}</pre> | no |
| <a name="input_administrator_users"></a> [administrator\_users](#input\_administrator\_users) | List of existing users/roles who require an explitcit lake formation administrative priviledges. Note: account administrator does not automatically get LF administrative priviledges. | `list(string)` | n/a | yes |
| <a name="input_airflow_cli_runner_func_name"></a> [airflow\_cli\_runner\_func\_name](#input\_airflow\_cli\_runner\_func\_name) | the name of the lambda fucntion for creating airflow conn, varaible, pool | `string` | `"airflow_cli_runner"` | no |
| <a name="input_bucket_mwaa"></a> [bucket\_mwaa](#input\_bucket\_mwaa) | MWAA bucket to be created. P.S.:The keys will be used to compose the bucket name. | `map(string)` | <pre>{<br>  "bucket_name": "mwaa",<br>  "bucket_versioning": "Enabled"<br>}</pre> | no |
| <a name="input_create_vpc"></a> [create\_vpc](#input\_create\_vpc) | the flag to create the VPC if set to true. In this project, create\_vpc should be false as Fiesta team will pre create the VPC | `string` | `false` | no |
| <a name="input_deployment_role"></a> [deployment\_role](#input\_deployment\_role) | This user should preexist, should have priviledges to create all aws resources mentioned in this repository. This user gets added as LF admin as well to perform LF operations. | `string` | `"veritas-terraform-deploy-role"` | no |
| <a name="input_intra_subnet_ids"></a> [intra\_subnet\_ids](#input\_intra\_subnet\_ids) | two exsiting intra subent ids without internet access | `list(string)` | `[]` | no |
| <a name="input_kms_deletion_window_in_days"></a> [kms\_deletion\_window\_in\_days](#input\_kms\_deletion\_window\_in\_days) | Amazon KMS key deletion window in days | `number` | `7` | no |
| <a name="input_lakeformation_role_name"></a> [lakeformation\_role\_name](#input\_lakeformation\_role\_name) | Use default unless, you need to override the newly created IAM role for lake formation administration. Each resource name will automatically be prefixed with bu, pipeline, environment parameters | `string` | `"lf-admin-role"` | no |
| <a name="input_lakeformation_service_endpoint"></a> [lakeformation\_service\_endpoint](#input\_lakeformation\_service\_endpoint) | Lake formation service end point. Do not override unless it is GCR (China) | `string` | `"lakeformation.amazonaws.com"` | no |
| <a name="input_mwaa_config"></a> [mwaa\_config](#input\_mwaa\_config) | variable to input the mwaa config as string | `string` | `""` | no |
| <a name="input_mwaa_env_version"></a> [mwaa\_env\_version](#input\_mwaa\_env\_version) | the version of apache Airflow supported by MWAA | `string` | `"2.2.2"` | no |
| <a name="input_mwaa_logs_retention_in_days"></a> [mwaa\_logs\_retention\_in\_days](#input\_mwaa\_logs\_retention\_in\_days) | amazon MWAA logs retenton period in days | `number` | `30` | no |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | two exsiting private subent ids with egress internet access through NAT | `list(string)` | `[]` | no |
| <a name="input_resource_prefix"></a> [resource\_prefix](#input\_resource\_prefix) | Prefix should be buName-customerNamer-envName | `string` | `"dev"` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | the IPV4 cidr block used for creating the VPC and subnets. The VPC, subnets, CIDR should all be pre created before veritas execution | `string` | `"10.0.0.0/16"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | exsiting vpc id to be used | `string` | `""` | no |
| <a name="input_vpc_sg_id"></a> [vpc\_sg\_id](#input\_vpc\_sg\_id) | security group id attached to the VPC endpoints (used by intra subntes) | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_mwaa_env_url"></a> [mwaa\_env\_url](#output\_mwaa\_env\_url) | webserver url for each mwaa environemnt |
<!-- END_TF_DOCS -->