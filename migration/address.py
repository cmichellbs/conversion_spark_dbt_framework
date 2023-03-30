import pandas as pd
import time
import sqlalchemy 
from glob import glob
import psycopg2
from sqlalchemy import create_engine
from dotenv import load_dotenv
load_dotenv()
from rapidfuzz import process, fuzz
import os
import re
from migration.databases import Database
from sqlalchemy.sql import text
from datetime import datetime
from migration.utils import cliente_eval
from migration.spark_session import spark
from migration.project import *
from migration.conn import *
from pyspark.sql import functions as F, types as T

def carrega_arquivos_endereco():
    arquivo = f'{pathlib.Path(__file__).parent.resolve().parent.resolve()}/clientes/papakura/nz_address/nz_full_address.csv'
    
    nome_arquivo = os.path.basename(arquivo).split('.')[0]
    nome_arquivo = nome_arquivo.replace('-','_')
        
    df = spark.read.option('header','true').csv(arquivo)
        
    return df.select('*').write.format("jdbc") \
                .option("url", f"""jdbc:sqlserver://{MSHOST}:{MSPORT};databaseName={MSDB};""") \
                .option("user", f"""{MSUSR}""") \
                .option("password", f"""{MSPWD}""") \
                .option("driver", "com.microsoft.sqlserver.jdbc.SQLServerDriver") \
                .option("trustServerCertificate", "true") \
                .option("dbtable", f"dbo_mig.{nome_arquivo}") \
                .save(); print('carga de nz_full_address finalizada')

def func_wratio(x):
    search=x
    if search is None:
        search = 'unknown'
    else:
        search
    # choice = spark.sparkContext.parallelize(match,1000)
    choice = match

    chosen1 = process.extractOne(search,choice,scorer=fuzz.WRatio)
    # chosen2 = process.extractOne(search,choice,scorer=fuzz.token_sort_ratio)
    # chosen3 = process.extractOne(search,choice,scorer=fuzz.token_set_ratio)
    chosen1,_,__ = chosen1
    # chosen2,_,__ = chosen2
    # chosen3,_,__ = chosen3
    return chosen1
    
def func_token_sort_ratio(x):
    search=x
    if search is None:
        search = 'unknown'
    else:
        search
    # choice = spark.sparkContext.parallelize(match,1000)
    choice = match

    # chosen1 = process.extractOne(search,choice,scorer=fuzz.WRatio)
    chosen2 = process.extractOne(search,choice,scorer=fuzz.token_sort_ratio)
    # chosen3 = process.extractOne(search,choice,scorer=fuzz.token_set_ratio)
    # chosen1,_,__ = chosen1
    chosen2,_,__ = chosen2
    # chosen3,_,__ = chosen3
    return chosen2

def func_token_set_ratio(x):
    search=x
    if search is None:
        search = 'unknown'
    else:
        search
    # choice = spark.sparkContext.parallelize(match,1000)
    choice = match

    # chosen1 = process.extractOne(search,choice,scorer=fuzz.WRatio)
    # chosen2 = process.extractOne(search,choice,scorer=fuzz.token_sort_ratio)
    chosen3 = process.extractOne(search,choice,scorer=fuzz.token_set_ratio)
    # chosen1,_,__ = chosen1
    # chosen2,_,__ = chosen2
    chosen3,_,__ = chosen3
    return chosen3

def nz_full_address():
    df_address= spark.read.format('jdbc')\
                .option("url", f"""jdbc:sqlserver://{MSHOST}:{MSPORT};databaseName={MSDB};""")\
                .option("driver", "com.microsoft.sqlserver.jdbc.SQLServerDriver") \
                .option("trustServerCertificate", "true") \
                .option('query', f'''select distinct full_road_name from dbo_mig.nz_full_address''')\
                .option("fetchsize", "100000") \
                .option('user', f'''{MSUSR}''').option('password', f'''{MSPWD}''').load()
    return df_address.select('full_road_name').rdd.flatMap(lambda x: x).collect()

