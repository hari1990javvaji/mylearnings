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
| [aws_glue_catalog_database.datalake_databases](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_catalog_database) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_datalake_layers_buckets"></a> [datalake\_layers\_buckets](#input\_datalake\_layers\_buckets) | n/a | <pre>list(object({<br>    layer  = string<br>    bucket = string<br>    arn    = string<br>  }))</pre> | n/a | yes |
| <a name="input_glue_database_mask"></a> [glue\_database\_mask](#input\_glue\_database\_mask) | n/a | `string` | `"%s-%s"` | no |
| <a name="input_resource_prefix"></a> [resource\_prefix](#input\_resource\_prefix) | Prefix should be buName-customerNamer-envName | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Mandatory normalized tags to tag the resources accordingly. | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_databases"></a> [databases](#output\_databases) | n/a |
| <a name="output_glue_database_analytics"></a> [glue\_database\_analytics](#output\_glue\_database\_analytics) | n/a |
| <a name="output_glue_database_raw"></a> [glue\_database\_raw](#output\_glue\_database\_raw) | n/a |
| <a name="output_glue_database_stage"></a> [glue\_database\_stage](#output\_glue\_database\_stage) | n/a |
| <a name="output_glue_databases_arn"></a> [glue\_databases\_arn](#output\_glue\_databases\_arn) | n/a |
<!-- END_TF_DOCS -->