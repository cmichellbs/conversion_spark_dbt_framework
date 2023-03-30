import os,ast
from typing import Literal
from migration.databases import Database
from .project import *
from .logger import *

def evaluation(data_type, nullable,default=None):
    data_type = str(data_type)
    nullable = str(nullable)
    if nullable =='NOT NULL' and default is None:
        if data_type == 'bigint':
            return 'coalesce(campo_a_ser_migrado, 0)'
        elif data_type == 'integer':
            return 'coalesce(campo_a_ser_migrado, 0)'
        elif data_type == 'smallint':
            return 'coalesce(campo_a_ser_migrado, 0)'
        elif data_type == 'text':
            return "coalesce(campo_a_ser_migrado, 'SETTING DEFAULT TEXT')"
        elif data_type == 'character varying':
            return "coalesce(campo_a_ser_migrado, 'STRING')"
        elif data_type == 'boolean':
            return 'coalesce(campo_a_ser_migrado, cast(0 as BIT))'
        elif data_type == 'timestamp without time zone':
            return 'coalesce(campo_a_ser_migrado, NOW())'
        elif data_type == 'double precision':
            return 'coalesce(campo_a_ser_migrado, 0.0)'
        else:
            return 'invalid data type'
    elif nullable =='NULL' and default is None:
        if data_type == 'bigint':
            return  0
        elif data_type == 'integer':
            return 0
        elif data_type == 'smallint':
            return 0
        elif data_type == 'text':
            return '"SETTING DEFAULT TEXT"'
        elif data_type == 'character varying':
            return "'STRING'"
        elif data_type == 'boolean':
            return 'cast(0 as BIT)'
        elif data_type == 'timestamp without time zone':
            return 'NOW()'
        elif data_type == 'double precision':
            return  0.0
        else:
            return 'invalid data type'
    elif (nullable =='NULL' and default is not None) or (nullable =='NOT NULL' and default is not None):
        return 'Auto_increment'
    else:
        return 'invalid data type'

def cliente_eval():
    if str(os.getenv('MSCONTEXT')) == str("mssql+pyodbc"):

        return Database(host=MSHOST, db=MSDB, usr=MSUSR, pwd=MSPWD, port=MSPORT, context=MSCONTEXT, query={"driver": "ODBC Driver 18 for SQL Server", "TrustServerCertificate": "yes"})

    else:
    
        return Database(host=MSHOST, db=MSDB, usr=MSUSR, pwd=MSPWD, port=MSPORT, context=MSCONTEXT)


def chunks(lst, n):
    """Yield successive n-sized chunks from lst."""
    for i in range(0, len(lst), n):
        yield lst[i:i + n]
    logger.info(f'chunk {i+1} instanciated')


def ifnull(var, val):
    if var is None:
        return val
    return var
