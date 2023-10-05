#copy script file to S3
resource "aws_s3_object" "glue_batch_template" {
  for_each = var.jobs
  bucket   = var.glue_meta_s3_bucket
  key      = format("%s/%s_%s", "glue/scripts", var.resource_prefix, var.jobs[each.key].script_name)
  source   = format("%s%s", "../../../modules/glue/job/scripts/", var.jobs[each.key].script_name)
  etag     = filemd5(format("%s%s", "../../../modules/glue/job/scripts/", var.jobs[each.key].script_name))
}

#copy glue libraries to S3
resource "aws_s3_object" "glue_batch_library" {
  bucket = var.glue_meta_s3_bucket
  key    = format("%s%s", "glue/libraries/", var.lib_name)
  source = format("%s%s", "../../../modules/glue/job/lib/", var.lib_name)
  etag   = filemd5(format("%s%s", "../../../modules/glue/job/lib/", var.lib_name))
}

###
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_job
#https://awscli.amazonaws.com/v2/documentation/api/latest/reference/glue/create-job.html
#batch job
resource "aws_glue_job" "batch_glue_job" {
  for_each = var.jobs
  #checkov:skip=CKV_AWS_195: TO-DO Need to get this resolved
  name        = format("%s_%s", var.resource_prefix, var.jobs[each.key].glue_job_name)
  description = var.jobs[each.key].glue_job_description
  role_arn    = var.glue_service_iam_role

  # Change parameters to meet your needs
  max_retries  = 0
  timeout      = 2880
  glue_version = "3.0"


  #worker type and number of workers need to be both present
  worker_type       = "G.1X"
  number_of_workers = 10
  connections       = [var.glue_connector]


  command {
    script_location = format("%s://%s/%s/%s_%s", "s3", var.glue_meta_s3_bucket, "glue/scripts", var.resource_prefix, var.jobs[each.key].script_name)
    python_version  = "3"
  }

  default_arguments = {
    # special parameters: https://docs.aws.amazon.com/glue/latest/dg/aws-glue-programming-etl-glue-arguments.html
    "--TempDir"                          = format("%s://%s/%s/%s/", "s3", var.glue_meta_s3_bucket, var.resource_prefix, "Temp")
    "--job-language"                     = "python"
    "--enable-continuous-cloudwatch-log" = "true"
    "--enable-metrics"                   = "true"
    "--job-bookmark-option"              = var.jobs[each.key].job_bookmark
    # "--enable-glue-datacatalog" = "true" 
    "--enable-auto-scaling " = "true"


    #extra parameters
    "--awsResourcePrefix" = var.resource_prefix
    "--s3OutputBucket"    = var.glue_meta_s3_bucket
  }

  execution_property {
    max_concurrent_runs = var.max_concurrent_runs
  }
  tags = merge(
    {
      "Description" = "Datalake glue jobs"
    },
  var.tags)
}
