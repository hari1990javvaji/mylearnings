<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_athena"></a> [athena](#module\_athena) | ../../modules/athena/workgroups | n/a |
| <a name="module_constants"></a> [constants](#module\_constants) | ../../modules/constants | n/a |
| <a name="module_data_encryption_key"></a> [data\_encryption\_key](#module\_data\_encryption\_key) | ../../modules/kms | n/a |
| <a name="module_data_processing_key"></a> [data\_processing\_key](#module\_data\_processing\_key) | ../../modules/kms | n/a |
| <a name="module_datalake_glue_connector"></a> [datalake\_glue\_connector](#module\_datalake\_glue\_connector) | ../../modules/glue/connector | n/a |
| <a name="module_glue_catalog"></a> [glue\_catalog](#module\_glue\_catalog) | ../../modules/glue/catalog | n/a |
| <a name="module_glue_crawler"></a> [glue\_crawler](#module\_glue\_crawler) | ../../modules/glue/crawler | n/a |
| <a name="module_glue_crawler_cross_account"></a> [glue\_crawler\_cross\_account](#module\_glue\_crawler\_cross\_account) | ../../modules/glue/crawler-cross-account | n/a |
| <a name="module_glue_crawler_role"></a> [glue\_crawler\_role](#module\_glue\_crawler\_role) | ../../modules/iam-simple | n/a |
| <a name="module_glue_service_job"></a> [glue\_service\_job](#module\_glue\_service\_job) | ../../modules/glue/job | n/a |
| <a name="module_glue_service_role"></a> [glue\_service\_role](#module\_glue\_service\_role) | ../../modules/iam-simple | n/a |
| <a name="module_lakeformation"></a> [lakeformation](#module\_lakeformation) | ../../modules/lakeformation-producer | n/a |
| <a name="module_s3"></a> [s3](#module\_s3) | ../../modules/s3 | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.encryption_key_data_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.glue_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.glue_crawler_inline](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.processing_key_data_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_role.deployment_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_role) | data source |
| [aws_iam_session_context.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_session_context) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_administrator_users"></a> [administrator\_users](#input\_administrator\_users) | List of existing users/roles who require an explitcit lake formation administrative priviledges. Note: account administrator does not automatically get LF administrative priviledges. | `list(string)` | n/a | yes |
| <a name="input_athena_workgroups"></a> [athena\_workgroups](#input\_athena\_workgroups) | athena workgroups in a map of objects data type. example, data engineer, analyst, scientist | `map` | <pre>{<br>  "data-analysis": {<br>    "description": "Data Analysis team workgroup"<br>  },<br>  "data-architecture": {<br>    "description": "Data Architecture team workgroup"<br>  },<br>  "data-engineering": {<br>    "bytes_scanned": 21474836480,<br>    "cloudwatch_enabled": false,<br>    "description": "Data Engineering team workgroup",<br>    "workgroup": true<br>  },<br>  "data-science": {<br>    "description": "Data Science team workgroup"<br>  }<br>}</pre> | no |
| <a name="input_central_config"></a> [central\_config](#input\_central\_config) | variable to input the central config. Refer to examples for concret central.json configuration | `string` | `""` | no |
| <a name="input_data_encryption_key_alias"></a> [data\_encryption\_key\_alias](#input\_data\_encryption\_key\_alias) | Data encryption key alias | `string` | `"data-encryption-key"` | no |
| <a name="input_data_processing_key_alias"></a> [data\_processing\_key\_alias](#input\_data\_processing\_key\_alias) | Data processing key alias | `string` | `"data-processing-key"` | no |
| <a name="input_datalake_buckets"></a> [datalake\_buckets](#input\_datalake\_buckets) | Data Lake buckets to be created. P.S.:The keys will be used to compose the bucket name. | <pre>map(object({<br>    versioning = bool<br>    sensitive  = bool<br>    layer      = bool<br>  }))</pre> | <pre>{<br>  "bronze": {<br>    "layer": true,<br>    "sensitive": false,<br>    "versioning": true<br>  },<br>  "silver": {<br>    "layer": true,<br>    "sensitive": false,<br>    "versioning": true<br>  }<br>}</pre> | no |
| <a name="input_datalake_glue_jobs"></a> [datalake\_glue\_jobs](#input\_datalake\_glue\_jobs) | Create multiple glue jobs for datalake | <pre>map(object({<br>    glue_job_name        = string<br>    glue_job_description = string<br>    script_name          = string<br>    job_bookmark         = string<br>  }))</pre> | <pre>{<br>  "hello_world": {<br>    "glue_job_description": "Job to write hello world csv to S3 bucket",<br>    "glue_job_name": "hello_world",<br>    "job_bookmark": "job-bookmark-disable",<br>    "script_name": "hello-world.py"<br>  }<br>}</pre> | no |
| <a name="input_deployment_role"></a> [deployment\_role](#input\_deployment\_role) | This user should preexist, should have priviledges to create all aws resources mentioned in this repository. This user gets added as LF admin as well to perform LF operations. | `string` | `"veritas-terraform-deploy-role"` | no |
| <a name="input_glue_connection_name"></a> [glue\_connection\_name](#input\_glue\_connection\_name) | Use default unless, you need to override the glue connector name. | `string` | `"glue-network-connection"` | no |
| <a name="input_glue_service_endpoint"></a> [glue\_service\_endpoint](#input\_glue\_service\_endpoint) | This is used for iam role assignment, changes for china | `string` | `"glue.amazonaws.com"` | no |
| <a name="input_gluecrawler_role_name"></a> [gluecrawler\_role\_name](#input\_gluecrawler\_role\_name) | Use default unless, you need to override the newly created IAM role for glue crawler. Each resource name will automatically be prefixed with bu, pipeline, environment parameters | `string` | `"glue-crawler-role"` | no |
| <a name="input_glueservice_role_name"></a> [glueservice\_role\_name](#input\_glueservice\_role\_name) | Use default unless, you need to override the newly created IAM role for glue service role name. Each resource name will automatically be prefixed with bu, pipeline, environment parameters | `string` | `"glue-service-role"` | no |
| <a name="input_lf_admin_role_arn"></a> [lf\_admin\_role\_arn](#input\_lf\_admin\_role\_arn) | ARN of the lake formation administrator IAM role in the current account. accout-common terraform module creates lf admin role | `string` | n/a | yes |
| <a name="input_lib_name"></a> [lib\_name](#input\_lib\_name) | glue job library name | `string` | `"ojdbc8.jar"` | no |
| <a name="input_max_concurrent_runs"></a> [max\_concurrent\_runs](#input\_max\_concurrent\_runs) | Max concurrent glue jobs | `number` | `5` | no |
| <a name="input_pipeline_name"></a> [pipeline\_name](#input\_pipeline\_name) | Pipeline or report or function name. Usually represented by the folder (example: ems) | `string` | n/a | yes |
| <a name="input_secret_name"></a> [secret\_name](#input\_secret\_name) | secret id name. the resource\_prefix will be prefixed to any aws resource created | `string` | n/a | yes |
| <a name="input_sns_topics"></a> [sns\_topics](#input\_sns\_topics) | SNS topic name. the resource\_prefix will be prefixed to any aws resource created | `set(string)` | <pre>[<br>  "pipeline-error",<br>  "pipeline-success"<br>]</pre> | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | subnet id | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | Customer account vpc id | `string` | n/a | yes |
| <a name="input_vpc_sg_id"></a> [vpc\_sg\_id](#input\_vpc\_sg\_id) | KMS vpc endpoint security id | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_s3_buckets"></a> [s3\_buckets](#output\_s3\_buckets) | n/a |
<!-- END_TF_DOCS -->