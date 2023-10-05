## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.3.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.55.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_athena"></a> [athena](#module\_athena) | ./modules/athena/workgroups | n/a |
| <a name="module_constants"></a> [constants](#module\_constants) | ./modules/constants | n/a |
| <a name="module_data_encryption_key"></a> [data\_encryption\_key](#module\_data\_encryption\_key) | ./modules/kms | n/a |
| <a name="module_data_processing_key"></a> [data\_processing\_key](#module\_data\_processing\_key) | ./modules/kms | n/a |
| <a name="module_datalake_glue_analytics_database_tables"></a> [datalake\_glue\_analytics\_database\_tables](#module\_datalake\_glue\_analytics\_database\_tables) | ./modules/athena/glue-tables | n/a |
| <a name="module_datalake_glue_connector"></a> [datalake\_glue\_connector](#module\_datalake\_glue\_connector) | ./modules/glue/connector | n/a |
| <a name="module_datalake_glue_raw_database_tables"></a> [datalake\_glue\_raw\_database\_tables](#module\_datalake\_glue\_raw\_database\_tables) | ./modules/athena/glue-tables | n/a |
| <a name="module_datalake_glue_stage_database_tables"></a> [datalake\_glue\_stage\_database\_tables](#module\_datalake\_glue\_stage\_database\_tables) | ./modules/athena/glue-tables | n/a |
| <a name="module_datalake_sm_template"></a> [datalake\_sm\_template](#module\_datalake\_sm\_template) | ./modules/sm-template/ | n/a |
| <a name="module_dynamodb_column_mapping"></a> [dynamodb\_column\_mapping](#module\_dynamodb\_column\_mapping) | ./modules/dynamodb | n/a |
| <a name="module_dynamodb_job_tracking"></a> [dynamodb\_job\_tracking](#module\_dynamodb\_job\_tracking) | ./modules/dynamodb | n/a |
| <a name="module_dynamodb_load_tracking"></a> [dynamodb\_load\_tracking](#module\_dynamodb\_load\_tracking) | ./modules/dynamodb | n/a |
| <a name="module_glue_catalog"></a> [glue\_catalog](#module\_glue\_catalog) | ./modules/glue/catalog | n/a |
| <a name="module_iam"></a> [iam](#module\_iam) | ./modules/iam | n/a |
| <a name="module_lakeformation"></a> [lakeformation](#module\_lakeformation) | ./modules/lakeformation | n/a |
| <a name="module_s3"></a> [s3](#module\_s3) | ./modules/s3 | n/a |
| <a name="module_sns"></a> [sns](#module\_sns) | ./modules/sns | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.encryption_key_data_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.processing_key_data_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_role.deployment_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_role) | data source |
| [aws_iam_session_context.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_session_context) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_administrator_users"></a> [administrator\_users](#input\_administrator\_users) | n/a | `list(string)` | n/a | yes |
| <a name="input_data_encryption_key_alias"></a> [data\_encryption\_key\_alias](#input\_data\_encryption\_key\_alias) | Encryption key alias | `string` | n/a | yes |
| <a name="input_data_processing_key_alias"></a> [data\_processing\_key\_alias](#input\_data\_processing\_key\_alias) | Processing key alias | `string` | n/a | yes |
| <a name="input_datalake_buckets"></a> [datalake\_buckets](#input\_datalake\_buckets) | Data Lake buckets to be created. P.S.:The keys will be used to compose the bucket name. | <pre>map(object({<br>    versioning = bool<br>    sensitive  = bool<br>    layer      = bool<br>  }))</pre> | <pre>{<br>  "analytics": {<br>    "layer": true,<br>    "sensitive": false,<br>    "versioning": true<br>  },<br>  "assets": {<br>    "layer": false,<br>    "sensitive": false,<br>    "versioning": true<br>  },<br>  "athena": {<br>    "layer": false,<br>    "sensitive": false,<br>    "versioning": false<br>  },<br>  "logs": {<br>    "layer": false,<br>    "sensitive": false,<br>    "versioning": false<br>  },<br>  "raw": {<br>    "layer": true,<br>    "sensitive": false,<br>    "versioning": true<br>  },<br>  "stage": {<br>    "layer": true,<br>    "sensitive": false,<br>    "versioning": true<br>  }<br>}</pre> | no |
| <a name="input_datalake_glue_database_tables_analytics"></a> [datalake\_glue\_database\_tables\_analytics](#input\_datalake\_glue\_database\_tables\_analytics) | glue athena database tables for datalake | <pre>map(object({<br>    s3_path               = string # var.s3_path<br>    table_type            = string # var.table_type<br>    external              = string # var.parameter_external<br>    input_format          = string<br>    output_format         = string<br>    parquet_compression   = string # var.parameter_parquet_compression<br>    serialization_library = string # var.serialization_library<br>    serialization_format  = string # var.serialization_format<br>    columns = map(object({<br>      type    = string<br>      comment = string<br>    }))<br>  }))</pre> | n/a | yes |
| <a name="input_datalake_glue_database_tables_raw"></a> [datalake\_glue\_database\_tables\_raw](#input\_datalake\_glue\_database\_tables\_raw) | glue athena database tables for datalake | <pre>map(object({<br>    s3_path               = string # var.s3_path<br>    table_type            = string # var.table_type<br>    external              = string # var.parameter_external<br>    input_format          = string<br>    output_format         = string<br>    parquet_compression   = string # var.parameter_parquet_compression<br>    serialization_library = string # var.serialization_library<br>    serialization_format  = string # var.serialization_format<br>    columns = map(object({<br>      type    = string<br>      comment = string<br>    }))<br>  }))</pre> | n/a | yes |
| <a name="input_datalake_glue_database_tables_stage"></a> [datalake\_glue\_database\_tables\_stage](#input\_datalake\_glue\_database\_tables\_stage) | glue athena database tables for datalake | <pre>map(object({<br>    s3_path               = string # var.s3_path<br>    table_type            = string # var.table_type<br>    external              = string # var.parameter_external<br>    input_format          = string<br>    output_format         = string<br>    parquet_compression   = string # var.parameter_parquet_compression<br>    serialization_library = string # var.serialization_library<br>    serialization_format  = string # var.serialization_format<br>    columns = map(object({<br>      type    = string<br>      comment = string<br>    }))<br>  }))</pre> | n/a | yes |
| <a name="input_deployment_role"></a> [deployment\_role](#input\_deployment\_role) | n/a | `string` | n/a | yes |
| <a name="input_function_name"></a> [function\_name](#input\_function\_name) | Report name | `string` | n/a | yes |
| <a name="input_glue_connection_name"></a> [glue\_connection\_name](#input\_glue\_connection\_name) | n/a | `string` | n/a | yes |
| <a name="input_gluecrawler_role_name"></a> [gluecrawler\_role\_name](#input\_gluecrawler\_role\_name) | n/a | `string` | n/a | yes |
| <a name="input_glueservice_role_name"></a> [glueservice\_role\_name](#input\_glueservice\_role\_name) | n/a | `string` | n/a | yes |
| <a name="input_lakeformation_role_name"></a> [lakeformation\_role\_name](#input\_lakeformation\_role\_name) | n/a | `string` | n/a | yes |
| <a name="input_lambda_archiver_role_name"></a> [lambda\_archiver\_role\_name](#input\_lambda\_archiver\_role\_name) | IAM role for the lambda function used in archival | `string` | n/a | yes |
| <a name="input_lambda_trigger_role_name"></a> [lambda\_trigger\_role\_name](#input\_lambda\_trigger\_role\_name) | IAM role for the lambda function used in archival | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Project name | `string` | n/a | yes |
| <a name="input_secret_name"></a> [secret\_name](#input\_secret\_name) | n/a | `string` | n/a | yes |
| <a name="input_sns_topics"></a> [sns\_topics](#input\_sns\_topics) | n/a | `set(string)` | n/a | yes |
| <a name="input_stepfunction_role_name"></a> [stepfunction\_role\_name](#input\_stepfunction\_role\_name) | n/a | `string` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | subnet id | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | Customer account vpc id | `string` | n/a | yes |
| <a name="input_workspace_iam_roles"></a> [workspace\_iam\_roles](#input\_workspace\_iam\_roles) | # Change account number for each environment. Ensure the IAM role is created and has the priveldges to create the needed resources # A strict one-to-one mapping between terraform workspace and AWS environment # An AWS account has host multiple environments. Make sure that every resource that gets created is environment specific. Else ResourceAlreadyExists exception | `map` | <pre>{<br>  "tenant1-dev": "arn:aws:iam::<accountID>:role/Datalake-Deploy-Role",<br>  "tenant1-prd": "arn:aws:iam::<accountID>:role/Datalake-Deploy-Role",<br>  "tenant1-tst": "arn:aws:iam::<accountID>:role/Datalake-Deploy-Role",<br>  "tenant5-dev": "arn:aws:iam::<accountID>:role/Datalake-Deploy-Role",<br>  "tenant5-prd": "arn:aws:iam::<accountID>:role/Datalake-Deploy-Role",<br>  "tenant5-tst": "arn:aws:iam::<accountID>:role/Datalake-Deploy-Role"<br>}</pre> | no |

## Outputs

No outputs.
