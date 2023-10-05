resource "aws_secretsmanager_secret" "secret-manager" {
  ## Ideally this should be customer_name/project-name/environment
  ## we used secret-name (new variable) rather project-name as secret deletion will be retained for 30 days and reexecution causes issues
  name        = format("%s/%s", var.resource_prefix, var.secret_name)
  description = "Datalake secret manager"
  kms_key_id  = var.kms_key_id
  tags = merge(
    {
      "Description" = "Store secrets to be retrieved by Glue jobs"
    },
  var.tags)
}

resource "aws_secretsmanager_secret_version" "secret-manager-version" {
  secret_id     = aws_secretsmanager_secret.secret-manager.id
  secret_string = jsonencode(local.secret_key_value)

  # Changes to the password in Terraform should not trigger a change in state
  # to Secrets Manager as this could cause a loss of access to the target RDS
  # instance.
  # In other words, once Secrets Manager has managed to rotate the password,
  # Terraform should no longer attempt to apply a new password.
  lifecycle {
    ignore_changes = [
      secret_string
    ]
  }
}


