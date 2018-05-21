from pyspark.sql.functions import *

#1
df1 = spark.range(20).toDF("x")



#2
df2 = df1.withColumn("y", expr("sqrt(x)")).withColumn("z", expr("x*x"))



#3
 df2.withColumn("even", expr("z % 2 = 0")).groupBy("even").avg("z").show()
# +-----+------+
# | even|avg(z)|
# +-----+------+
# | true| 114.0|
# |false| 133.0|
# +-----+------+



# 5 - number of runs for each year
batting = spark.read.format("csv") \
  .option("inferSchema", "true") \
  .option("header", "true") \
  .load("/home/chr/data/baseball/Batting.csv")

runsyear = batting.groupBy("yearID").sum("R").orderBy("yearID")

runsyear.show()
# +------+------+
# |yearID|sum(R)|
# +------+------+
# |  1871|  2659|
# |  1872|  3390|
# |  1873|  3580|
# |  1874|  3470|
# |  1875|  4234|
# |  1876|  3066|



# 6 - distinct R values
 batting.select(countDistinct("R")).show()
# +-----------------+
# |count(DISTINCT R)|
# +-----------------+
# |              167|
# +-----------------+


batting.select(approx_count_distinct("R", 0.05)).show()
# +------------------------+
# |approx_count_distinct(R)|
# +------------------------+
# |                     165|
# +------------------------+



# 7 - max number of runs
maxruns = batting.groupBy("yearID").max("R")

je = (batting["yearID"] == maxruns["yearID"]) & (batting["R"] == maxruns["max(R)"])

res = batting.join(maxruns, je).select(batting["yearID"], expr("playerID"), \
                                       maxruns["max(R)"].alias("maxruns"))

res.orderBy("yearID").show()
# +------+---------+-------+
# |yearID| playerID|maxruns|
# +------+---------+-------+
# |  1871|barnero01|     66|
# |  1872|eggleda01|     94|
# |  1873|barnero01|    125|
# |  1874|mcveyca01|     91|
# |  1875|barnero01|    115|
# |  1876|barnero01|    126|
# ...



# 8 - saving
res.write.format("csv").mode("overwrite") \
   .option("path", "/home/chr/output/maxruns").option("header", "true").save()

   
   
# 9 - runs per state
players = spark.read.format("csv")  \
   .option("inferSchema", "true") \
   .option("header", "true") \
   .load("/home/chr/data/baseball/Master.csv")

je2 = batting["playerID"] == players["playerID"]

playersext = batting.join(players, je2)

playersext.where(expr("birthCountry = 'USA'")) \
  .groupBy("birthState").sum("R").orderBy("sum(R)").show(55)

# ...
# |        GA| 39259|
# |        NJ| 41560|
# |        AL| 47678|
# |        MA| 54951|
# |        MO| 58753|
# |        FL| 60897|
# |        TX| 81326|
# |        IL|100665|
# |        OH|103800|
# |        NY|131027|
# |        PA|144675|
# |        CA|260821|
# +----------+------+
