locals {

  # Load all of the data from json
  central_json_data = jsondecode(var.central_config).central

  central_catalogs = flatten([
    for central_key, central in local.central_json_data : [
      for catalog_key, catalog in central.catalogs : {
        central    = central_key
        account_id = central.account_id
        lf_admin   = central.lf_admin
        catalog    = catalog_key
        glue_db    = catalog.glue_db
        s3_bucket  = catalog.s3_bucket
        layer      = catalog.layer
      }
    ]
  ])

  central_account_lf_admin_arn = flatten([
    for central_key, central in local.central_json_data : [
      for catalog_key, catalog in central.catalogs : central.lf_admin
    ]
  ])

  bucket_resources       = setunion(module.s3.buckets_nonsensitive_arns, formatlist("%s/*", module.s3.buckets_nonsensitive_arns))
  asset_bucket_resources = module.s3.bucket_assets.arn
}

