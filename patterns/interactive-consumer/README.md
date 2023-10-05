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
| <a name="module_athena_encryption_key"></a> [athena\_encryption\_key](#module\_athena\_encryption\_key) | ../../modules/kms | n/a |
| <a name="module_athena_s3"></a> [athena\_s3](#module\_athena\_s3) | ../../modules/s3-simple | n/a |
| <a name="module_constants"></a> [constants](#module\_constants) | ../../modules/constants | n/a |
| <a name="module_data_analyst_role"></a> [data\_analyst\_role](#module\_data\_analyst\_role) | ../../modules/iam-simple | n/a |
| <a name="module_lakeformation_admin_role"></a> [lakeformation\_admin\_role](#module\_lakeformation\_admin\_role) | ../../modules/iam-simple | n/a |
| <a name="module_lakeformation_permissions"></a> [lakeformation\_permissions](#module\_lakeformation\_permissions) | ../../modules/lakeformation-consumer | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.analyst_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.analyst_inline](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.athena_kms_key_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.lakeformation_administrator_inline](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.lakeformation_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_role.deployment_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_role) | data source |
| [aws_iam_session_context.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_session_context) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_administrator_users"></a> [administrator\_users](#input\_administrator\_users) | List of existing users/roles who require an explitcit lake formation administrative priviledges. Note: account administrator does not automatically get LF administrative priviledges. | `list(string)` | n/a | yes |
| <a name="input_analyst_role_name"></a> [analyst\_role\_name](#input\_analyst\_role\_name) | Use default unless, you need to override the newly created IAM role for data analyst. Each resource name will automatically be prefixed with bu, pipeline, environment parameters | `string` | `"data-analyst-role"` | no |
| <a name="input_athena_query_bucket"></a> [athena\_query\_bucket](#input\_athena\_query\_bucket) | Athena query bucket to be created. P.S.:The keys will be used to compose the bucket name. | `map(string)` | <pre>{<br>  "bucket_name": "athena-query",<br>  "bucket_versioning": "Disabled"<br>}</pre> | no |
| <a name="input_athena_workgroups"></a> [athena\_workgroups](#input\_athena\_workgroups) | athena workgroups in a map of objects data type. example, data engineer, analyst, scientist | `any` | n/a | yes |
| <a name="input_central_config"></a> [central\_config](#input\_central\_config) | variable to input the central config. Refer to central.json for format | `string` | `""` | no |
| <a name="input_deployment_role"></a> [deployment\_role](#input\_deployment\_role) | This user should preexist, should have priviledges to create all aws resources mentioned in this repository. This user gets added as LF admin as well to perform LF operations. | `string` | `"veritas-terraform-deploy-role"` | no |
| <a name="input_lakeformation_role_name"></a> [lakeformation\_role\_name](#input\_lakeformation\_role\_name) | Use default unless, you need to override the newly created IAM role for lake formation administration. Each resource name will automatically be prefixed with bu, pipeline, environment parameters | `string` | `"lake-formation-admin-role"` | no |
| <a name="input_lakeformation_service_endpoint"></a> [lakeformation\_service\_endpoint](#input\_lakeformation\_service\_endpoint) | Lake formation service end point. Do not override unless it is GCR (China) | `string` | `"lakeformation.amazonaws.com"` | no |
| <a name="input_pipeline_name"></a> [pipeline\_name](#input\_pipeline\_name) | Pipeline or report or function name. Usually represented by the folder (example: ems) | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->