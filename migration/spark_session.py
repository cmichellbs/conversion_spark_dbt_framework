from pyspark.sql import SparkSession


# Buil spark session
import pathlib
root_path = pathlib.Path(__file__).parent.resolve().parent.resolve()
spark = SparkSession.builder\
    .master("local").appName("migration_load")\
    .config("spark.jars", f"""{root_path}/jar/postgresql.jar,{root_path}/jar/mssql-jdbc-10.2.3.jre8.jar""") \
    .config("spark.driver.extraClassPath", f"{root_path}/jar/sqlserver.jar")\
    .config("spark.executor.extraClassPath", f"{root_path}/jar/sqlserver.jar")\
    .config('spark.driver.memory', '16g')\
    .config('spark.executor.memory', '16g')\
    .config('spark.executor.cores', 8)\
    .getOrCreate()
spark.sparkContext.setLogLevel("ERROR")
# spark.sparkContext.setLocalProperty("spark.scheduler.pool", "fair_pool")
    # .config("spark.scheduler.mode", "FAIR")\
    # .config("spark.scheduler.allocation.file", "/home/christhian.souza/projects/migration/jar/pool.xml")\