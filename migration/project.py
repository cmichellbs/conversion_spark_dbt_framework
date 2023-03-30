import os
from dotenv import load_dotenv
load_dotenv()

###dbt profiles dir ###
DBT_PROFILES_DIR = os.getenv('DBT_PROFILES_DIR')

###cliente a ser migrado ###
CLIENTE = os.getenv('CLIENTE')

###conexão sansys_template###
PGHOST = os.getenv('PGHOST')
PGDB = os.getenv('PGDB')
PGUSR = os.getenv('PGUSR')
PGPWD = os.getenv('PGPWD')
PGPORT= os.getenv('PGPORT')
PGCONTEXT = os.getenv('PGCONTEXT')


###schema onde o modelo é armazenado###
MODEL_SCHEMA=os.getenv('MODEL_SCHEMA')

###conexão com banco de origem###
MSHOST = os.getenv('MSHOST')
MSDB = os.getenv('MSDB')
MSSCHEMA = os.getenv('MSSCHEMA')
MSUSR = os.getenv('MSUSR')
MSPWD = os.getenv('MSPWD')
MSPORT= os.getenv('MSPORT')
MSCONTEXT = os.getenv('MSCONTEXT')
MSQUERY= os.getenv('MSQUERY')
MSDRIVER = os.getenv('MSDRIVER')

###conexão com ERP J-tech###
ERP_HOST = os.getenv('ERP_HOST')
ERP_DB = os.getenv('ERP_DB')
ERP_USR = os.getenv('ERP_USR')
ERP_PWD = os.getenv('ERP_PWD')
ERP_PORT = os.getenv('ERP_PORT')
ERP_CONTEXT = os.getenv('ERP_CONTEXT')
