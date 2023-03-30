from sqlalchemy.sql import text
import time
from .logger import *
from .spark_session import spark
from .conn import sansys,cliente
import pandas as pd
from .project import *
from .utils import chunks
from .constraints import constraints_add_list,constraints_drop_list

##################################################################################################

def init_migration(schema=None, table=None, runner='spark', cliente=cliente, sansys=sansys):
    # iniciar checagem de compatibilidade de colunas
    dbcheck = sansys.get_columns(table)

    dbcheck_fetch = []  # colunas existentes no sansys serão inseridas aqui
    for tb in dbcheck:
        dbcheck_fetch.append(tb['name'])

    # colunas na tabela homônima no banco de origem
    columns = cliente.get_columns(table, schema)
    fetch_columns = []  # listagem das colunas que serão de fato migradas. Caso não exista uma coluna correspondente no sansys, esta será criada
    order_by = None
    for column in columns:
        if column['name'].lower() in dbcheck_fetch:
            # #sem cast
            # fetch_columns.append(column['name'].lower())

            # com cast
            cast = f'''cast({column['name'].lower()} as {sansys.get_column_data(table,'public',str(column['name']).lower())['type']}) as {column['name'].lower()}'''
            fetch_columns.append(cast.lower().replace('DOUBLE_PRECISION', 'decimal(16,2)').replace('double_precision', 'decimal(16,2)').replace(
                'BOOLEAN', 'bit').replace('boolean', 'bit').replace('BOOL', 'bit').replace('bool', 'bit').replace('TIMESTAMP', 'datetime').replace('timestamp', 'datetime'))
        elif column['name'].startswith('MIG') or column['name'].startswith('mig'):
            with sansys.engine.connect() as conn:
                sql = f'''alter table {table} add  {column['name']} varchar(300);'''  # query que cria uma coluna mig_pk_temp no banco do sansys quando ela ainda não existe
                conn.execute(sql)
            fetch_columns.append(column['name'].lower())
        else:
            continue
    # listando as colunas a serem importadas, separando por vírgula
    fetch_columns = ','.join(fetch_columns)
    select = f"""select {fetch_columns.upper()} from {schema}.{table}"""  # select das colunas no banco de origem

    if runner == 'pandas':
        with cliente.engine.connect().execution_options(stream_results=True) as conn:
            # criando um dataframe com as informações do select
            df = pd.read_sql_query(select, conn)
            # ajustando a formatação dos nomes das colunas
            df.columns = df.columns.str.lower()

            with sansys.engine.begin() as conn2:  # iniciando migração
                try:
                    df.to_sql(table, conn2, if_exists='append',
                              index=False, chunksize=25000
                              #   ,method='multi'
                              )  # migrando o dataframe para a tabela correspondente no sansys no modo debug, o chuncksize determina o passo da migração
                    print(f'{table} migrated')
                    logger.info(f'{table} migrada')
                except Exception as e:
                    print(e)
                    logger.error(e)

    else:
        
        df = spark.read.format("jdbc") \
            .option("url", f"""jdbc:sqlserver://{MSHOST}:{MSPORT};databaseName={MSDB};""") \
            .option("user", f"""{MSUSR}""") \
            .option("password", f"""{MSPWD}""") \
            .option("fetchsize", "100000") \
            .option("driver", "com.microsoft.sqlserver.jdbc.SQLServerDriver") \
            .option("trustServerCertificate", "true") \
            .option("query", f"{select}") \
            .load()

        for col in df.columns:
            df = df.withColumnRenamed(col, col.lower())

        try:
            df.select('*').write.mode("append").format('jdbc').option('url', f'''jdbc:postgresql://{PGHOST}:{PGPORT}/{PGDB}''')\
                .option('driver', 'org.postgresql.Driver').option('dbtable', f'''public.{table}''')\
                .option("fetchsize", "100000") \
                .option("batchsize", "100000") \
                .option('user', f'''{PGUSR}''').option('password', f'''{PGPWD}''').save()

            logger.info(f'{table} migrada')
            print(f'{table} migrada')
        except Exception as e:
            print(e)
            logger.error(e)
         
##################################################################################################

def preimport(preimportloc=None):  # executa arquivo sql antes da importação
    if preimportloc != None:
        try:
            with open(preimportloc, 'r') as file:
                sql = file.read()
            with sansys.engine.connect() as conn:
                conn.execute(text(sql))
            logger.info(f'preimport executed')
        except Exception as e:
            logger.error(e)
    else:
        print('Sem procedimento antes da importação')
        logger.info(f'Sem procedimento antes da importação')

################################################################################################## 

def posimport(posimportloc=None):  # executa arquivo sql após da importação
    if posimportloc != None:
        try:
            with open(posimportloc, 'r') as file:
                sql = file.read()
            with sansys.engine.connect() as conn:
                conn.execute(sql)
            logger.info(f'posimport executed')
        except Exception as e:
            logger.error(e)

    else:
        print('Sem procedimento pós importação')
        logger.info(f'Sem procedimento antes da importação')

##################################################################################################

# def inf_tabela_basica_update():
#     sql = 'select * from inf_tabela_basica'
#     df = pd.read_sql_query(sql, sansys.engine)
#     with sansys.engine.connect() as conn:
#         for index, row in df.iterrows():
#             update_sttm = f"""update inf_tabela_basica set id_proxima_tabela = (select coalesce(max({row['nm_campo_chave']}),0) + 1 from {row['nm_tabela_banco']}) where nm_tabela_banco = '{row['nm_tabela_banco']}';"""
#             try:
#                 conn.execute(text(update_sttm))
#             except Exception as e:
#                 # print(e)
#                 logger.error(e)
#                 print(
#                     f'''row {row['nm_tabela_banco']} from inf_tabela_basica !!!!NOT!!!! updated successfully!''')
#                 continue

