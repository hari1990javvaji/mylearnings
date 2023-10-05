## Execute  bu creating a data pipeline 
module "cmr_ems_interactive_consumer" {
  source              = "../../../patterns/interactive-consumer"
  pipeline_name       = var.pipeline_name
  administrator_users = var.administrator_users
  central_config      = file("${path.module}/config/central.json")
  athena_workgroups   = var.athena_workgroups
}