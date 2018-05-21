from pyspark.sql import SparkSession
from pyspark.sql.functions import *

spark = SparkSession.builder \
                    .master("local") \
                    .appName("My Test") \
                    .getOrCreate()

df = spark.range(10)

res = df.collect()
print('******')
print(res)
print('******')