##################################################################################################

# def sequence_update():
#     with sansys.engine.connect() as conn2:
#         # atualizando o sequence da tabela do sansys
#         where = sansys.get_where_association()
#         for table in sansys.get_tables():
#             column = sansys.get_columns(table)[0]
#             try:
#                 column = sansys.get_columns(table)[0]
#                 if column['default'] is None:
#                     continue
#                 else:
#                     sql = f''' SELECT setval({column['default'].split('(')[1].split('::')[0]}, max({column['name']}), true) from {table}'''
#                     conn2.execute(sql)
#             except Exception as e:
#                 print(e)
#                 logger.error(e)
#                 print('ocorreu um erro')


##################################################################################################
# def constraints_add_job():
#     from .constraints import constraints_add_list
#     return constraints_add_list

# def constraints_drop_job():
#     from .constraints import constraints_drop_list
#     return constraints_drop_list

def create_all_constraints(fetch):
    counter =0
    with sansys.engine.connect() as conn:
        for fk in fetch:
            try:
                conn.execute(text(fk))
                counter +=1
            except Exception as e:
                print(f'não foi possivel executar drop_all_constraints')
                logger.debug(f'não foi possivel executar create_all_constraints')
                logger.error(e)
                break
    logger.info(f'{len(fetch)} constraints created')

##################################################################################################

def drop_all_constraints(fetch):
    counter =0
    with sansys.engine.connect() as conn:
        for fk in fetch:
            try:
                conn.execute(text(fk))
                counter +=1
            except Exception as e:
                print(f'não foi possivel executar drop_all_constraints')
                logger.debug(f'não foi possivel executar drop_all_constraints')
                logger.error(e)
                break
    logger.info(f'{counter}/{len(fetch)} constraints droped')

##################################################################################################

def batch_migrate(origin_schema=None, preimportloc=None, posimportloc=None, runner='spark'):

    association = sansys.get_where_association()
    time.sleep(10)
    drop_all_constraints(constraints_drop_list)
    time.sleep(10)
    preimport(preimportloc=preimportloc) # preparação do sansys
    time.sleep(10)
    sansys.sequence_update()
    time.sleep(10)

    errors = []
    for table_assoc in association:
        schema = origin_schema
        try:
            init_migration(schema=schema, table=table_assoc, runner=runner)
        except Exception as e:
            errors.append(str(table_assoc))
            logger.error(e)
            continue
    time.sleep(10)
    create_all_constraints(constraints_add_list)
    sansys.sequence_update()
    time.sleep(10)
    posimport(posimportloc=posimportloc) # preparação do sansys
    time.sleep(10)
    sansys.sequence_update()
    time.sleep(10)
    sansys.inf_tabela_basica_update()
    time.sleep(10)
    print('Finalizado!')
    print('Tabelas com erro: ', errors)
    sansys.carrega_contacts_papakura()
    logger.info('Finalizado!')
    logger.warn('Tabelas com erro: ', errors)

##################################################################################################

def atualiza_fin_cc_pagamento():
    sql = f"""with base as (select fcc.id_conta_corrente , fccm.dt_movimentacao, fccm.nr_sequencial_registro ,fccmp.*,fccm.vl_movimentacao,coalesce(lag(fccm.vl_saldo_atual,-1) over(partition by fcc.id_conta_corrente order by fccm.dt_movimentacao desc),0) as saldo_anterior, fccm.vl_saldo_atual from fin_conta_corrente_movimentacao fccm
                left join fin_conta_corrente_movimentacao_pagamento fccmp on fccm.id_conta_corrente_movimentacao  = fccmp.id_conta_corrente_movimentacao
                inner join fin_conta_corrente fcc on fcc.id_conta_corrente = fccm.id_conta_corrente 
                order by fcc.id_conta_corrente desc , fccm.dt_movimentacao desc)

                ,final as (select *,
                case 
                	when vl_movimentacao = saldo_anterior*-1 then 'N' else 'S'
                end as tratar  
                ,
                case 
                	when vl_movimentacao <> saldo_anterior*-1 and saldo_anterior <=0 then 'S' else 'N'
                end as baixado_zerado_nao_concluido ,

                case 
                	when vl_movimentacao <> saldo_anterior*-1 and saldo_anterior > 0 then 'S' else 'N'
                end as baixado_não_zerado_nao_concluid

                from base where id_conta_corrente_movimentacao is not null )

                select *,
                case when baixado_zerado_nao_concluido = 'S' then 0 else saldo_anterior end as vl_baixado_novo

                from final where tratar ='S'
                """
    df = pd.read_sql_query(sql, sansys.engine)
    with sansys.engine.connect() as conn:
        update = []
        for index, row in df.iterrows():
            sttm = f"""update fin_conta_corrente_movimentacao_pagamento set vl_baixado = {row['vl_baixado_novo']},fl_concluido = false where id_conta_corrente_movimentacao_pagamento = {row['id_conta_corrente_movimentacao_pagamento']};"""
            update.append(sttm)
        update_query = """ """.join(update)
        try:
            conn.execute(text(update_query))
            print('concluido com sucesso!')
        except Exception as e:
            print(e)
            logger.error(e)

##################################################################################################

