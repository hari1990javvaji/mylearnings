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
| <a name="module_security_group"></a> [security\_group](#module\_security\_group) | terraform-aws-modules/security-group/aws | 4.17.1 |
| <a name="module_vpc_endpoints"></a> [vpc\_endpoints](#module\_vpc\_endpoints) | terraform-aws-modules/vpc/aws//modules/vpc-endpoints | 4.0.0 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | two exsiting private subent ids with egress internet access through NAT | `list(string)` | `[]` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | exsiting vpc id to be used | `string` | `""` | no |
| <a name="input_workspace_iam_roles"></a> [workspace\_iam\_roles](#input\_workspace\_iam\_roles) | # Change account number for each environment. Ensure the IAM role is created and has the priveldges to create the needed resources # A strict one-to-one mapping between terraform workspace and AWS environment # An AWS account has host multiple environments. Make sure that every resource that gets created is environment specific. Else ResourceAlreadyExists exception # Workspace is a combination of business unit and environment in the format <bu>-<env> | `map` | <pre>{<br>  "src-dev": "arn:aws:iam::705158173663:role/veritas-terraform-deploy-role"<br>}</pre> | no |

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
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.64.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_security_group"></a> [security\_group](#module\_security\_group) | terraform-aws-modules/security-group/aws | 4.17.1 |
| <a name="module_vpc_endpoints"></a> [vpc\_endpoints](#module\_vpc\_endpoints) | terraform-aws-modules/vpc/aws//modules/vpc-endpoints | 4.0.0 |

## Resources

| Name | Type |
|------|------|
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | two exsiting private subent ids with egress internet access through NAT | `list(string)` | `[]` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | exsiting vpc id to be used | `string` | `""` | no |
| <a name="input_workspace_iam_roles"></a> [workspace\_iam\_roles](#input\_workspace\_iam\_roles) | # Terraform workspace should be in the format <bu>-<account\_role>-<env> # Example: src-cmr-dev. Here SRC is business unit. CMR is consumer account role. DEV is environment # veritas-terraform-deploy-role iam role with administrative priviledges is a prequisite # GitHub environments and secrets is a prequisite | `map` | <pre>{<br>  "src-cmr-dev": "arn:aws:iam::942328815196:role/veritas-terraform-deploy-role"<br>}</pre> | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->