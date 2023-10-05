## Execute  bu creating a data pipeline based on S3 EMR S3 pattern
module "account_central_daas_central" {
  source              = "../../../patterns/daas-central"
  producers_config    = file("${path.module}/config/producers.json")
  consumers_config    = file("${path.module}/config/consumers.json")
  administrator_users = var.administrator_users
  pipeline_name       = var.pipeline_name
}