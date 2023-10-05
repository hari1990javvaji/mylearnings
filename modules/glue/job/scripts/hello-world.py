import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
 
## @params: [JOB_NAME]
args = getResolvedOptions(sys.argv, ['JOB_NAME'])
args = getResolvedOptions(sys.argv, ["JOB_NAME","s3OutputBucket"])

 
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args['JOB_NAME'], args)
s3OutputBucket = args['s3OutputBucket']

# Assign the target bucket to a variable
s3_bucket = 's3://'+s3OutputBucket+'/glue/output/hello_world/'
 
# Create Hello World Dataframe
dataframe = spark.createDataFrame([("Hello", "World")])

# Coalesce the data to 1 file
# Format as CSV
# Save the array to your s3_bucket
# Overwrite what's there
dataframe.coalesce(1).write.csv(s3_bucket, mode="overwrite")
 
job.commit()