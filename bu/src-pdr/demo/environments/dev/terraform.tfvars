mwaa_bucket_name    = "src-pdr-dev-common-mwaa-us-east-1-705158173663"
raw_bucket          = "src-pdr-dev-cpap-report-raw-us-east-1-705158173663"
sample_file_pattern = "A*.csv"
mwaa_config = {
  emr = {
    "cluster_id"      = "j-3CREEJ76RI3XH"
    "emr_step_job"    = "s3://src-pdr-dev-cpap-report-assets-us-east-1-705158173663/extreme_weather.py"
    "job_parameter_1" = "s3://src-pdr-dev-cpap-report-raw-us-east-1-705158173663/2023/"
    "job_parameter_2" = "s3://src-pdr-dev-cpap-report-analytics-us-east-1-705158173663/output/"

  }
  glue = {
    "crawler_name" = "cross-crawler-src-ctr-dev-gov-src-pdr-cpap-report-analytics"
  }
}