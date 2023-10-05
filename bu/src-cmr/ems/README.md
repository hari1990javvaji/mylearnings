<!-- BEGIN_TF_DOCS -->
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
| <a name="module_cmr_ems_interactive_consumer"></a> [cmr\_ems\_interactive\_consumer](#module\_cmr\_ems\_interactive\_consumer) | ../../../patterns/interactive-consumer | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_administrator_users"></a> [administrator\_users](#input\_administrator\_users) | List of existing users/roles who require an explitcit lake formation administrative priviledges. Note: account administrator does not automatically get LF administrative priviledges. | `list(string)` | n/a | yes |
| <a name="input_athena_workgroups"></a> [athena\_workgroups](#input\_athena\_workgroups) | athena workgroups in a map of objects data type. example, data engineer, analyst, scientist | `any` | n/a | yes |
| <a name="input_pipeline_name"></a> [pipeline\_name](#input\_pipeline\_name) | Pipeline or report or function name. Usually represented by the folder (example: ems) | `string` | n/a | yes |
| <a name="input_workspace_iam_roles"></a> [workspace\_iam\_roles](#input\_workspace\_iam\_roles) | # Terraform workspace should be in the format <bu>-<account\_role>-<env> # Example: src-cmr-dev. Here SRC is business unit. CMR is consumer account role. DEV is environment # veritas-terraform-deploy-role iam role with administrative priviledges is a prequisite # GitHub environments and secrets is a prequisite | `map` | <pre>{<br>  "src-cmr-dev": "arn:aws:iam::942328815196:role/veritas-terraform-deploy-role"<br>}</pre> | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->