# MIT No Attribution

# Copyright 2021 Amazon.com, Inc. or its affiliates

# Permission is hereby granted, free of charge, to any person obtaining a copy of this
# software and associated documentation files (the "Software"), to deal in the Software
# without restriction, including without limitation the rights to use, copy, modify,
# merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
# INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
# PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
# HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


#spark-submit --deploy-mode cluster --conf spark.driver.cores=1 --conf spark.driver.memory=3g --conf spark.executor.cores=4 --conf spark.executor.memory=3g --conf spark.executor.instances=5 s3://src-pdr-dev-ad-score-assets-us-east-1-705158173663/extreme_weather.py s3://src-pdr-dev-ad-score-raw-us-east-1-705158173663/ src-pdr-dev-ad-score-stage-us-east-1-705158173663

import sys
from datetime import date

from pyspark.sql import SparkSession, DataFrame, Row
from pyspark.sql import functions as F


def findLargest(df: DataFrame, col_name: str) -> Row:
    """
    Find the largest value in `col_name` column.
    Values of 99.99, 999.9 and 9999.9 are excluded because they indicate "no reading" for that attribute.
    While 99.99 _could_ be a valid value for temperature, for example, we know there are higher readings.
    """
    return (
        df.select(
            "STATION", "DATE", "LATITUDE", "LONGITUDE", "ELEVATION", "NAME", col_name
        )
        .filter(~F.col(col_name).isin([99.99, 999.9, 9999.9]))
        .orderBy(F.desc(col_name))
        .limit(1)
        .first()
    )


if __name__ == "__main__":
    """
    Usage: extreme-weather s3_source_location s3_target_location

    Displays extreme weather stats (highest temperature, wind, precipitation) for the given, or latest, year.

    
    """
    spark = SparkSession.builder.appName("ExtremeWeather").getOrCreate()

    if len(sys.argv) > 2:
        #year = sys.argv[1]
        s3_source_location = sys.argv[1]
        s3_target_location = sys.argv[2]
        
    else:
        print(f"Arguments are S3-Bucket-source-location s3-Bucket-target-location")
        #year = date.today().year
        # print(f"executing with default values")
        # s3_source_location = "s3://dev-src-raw-us-east-1-194732148124/2023/"
        # s3_target_location = "s3://dev-src-stage-us-east-1-194732148124/example-result/""

    

    # df = spark.read.csv(f"s3://dev-src-raw-us-east-1-194732148124/{year}/", header=True, inferSchema=True)
    
    df = spark.read.csv(f"{s3_source_location}", header=True, inferSchema=True)
    
    print(f"The amount of weather readings is: {df.count()}\n")

    

    print(f"Here are some extreme weather stats for:")
    stats_to_gather = [
        {"description": "Highest temperature", "column_name": "MAX", "units": "°F"},
        {
            "description": "Highest all-day average temperature",
            "column_name": "TEMP",
            "units": "°F",
        },
        {"description": "Highest wind gust", "column_name": "GUST", "units": "mph"},
        {
            "description": "Highest average wind speed",
            "column_name": "WDSP",
            "units": "mph",
        },
        {
            "description": "Highest precipitation",
            "column_name": "PRCP",
            "units": "inches",
        },
    ]

    for stat in stats_to_gather:
        max_row = findLargest(df, stat["column_name"])
        print(
            f"  {stat['description']}: {max_row[stat['column_name']]}{stat['units']} on {max_row.DATE} at {max_row.NAME} ({max_row.LATITUDE}, {max_row.LONGITUDE})"
        )
    df.write.mode("overwrite").parquet(s3_target_location)
    # max_row.write.mode("overwrite").parquet(s3_target_location)
