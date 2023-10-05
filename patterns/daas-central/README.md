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
| <a name="module_constants"></a> [constants](#module\_constants) | ../../modules/constants | n/a |
| <a name="module_iam"></a> [iam](#module\_iam) | ../../modules/iam | n/a |
| <a name="module_lakeformation_permissions"></a> [lakeformation\_permissions](#module\_lakeformation\_permissions) | ../../modules/lakeformation-central | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.lakeformation_administrator_inline](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_role.deployment_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_role) | data source |
| [aws_iam_session_context.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_session_context) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_administrator_users"></a> [administrator\_users](#input\_administrator\_users) | List of existing users/roles who require an explitcit lake formation administrative priviledges. Note: account administrator does not automatically get LF administrative priviledges. | `list(string)` | n/a | yes |
| <a name="input_consumers_config"></a> [consumers\_config](#input\_consumers\_config) | variable to input the central config. Refer to examples for concret consumers.json configuration | `string` | `""` | no |
| <a name="input_deployment_role"></a> [deployment\_role](#input\_deployment\_role) | This user should preexist, should have priviledges to create all aws resources mentioned in this repository. This user gets added as LF admin as well to perform LF operations. | `string` | `"veritas-terraform-deploy-role"` | no |
| <a name="input_gluecrawler_role_name"></a> [gluecrawler\_role\_name](#input\_gluecrawler\_role\_name) | Use default unless, you need to override the newly created IAM role for glue crawler. Each resource name will automatically be prefixed with bu, pipeline, environment parameters | `string` | `"glue-crawler-role"` | no |
| <a name="input_lakeformation_role_name"></a> [lakeformation\_role\_name](#input\_lakeformation\_role\_name) | Use default unless, you need to override the newly created IAM role for lake formation administration. Each resource name will automatically be prefixed with bu, pipeline, environment parameters | `string` | `"lake-formation-admin-role"` | no |
| <a name="input_pipeline_name"></a> [pipeline\_name](#input\_pipeline\_name) | Pipeline or report or function name. Usually represented by the folder (example: ems) | `string` | n/a | yes |
| <a name="input_producers_config"></a> [producers\_config](#input\_producers\_config) | variable to input the central config. Refer to examples for concret producers.json configuration | `string` | `""` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->