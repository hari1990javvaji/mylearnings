output "databases" {
  value = aws_glue_catalog_database.datalake_databases
}

output "glue_databases_arn" {
  value = [
    for key, value in aws_glue_catalog_database.datalake_databases : value.arn
  ]
}

output "glue_database_raw" {
  value = {
    database = split(":", aws_glue_catalog_database.datalake_databases["raw"].id)[1]
  }
}

output "glue_database_stage" {
  value = {
    database = split(":", aws_glue_catalog_database.datalake_databases["stage"].id)[1]
  }
}

output "glue_database_analytics" {
  value = {
    database = split(":", aws_glue_catalog_database.datalake_databases["analytics"].id)[1]
  }
}