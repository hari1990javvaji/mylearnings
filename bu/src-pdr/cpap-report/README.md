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
| <a name="module_src-ad-score-s3-emr-s3"></a> [src-ad-score-s3-emr-s3](#module\_src-ad-score-s3-emr-s3) | ../../../patterns/s3-emr-s3 | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_administrator_users"></a> [administrator\_users](#input\_administrator\_users) | List of existing users/roles who require an explitcit lake formation administrative priviledges. Note: account administrator does not automatically get LF administrative priviledges. | `list(string)` | n/a | yes |
| <a name="input_athena_workgroups"></a> [athena\_workgroups](#input\_athena\_workgroups) | athena workgroups | `map` | <pre>{<br>  "data-architecture": {<br>    "description": "Data Architecture team workgroup"<br>  },<br>  "data-engineering": {<br>    "bytes_scanned": 21474836480,<br>    "cloudwatch_enabled": false,<br>    "description": "Data Engineering team workgroup",<br>    "workgroup": true<br>  },<br>  "data-science": {<br>    "description": "Data Science team workgroup"<br>  }<br>}</pre> | no |
| <a name="input_datalake_buckets"></a> [datalake\_buckets](#input\_datalake\_buckets) | Data Lake buckets to be created. P.S.:The keys will be used to compose the bucket name. | <pre>map(object({<br>    versioning = bool<br>    sensitive  = bool<br>    layer      = bool<br>  }))</pre> | <pre>{<br>  "assets": {<br>    "layer": false,<br>    "sensitive": false,<br>    "versioning": true<br>  },<br>  "athena": {<br>    "layer": false,<br>    "sensitive": false,<br>    "versioning": false<br>  },<br>  "bronze": {<br>    "layer": true,<br>    "sensitive": false,<br>    "versioning": true<br>  },<br>  "gold": {<br>    "layer": true,<br>    "sensitive": false,<br>    "versioning": true<br>  },<br>  "logs": {<br>    "layer": false,<br>    "sensitive": false,<br>    "versioning": false<br>  },<br>  "silver": {<br>    "layer": true,<br>    "sensitive": false,<br>    "versioning": true<br>  }<br>}</pre> | no |
| <a name="input_emr_config"></a> [emr\_config](#input\_emr\_config) | configuration to build emr clusters | `any` | n/a | yes |
| <a name="input_pipeline_name"></a> [pipeline\_name](#input\_pipeline\_name) | Pipeline name | `string` | n/a | yes |
| <a name="input_route_table_id"></a> [route\_table\_id](#input\_route\_table\_id) | route table id used for gateway vpc end points | `string` | n/a | yes |
| <a name="input_secret_name"></a> [secret\_name](#input\_secret\_name) | secret id name. the resource\_prefix will be prefixed to any aws resource created | `string` | n/a | yes |
| <a name="input_sns_topics"></a> [sns\_topics](#input\_sns\_topics) | SNS topic name. the resource\_prefix will be prefixed to any aws resource created | `set(string)` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | subnet id | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | Customer account vpc id | `string` | n/a | yes |
| <a name="input_vpc_sg_id"></a> [vpc\_sg\_id](#input\_vpc\_sg\_id) | vpc endpoing security id | `string` | n/a | yes |
| <a name="input_workspace_iam_roles"></a> [workspace\_iam\_roles](#input\_workspace\_iam\_roles) | # Terraform workspace should be in the format <bu>-<account\_role>-<env> # Example: src-pdr-dev. Here SRC is business unit. PDR is producer account role. DEV is environment # veritas-terraform-deploy-role iam role with administrative priviledges is a prequisite # GitHub environments and secrets is a prequisite | `map` | <pre>{<br>  "src-pdr-dev": "arn:aws:iam::705158173663:role/veritas-terraform-deploy-role"<br>}</pre> | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->