match = nz_full_address()

func_wratioUDF = F.udf(lambda x: func_wratio(x),T.StringType())
func_func_token_sort_ratioUDF = F.udf(lambda x: func_token_sort_ratio(x),T.StringType())
func_func_token_set_ratioUDF = F.udf(lambda x: func_token_set_ratio(x),T.StringType())

def fuzzy_match_pre():
    spdf_loc = spark.read.format('jdbc')\
                .option("url", f"""jdbc:sqlserver://{MSHOST}:{MSPORT};databaseName={MSDB};""")\
                .option("driver", "com.microsoft.sqlserver.jdbc.SQLServerDriver") \
                .option("trustServerCertificate", "true") \
                .option('query', f'''select * from dbo.LOCADDRESS''')\
                .option("fetchsize", "100000") \
                .option('user', f'''{MSUSR}''').option('password', f'''{MSPWD}''').load()


    return spdf_loc.withColumn('wratio',func_wratioUDF(F.col('LOCA_STREET')))\
                .withColumn('token_sort_ratio',func_func_token_sort_ratioUDF(F.col('LOCA_STREET')))\
                .withColumn('token_set_ratio',func_func_token_set_ratioUDF(F.col('LOCA_STREET')))\
                .select('*').write.mode("overwrite").format('jdbc')\
                .option("url", f"""jdbc:sqlserver://{MSHOST}:{MSPORT};databaseName={MSDB};""")\
                .option('user', f'''{MSUSR}''').option('password', f'''{MSPWD}''') \
                .option("driver", "com.microsoft.sqlserver.jdbc.SQLServerDriver") \
                .option("trustServerCertificate", "true") \
                .option('dbtable', f'''dbo_mig.LOCADDRESS_MATCH''')\
                .option("fetchsize", "100000") \
                .option("batchsize", "100000") \
                .save()

def best_matches():   
    spdf_best = spark.read.format('jdbc')\
                .option("url", f"""jdbc:sqlserver://{MSHOST}:{MSPORT};databaseName={MSDB};""")\
                .option('user', f'''{MSUSR}''').option('password', f'''{MSPWD}''') \
                .option("driver", "com.microsoft.sqlserver.jdbc.SQLServerDriver") \
                .option("trustServerCertificate", "true") \
                .option('query', f'''select * from dbo_mig.LOCADDRESS_MATCH''')\
                .option("fetchsize", "100000") \
                .option("batchsize", "100000") \
                .load()

    pdf_best = spdf_best.toPandas()
    pdf_best = pdf_best.set_index('SEQNO')
    return pdf_best


def fuzzy_match():
    carrega_arquivos_endereco()
    time.sleep(10)
    fuzzy_match_pre()
    time.sleep(10)
    

    for index, row in best_matches():
        search = row['LOCA_STREET']
        if search is None:
            continue
        else:
            choice = [row['wratio'],row['token_sort_ratio'],row['token_set_ratio']]
            # chosen1 = process.extractOne(search,choice,scorer=fuzz.WRatio)
            # chosen2 = process.extractOne(search,choice,scorer=fuzz.token_sort_ratio)
            chosen3 = process.extractOne(search,choice,scorer=fuzz.token_set_ratio)
            # chosen1,_,__ = chosen1
            # chosen2,_,__ = chosen2
            chosen3,_,__ = chosen3
            new_row = {'SEQNO':index, 
            'LOC_NAME':row['LOCA_STREET'], 
            # 'LOC_BEST_MATCH1':chosen1,
            # 'LOC_BEST_MATCH2':chosen2,
            'LOC_BEST_MATCH3':chosen3
            }
            df_result = pd.DataFrame(new_row,index=[0])
            # df_result = df_result
            df_result.to_sql(f'loc_best_match',sansys.engine,if_exists= 'append',schema='nz_address')


if __name__ == '__main__':
    fuzzy_match()