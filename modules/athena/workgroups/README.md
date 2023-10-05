<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_athena_workgroup.workgroups](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/athena_workgroup) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_athena_workgroups"></a> [athena\_workgroups](#input\_athena\_workgroups) | athena workgroups | `map` | `{}` | no |
| <a name="input_bucket_query_result"></a> [bucket\_query\_result](#input\_bucket\_query\_result) | n/a | <pre>object({<br>    bucket = string<br>    arn    = string<br>  })</pre> | n/a | yes |
| <a name="input_encrypt_algorithm_athena"></a> [encrypt\_algorithm\_athena](#input\_encrypt\_algorithm\_athena) | n/a | `string` | `"SSE_KMS"` | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | n/a | `string` | n/a | yes |
| <a name="input_resource_prefix"></a> [resource\_prefix](#input\_resource\_prefix) | Resource prefix | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Mandatory normalized tags to tag the resources accordingly. | `map(string)` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->