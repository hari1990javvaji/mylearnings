locals {
  sns_topics                  = ["test-topic"]
  athena_encryption_key_alias = "athena-key"
  central_json_data           = jsondecode(var.central_config).central
  central_catalogs = flatten([
    for central_key, central in local.central_json_data : [
      for catalog_key, catalog in central.catalogs : {
        central    = central_key
        account_id = central.account_id
        catalog    = catalog_key
        s3_bucket  = catalog.s3_bucket
        glue_db    = catalog.glue_db
        layer      = catalog.layer
      }
    ]
  ])
}
