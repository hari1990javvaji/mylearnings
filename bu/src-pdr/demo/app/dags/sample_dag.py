
from airflow import models
from airflow.utils import dates
from airflow import DAG
from airflow.providers.amazon.aws.operators.glue_crawler import GlueCrawlerOperator
from custom.operator.emr import \
    EmrAddStepsOperator,EmrCreateJobFlowOperator
import configparser
import os

path = os.path.dirname(os.path.realpath(__file__))
configdir = '/'.join([path,'config_file.ini'])
config = configparser.ConfigParser()
config.read(configdir)

cluster_id = config.get("EMR", "cluster_id")
emr_step_job = config.get("EMR", "emr_step_job")
job_parameter_1 = config.get("EMR", "job_parameter_1")
job_parameter_2 = config.get("EMR", "job_parameter_2")
crawler_name = config.get("Glue", "crawler_name")

# CONFIG = {
#     "emr_cluster": cluster_id,
#     "aws_conn_id": "aws_default",
#     "aws_region": "us-east-1",
#     "check_interval": "30",
#     "s3_uri_prefix": "s3://src-pdr-dev-common-mwaa-us-east-1-705158173663/dags/",
# }

JOB_PROPS = {
    "user.name": "kaliapa",
}

with models.DAG(
    "Sample_EMR_and_Glue_Crawler_job",
    schedule_interval=None,  # Change to suit your needs
    start_date=dates.days_ago(0),  # Change to suit your needs
) as dag:
    SPARK_STEPS = []
    extreme_weather_calc = EmrAddStepsOperator(
        task_id="extreme_weather_sample_job",
        steps = [
            {
                'Name': 'extreme_weather_calc_step',
                'ActionOnFailure': 'CONTINUE',
                'HadoopJarStep': {
                    'Jar': 'command-runner.jar',
                    'Args': [
                        'spark-submit', '--deploy-mode', 'cluster',emr_step_job, job_parameter_1, job_parameter_2 ]
                }
            }
        ],
        job_flow_id=cluster_id,
        aws_conn_id='aws_default',
        wait_for_completion=True
    )

    config_crawler = {"Name": crawler_name}

    #     glue_crawler_config = {
    #     'Name': glue_crawler_name,
    #     'Role': role_arn,
    #     'DatabaseName': glue_db_name,
    #     'Targets': {'S3Targets': [{'Path': f'{bucket_name}/input'}]},
    # }

    #    # [START howto_operator_glue_crawler]
    # crawl_s3 = GlueCrawlerOperator(
    #     task_id='crawl_s3',
    #     config=glue_crawler_config,
    # )
    # # [END howto_operator_glue_crawler]

    # # GlueCrawlerOperator waits by default, setting as False to test the Sensor below.
    # crawl_s3.wait_for_completion = False

    # # [START howto_sensor_glue_crawler]
    # wait_for_crawl = GlueCrawlerSensor(
    #     task_id='wait_for_crawl',
    #     crawler_name=glue_crawler_name,
    # )
    # # [END howto_sensor_glue_crawler]

    glue_crawler = GlueCrawlerOperator(
        task_id="glue_crawler",
        config=config_crawler,
        dag=dag)

    extreme_weather_calc
    extreme_weather_calc.set_downstream(glue_crawler)
