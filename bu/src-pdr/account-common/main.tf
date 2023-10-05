## Execute  bu creating a data pipeline based on S3 EMR S3 pattern
module "account_common_daas_platform" {
  source              = "../../../patterns/daas-platform"
  intra_subnet_ids    = var.intra_subnet_ids
  private_subnet_ids  = var.private_subnet_ids
  vpc_sg_id           = var.vpc_sg_id
  vpc_id              = var.vpc_id
  mwaa_config         = file("${path.module}/config/mwaa_config.json")
  administrator_users = var.administrator_users
}