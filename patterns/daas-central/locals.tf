locals {
  sns_topics       = ["test-topic"]
  bucket_resources = setunion(local.s3_bucket_arns, formatlist("%s/*", local.s3_bucket_arns))
  # Load all of the data from json
  producers_json_data = jsondecode(var.producers_config).producers
  consumers_json_data = jsondecode(var.consumers_config).consumers

  producer_catalogs = flatten([
    for producer_key, producer in local.producers_json_data : [
      for catalog_key, catalog in producer.catalogs : {
        producer   = producer_key
        account_id = producer.account_id
        catalog    = catalog_key
        bucket     = catalog.s3_bucket
        layer      = catalog.layer
      }
    ]
  ])

  consumer_catalogs = flatten([
    for consumer_key, consumer in local.consumers_json_data : [
      for catalog_key, catalog in consumer.catalogs : {
        consumer   = consumer_key
        account_id = consumer.account_id
        catalog    = catalog_key
        glue_db    = catalog.glue_db
        layer      = catalog.layer
      }
    ]
  ])

  s3_bucket_arns = flatten([
    for producer_key, producer in local.producers_json_data : [
      for catalog_key, catalog in producer.catalogs : format("%s%s", "arn:aws:s3:::", catalog.s3_bucket)
    ]
  ])

  producer_account_id = flatten([
    for producer_key, producer in local.producers_json_data : [
      for catalog_key, catalog in producer.catalogs : producer.account_id
    ]
  ])
}

