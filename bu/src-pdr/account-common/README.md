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
| <a name="module_account_common_daas_platform"></a> [account\_common\_daas\_platform](#module\_account\_common\_daas\_platform) | ../../../patterns/daas-platform | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_intra_subnet_ids"></a> [intra\_subnet\_ids](#input\_intra\_subnet\_ids) | two exsiting intra subent ids without internet access | `list(string)` | `[]` | no |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | two exsiting private subent ids with egress internet access through NAT | `list(string)` | `[]` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | exsiting vpc id to be used | `string` | `""` | no |
| <a name="input_vpc_sg_id"></a> [vpc\_sg\_id](#input\_vpc\_sg\_id) | security group id attached to the VPC endpoints (used by intra subntes) | `string` | `""` | no |
| <a name="input_workspace_iam_roles"></a> [workspace\_iam\_roles](#input\_workspace\_iam\_roles) | # Change account number for each environment. Ensure the IAM role is created and has the priveldges to create the needed resources # A strict one-to-one mapping between terraform workspace and AWS environment # An AWS account has host multiple environments. Make sure that every resource that gets created is environment specific. Else ResourceAlreadyExists exception # Workspace is a combination of business unit and environment in the format <bu>-<env> | `map` | <pre>{<br>  "src-dev": "arn:aws:iam::705158173663:role/veritas-terraform-deploy-role"<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_airflow_environment"></a> [airflow\_environment](#output\_airflow\_environment) | MWAA environment URL |

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
| <a name="module_account_common_daas_platform"></a> [account\_common\_daas\_platform](#module\_account\_common\_daas\_platform) | ../../../patterns/daas-platform | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_intra_subnet_ids"></a> [intra\_subnet\_ids](#input\_intra\_subnet\_ids) | two exsiting intra subent ids without internet access | `list(string)` | `[]` | no |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | two exsiting private subent ids with egress internet access through NAT | `list(string)` | `[]` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | exsiting vpc id to be used | `string` | `""` | no |
| <a name="input_vpc_sg_id"></a> [vpc\_sg\_id](#input\_vpc\_sg\_id) | security group id attached to the VPC endpoints (used by intra subntes) | `string` | `""` | no |
| <a name="input_workspace_iam_roles"></a> [workspace\_iam\_roles](#input\_workspace\_iam\_roles) | # Terraform workspace should be in the format <bu>-<account\_role>-<env> # Example: src-pdr-dev. Here SRC is business unit. PDR is producer account role. DEV is environment # veritas-terraform-deploy-role iam role with administrative priviledges is a prequisite # GitHub environments and secrets is a prequisite | `map` | <pre>{<br>  "src-pdr-dev": "arn:aws:iam::705158173663:role/veritas-terraform-deploy-role"<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_airflow_environment"></a> [airflow\_environment](#output\_airflow\_environment) | MWAA environment URL |
<!-- END_TF_DOCS -->