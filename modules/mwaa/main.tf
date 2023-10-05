### MWAA Environment
resource "aws_mwaa_environment" "mwaa_env" {
  #checkov:skip=CKV_AWS_244: MWAA web server logs are enabled through a variable. Checkov fails to recognize the variable
  #checkov:skip=CKV_AWS_243: MWAA worker logs are enabled through a variable. Checkov fails to recognize the variable
  #checkov:skip=CKV_AWS_242: MWAA scheduler logs are enabled through a variable. Checkov fails to recognize the variable

  depends_on = [
    aws_cloudwatch_log_group.mwaa_env_log_group
  ]
  name               = var.mwaa_env_name
  airflow_version    = var.airflow_version
  execution_role_arn = aws_iam_role.mwaa_iam_role.arn
  source_bucket_arn  = var.mwaa_bucket["arn"]
  dag_s3_path        = "dags"
  #requirements_s3_path           = var.req_file_s3_path
  #requirements_s3_object_version = aws_s3_object.requirements_upload.version_id
  #plugins_s3_path                = var.plugins_s3_path
  #plugins_s3_object_version      = aws_s3_object.plugins_upload.version_id
  kms_key                       = var.kms_key
  webserver_access_mode         = var.webserver_access_mode
  environment_class             = var.mwaa_env_class
  max_workers                   = var.mwaa_max_workers
  min_workers                   = var.mwaa_min_workers
  airflow_configuration_options = var.airflow_configs
  logging_configuration {
    dag_processing_logs {
      enabled   = var.mwaa_logging_enabled
      log_level = var.mwaa_logging_level
    }
    scheduler_logs {
      enabled   = var.mwaa_logging_enabled
      log_level = var.mwaa_logging_level
    }
    task_logs {
      enabled   = var.mwaa_logging_enabled
      log_level = var.mwaa_logging_level
    }
    webserver_logs {
      enabled   = var.mwaa_logging_enabled
      log_level = var.mwaa_logging_level
    }
    worker_logs {
      enabled   = var.mwaa_logging_enabled
      log_level = var.mwaa_logging_level
    }
  }
  network_configuration {
    security_group_ids = [module.mwaa_env_sg.security_group_id]
    subnet_ids         = var.webserver_access_mode == "PRIVATE_ONLY" ? var.intra_subnet_ids : var.private_subnet_ids
  }
  tags = var.tags
}

### log groups
resource "aws_cloudwatch_log_group" "mwaa_env_log_group" {
  for_each          = toset(["DAGProcessing", "Scheduler", "Task", "Worker", "WebServer"])
  name              = "airflow-${var.mwaa_env_name}-${each.value}"
  retention_in_days = var.mwaa_logs_retention_in_days
  kms_key_id        = var.kms_key
  tags              = var.tags
}

### MWAA Env Security Group
module "mwaa_env_sg" {
  source       = "terraform-aws-modules/security-group/aws"
  version      = "4.9.0"
  name         = "${var.mwaa_env_name}-mwaa-sg"
  description  = "security group ${var.mwaa_env_name} mwaa env"
  vpc_id       = var.vpc_id
  tags         = var.tags
  egress_rules = ["all-all"]
  ingress_with_self = [
    {
      rule        = "all-all"
      description = "allows ingress traffic from within itself"
    }
  ]
  # ingress_with_source_security_group_id = [
  #   {
  #     description              = "allowing ingress access from airflow cli runner (lambda function)"
  #     rule                     = "all-all"
  #     source_security_group_id = var.airflow_cli_runner_sg_id
  #   }
  # ]
}

### VPC Endpoint Security Group ingress rule from the MWAA Env Security Group
resource "aws_security_group_rule" "vpce_sg_ingress" {
  type                     = "ingress"
  description              = "allowing ingress traffic from ${var.mwaa_env_name} mwaa env security group"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = var.vpc_sg_id
  source_security_group_id = module.mwaa_env_sg.security_group_id
}

### MWAA Env Execution Role
resource "aws_iam_role" "mwaa_iam_role" {
  name        = "${var.mwaa_env_name}-mwaa-role"
  description = "execution iam role for ${var.mwaa_env_name} mwaa environment"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = [
            "airflow.amazonaws.com",
            "airflow-env.amazonaws.com"
          ]
        }
      },
    ]
  })
  managed_policy_arns = [
    aws_iam_policy.mwaa_iam_policy.arn,
    "arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/AWSGlueServiceRole"
  ]
  tags = var.tags
}

# resource "aws_iam_policy_attachment" "glue_policy_to_mwaa_role" {
#   name       = "GlueServicePolicy"
#   roles      = [aws_iam_role.mwaa_iam_role.name]
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
# }
/*
resource "aws_s3_object" "dags_upload" {
  for_each    = var.dags_local_path != "" ? fileset(var.dags_local_path, "**") : toset([])
  bucket      = var.mwaa_bucket["id"]
  key         = "dags/${each.value}"
  source      = "${var.dags_local_path}/${each.value}"
  source_hash = filemd5("${var.dags_local_path}/${each.value}")
}

resource "aws_s3_object" "requirements_upload" {
  bucket      = var.mwaa_bucket["id"]
  key         = var.req_file_s3_path
  source      = var.req_file_local_path
  source_hash = filemd5(var.req_file_local_path)
}

data "archive_file" "mwaa_plugins" {
  type        = "zip"
  source_dir  = "${var.plugins_local_path}/plugins/"
  output_path = "${var.plugins_local_path}/plugins.zip"
}

resource "aws_s3_object" "plugins_upload" {
  bucket      = var.mwaa_bucket["id"]
  key         = var.plugins_s3_path
  source      = "${var.plugins_local_path}/plugins.zip"
  source_hash = filemd5("${var.plugins_local_path}/plugins.zip")
}
*/



