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
| <a name="module_account_central_daas_central"></a> [account\_central\_daas\_central](#module\_account\_central\_daas\_central) | ../../../patterns/daas-central | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_administrator_users"></a> [administrator\_users](#input\_administrator\_users) | List of existing users/roles who require an explitcit lake formation administrative priviledges. Note: account administrator does not automatically get LF administrative priviledges. | `list(string)` | n/a | yes |
| <a name="input_pipeline_name"></a> [pipeline\_name](#input\_pipeline\_name) | Pipeline or report or function name. Usually represented by the folder (example: gov) | `string` | n/a | yes |
| <a name="input_workspace_iam_roles"></a> [workspace\_iam\_roles](#input\_workspace\_iam\_roles) | # Terraform workspace should be in the format <bu>-<account\_role>-<env> # Example: src-ctr-dev. Here SRC is business unit. CTR is central account role. DEV is environment # veritas-terraform-deploy-role iam role with administrative priviledges is a prequisite # GitHub environments and secrets is a prequisite | `map` | <pre>{<br>  "src-ctr-dev": "arn:aws:iam::165729034722:role/veritas-terraform-deploy-role"<br>}</pre> | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->