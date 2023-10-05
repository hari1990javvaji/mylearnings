locals {
  mwaa_bucket_name = var.mwaa_bucket_name
  raw_bucket       = var.raw_bucket
}



resource "local_file" "mwaa_config_file_template" {
  content  = templatefile("${path.module}/templates/mwaa_config.tpl", { emr_config = var.mwaa_config["emr"], glue_config = var.mwaa_config["glue"] })
  filename = "${path.module}/app/dags/config_file.ini"
}

resource "aws_s3_bucket_object" "mwaa_upload" {
  for_each   = fileset("./app/", "**")
  bucket     = local.mwaa_bucket_name
  key        = each.value
  source     = "./app/${each.value}"
  etag       = filemd5("./app/${each.value}")
  depends_on = [resource.local_file.mwaa_config_file_template]
}


resource "null_resource" "raw_s3_bucket_cp" {

  provisioner "local-exec" {
    interpreter = ["/bin/sh", "-c"]
    environment = {
      AWS_DEFAULT_REGION = "us-east-1"
    }
    command = "aws sts assume-role --role-arn ${var.workspace_iam_roles[terraform.workspace]} --role-session-name s3_copy --query 'Credentials.[`export#AWS_ACCESS_KEY_ID=`,AccessKeyID,`#AWS_SECRET_ACCESS_KEY=`,SecretKey,`#AWS_SESSION_TOKEN=`,SessionToken]' --output text | sed $'s/\t//g' | sed 's/#/ /g' && aws s3 cp  s3://noaa-gsod-pds/2022/  s3://${local.raw_bucket}/2023/ --recursive --exclude '*' --include ${var.sample_file_pattern} --acl=bucket-owner-full-control && aws sts get-caller-identity"
  }
}

