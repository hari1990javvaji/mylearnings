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
| [aws_glue_crawler.glue_crawler](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_crawler) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_datalake-glue-connector-id"></a> [datalake-glue-connector-id](#input\_datalake-glue-connector-id) | Name to be glue network connection | `any` | n/a | yes |
| <a name="input_datalake_layers_buckets"></a> [datalake\_layers\_buckets](#input\_datalake\_layers\_buckets) | n/a | <pre>list(object({<br>    layer  = string<br>    bucket = string<br>    arn    = string<br>  }))</pre> | n/a | yes |
| <a name="input_glue_crawler_classifiers"></a> [glue\_crawler\_classifiers](#input\_glue\_crawler\_classifiers) | (Optional) List of custom classifiers. By default, all AWS classifiers are included in a crawl, but these custom classifiers always override the default classifiers for a given classification. | `any` | `null` | no |
| <a name="input_glue_crawler_configuration"></a> [glue\_crawler\_configuration](#input\_glue\_crawler\_configuration) | (Optional) JSON string of configuration information. | `any` | `null` | no |
| <a name="input_glue_crawler_database_name"></a> [glue\_crawler\_database\_name](#input\_glue\_crawler\_database\_name) | Glue database where results are written. | `string` | `""` | no |
| <a name="input_glue_crawler_description"></a> [glue\_crawler\_description](#input\_glue\_crawler\_description) | (Optional) Description of the crawler. | `any` | `null` | no |
| <a name="input_glue_crawler_lineage_configuration"></a> [glue\_crawler\_lineage\_configuration](#input\_glue\_crawler\_lineage\_configuration) | (Optional) Specifies data lineage configuration settings for the crawler. | `list` | `[]` | no |
| <a name="input_glue_crawler_name"></a> [glue\_crawler\_name](#input\_glue\_crawler\_name) | Mandatory crawler name. | `string` | n/a | yes |
| <a name="input_glue_crawler_recrawl_policy"></a> [glue\_crawler\_recrawl\_policy](#input\_glue\_crawler\_recrawl\_policy) | Optional) A policy that specifies whether to crawl the entire dataset again, or to crawl only folders that were added since the last crawler run. | `list` | `[]` | no |
| <a name="input_glue_crawler_role"></a> [glue\_crawler\_role](#input\_glue\_crawler\_role) | (Required) The IAM role friendly name (including path without leading slash), or ARN of an IAM role, used by the crawler to access other resources. | `string` | `""` | no |
| <a name="input_glue_crawler_schedule"></a> [glue\_crawler\_schedule](#input\_glue\_crawler\_schedule) | (Optional) A cron expression used to specify the schedule. For more information, see Time-Based Schedules for Jobs and Crawlers. For example, to run something every day at 12:15 UTC, you would specify: cron(15 12 * * ? *). | `any` | `null` | no |
| <a name="input_glue_crawler_schema_change_policy"></a> [glue\_crawler\_schema\_change\_policy](#input\_glue\_crawler\_schema\_change\_policy) | (Optional) Policy for the crawler's update and deletion behavior. | `list` | `[]` | no |
| <a name="input_glue_crawler_security_configuration"></a> [glue\_crawler\_security\_configuration](#input\_glue\_crawler\_security\_configuration) | (Optional) The name of Security Configuration to be used by the crawler | `any` | `null` | no |
| <a name="input_glue_crawler_table_prefix"></a> [glue\_crawler\_table\_prefix](#input\_glue\_crawler\_table\_prefix) | (Optional) The table prefix used for catalog tables that are created. | `any` | `null` | no |
| <a name="input_resource_prefix"></a> [resource\_prefix](#input\_resource\_prefix) | Prefix should be buName-customerNamer-envName | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Mandatory normalized tags to tag the resources accordingly. | `map(string)` | n/a | yes |
| <a name="input_use_lake_formation_credentials"></a> [use\_lake\_formation\_credentials](#input\_use\_lake\_formation\_credentials) | Govern access through Lake Formation Credentials | `bool` | `true` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->