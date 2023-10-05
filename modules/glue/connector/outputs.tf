output "datalake-glue-connector-arn" {
  value = aws_glue_connection.glue_network_connector.arn
}

output "datalake-glue-connector-id" {
  value = aws_glue_connection.glue_network_connector.id
}