## Execute  bu creating a data pipeline based on S3 EMR S3 pattern
module "src-patient-care-s3-glue-s3" {
  source              = "../../../patterns/s3-glue-s3"
  pipeline_name       = var.pipeline_name
  vpc_id              = var.vpc_id
  subnet_id           = var.subnet_id
  datalake_buckets    = var.datalake_buckets
  administrator_users = var.administrator_users
  sns_topics          = var.sns_topics
  secret_name         = var.secret_name
  athena_workgroups   = var.athena_workgroups
  vpc_sg_id           = var.vpc_sg_id
  central_config      = file("${path.module}/config/central.json")
  lf_admin_role_arn   = var.lf_admin_role_arn
}