from .logger import *
import pandas as pd
from .conn import sansys
from .utils import *
from sqlalchemy.sql import text
from .spark_session import spark
import time
def update_table_query(schema, table, where, columns, limit=None, query_where=None, insert_where=None):
    full_query = []
    columns.append(where)
    fetch_columns = ','.join(columns)
    if query_where == None:
        if limit == None:
            sql_fetch = f'''select {fetch_columns} from {schema}.{table}'''
        else:
            sql_fetch = f'''select {fetch_columns} from {schema}.{table} limit {limit}'''
    else:
        if limit == None:
            sql_fetch = f'''select {fetch_columns} from {schema}.{table} {query_where}'''
        else:
            sql_fetch = f'''select {fetch_columns} from {schema}.{table} {query_where} limit {limit}'''
    
    spdf =  spark.read.format("jdbc") \
            .option("url", f"""jdbc:sqlserver://{MSHOST}:{MSPORT};databaseName={MSDB};""") \
            .option("user", f"""{MSUSR}""") \
            .option("password", f"""{MSPWD}""") \
            .option("fetchsize", "100000") \
            .option("driver", "com.microsoft.sqlserver.jdbc.SQLServerDriver") \
            .option("trustServerCertificate", "true") \
            .option("query", f"{sql_fetch}") \
            .load()
    
    df = spdf.toPandas()
    # df=df.infer_objects()

    df = df.applymap(str)

    for index, row in df.iterrows():
        fetch_columns_set = []

        for column in columns:
            column_cast = sansys.get_column_data(table, 'public', column)
            if column != where:
                column_to_set = f"""{column} = cast('{ifnull(row[column],0.0)}' as {column_cast['type']})""".replace(
                    'DOUBLE_PRECISION', 'decimal(16,2)')
                fetch_columns_set.append(column_to_set)
            else:
                continue
        fetch_columns_set = 'set '+','.join(fetch_columns_set)
        if insert_where == None:
            sql = f'''update {table} {fetch_columns_set} where {where} = cast('{row[where]}' as {sansys.get_column_data(table,'public',where)['type']});'''.replace(
                'DOUBLE_PRECISION', 'decimal(16,2)')
        else:
            sql = f'''update {table} {fetch_columns_set} where {where} = cast('{row[where]}' as {sansys.get_column_data(table,'public',where)['type']}) {insert_where} ;'''.replace(
                'DOUBLE_PRECISION', 'decimal(16,2)')

        full_query.append(sql)
    logger.info(f'query for update table {table} generated')

    # print(df.dtypes)

    return full_query


def update_table(schema, table, where, columns, limit=None, query_where=None, insert_where=None):
    query = update_table_query(
        schema, table, where, columns, limit, query_where, insert_where)
    result = ''' '''.join(query)
    # with open('./test.sql','w') as file:
    #     file.write(result)
    #     file.close()
    index_create = f'''CREATE INDEX {table}_{where}_idx ON public.{table} ({where});'''
    try:
        with sansys.engine.connect() as conn:
            conn.execute(text(index_create))
        logger.info(f'index for {table} created')
    except Exception as e:
        logger.error(e)
        print("Index já existe")

    for item in chunks(query, 2000):
        result = ''' '''.join(item)
        try:
            with sansys.engine.connect() as conn:
                conn.execute(text(result))
                print(f'linha atualizada on {sansys.db}')
                logger.info(f'linha atualizada on {sansys.db}')
            print(f'''tabela {table} atualizada com sucesso''')
            logger.info(f'''tabela {table} atualizada com sucesso''')

        except Exception as e:
            print('erro!')
            print(e)
            logger.error(e)
            break
            continue
    index_drop = f'''DROP INDEX {table}_{where}_idx;'''
    try:
        with sansys.engine.connect() as conn:
            conn.execute(text(index_drop))
        logger.info(f'''index {table} droped''')
    except Exception as e:
        logger.error(e)
        print("Index não existe")

def rollback(table, where=None):
    with sansys.engine.begin() as conn:  # iniciando migração

        if where == None:
            sql = f"""delete from {table} where mig_fl_temp = 'S' """
            try:
                conn.execute(sql)
                print(f'''rollback em {table} executado''')
                logger.info(f'''rollback em {table} executado''')
            except Exception as e:
                print(e)
                logger.error(e)
        else:
            sql = f"""delete from {table} where {where} """
            try:
                conn.execute(sql)
                print(f'''rollback em {table} executado''')
                logger.info(f'''rollback em {table} executado''')

            except Exception as e:
                print(e)
                logger.error(e)

# def batch_rollback(schema_sansys = 'public'):
#     df = sansys.get_association()
#     df = df.sort_index(ascending=False)
#     for index, row in df.iterrows():
#         schema = schema_sansys
#         table = row['nm_dominio']
#         try:
#             rollback(table)
#             logger.info(f' rollback em {schema}.{table} executado!')
#         except Exception as e:
#             print('processo interrompido em {schema}.{table} por erro:')
#             print(e)
#             logger.error(e)
#             break
#     sequence_update()
#     inf_tabela_basica_update()

if __name__ == '__main__':
    # print('ola')
    update_table('dbo_mig','fat_fatura_componente_tabela_tarifaria','id_fatura_componente',['vl_agua','vl_esgoto','qt_consumo'])
    # update_table('dbo_mig','cad_unidade_ligacao_esgoto','nr_ligacao_esgoto',['ch_ativo',])
