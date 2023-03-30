from .utils import evaluation
from .conn import sansys
from .project import *
import pandas as pd

from migration.logger import *


def get_dependencies(table):
    sql = f"""SELECT
                tc.table_schema, 
                tc.constraint_name, 
                tc.table_name, 
                kcu.column_name, 
                ccu.table_schema AS foreign_table_schema,
                ccu.table_name AS foreign_table_name,
                ccu.column_name AS foreign_column_name 
            FROM 
                information_schema.table_constraints AS tc 
                JOIN information_schema.key_column_usage AS kcu
                ON tc.constraint_name = kcu.constraint_name
                AND tc.table_schema = kcu.table_schema
                JOIN information_schema.constraint_column_usage AS ccu
                ON ccu.constraint_name = tc.constraint_name
                AND ccu.table_schema = tc.table_schema
            WHERE tc.constraint_type = 'FOREIGN KEY' AND tc.table_name='{table}'"""
    df = pd.read_sql_query(sql,sansys.engine)
    logger.info(f'dependencies returned')
    return df

def get_upstream_tables(table):
    sql = f"""SELECT distinct
    
                ccu.table_name AS foreign_table_name
                
                FROM 
                    information_schema.table_constraints AS tc 
                    JOIN information_schema.key_column_usage AS kcu
                    ON tc.constraint_name = kcu.constraint_name
                    AND tc.table_schema = kcu.table_schema
                    JOIN information_schema.constraint_column_usage AS ccu
                    ON ccu.constraint_name = tc.constraint_name
                    AND ccu.table_schema = tc.table_schema
                WHERE tc.constraint_type = 'FOREIGN KEY' AND tc.table_name='{table}'"""
    df = pd.read_sql_query(sql,sansys.engine)
    logger.info(f'upstream returned')
    return df

def get_downstream_tables(table):
    sql = f"""SELECT
                distinct
                tc.table_name
                
            FROM 
                information_schema.table_constraints AS tc 
                JOIN information_schema.key_column_usage AS kcu
                ON tc.constraint_name = kcu.constraint_name
                AND tc.table_schema = kcu.table_schema
                JOIN information_schema.constraint_column_usage AS ccu
                ON ccu.constraint_name = tc.constraint_name
                AND ccu.table_schema = tc.table_schema
            WHERE tc.constraint_type = 'FOREIGN KEY' AND ccu.table_name='{table}'"""
    df = pd.read_sql_query(sql,sansys.engine)
    logger.info(f'downstram returned')
    return df

# declare a function that receives a string and returns a string with all letters capitalized
def capitalize(string):
    return string.upper()
# declare a function that receives a table to consult on sansys and a filename to write the template
def generate_template(table_consult,filename,path):
   with open(f'{path}{filename}.sql','w') as file:
        file.write('SELECT'+'\n')
        columns = sansys.get_columns(table_consult)
        df = sansys.get_constraints_sansys(table_consult)
        for column in columns:
            loc = df.loc[(df['column_name'] == column['name']),['type','is_nullable','column_default']].reset_index(drop=True)
            default = evaluation(loc['type'].values[0],loc['is_nullable'].values[0],loc['column_default'].values[0])
            file.write(f'''{default} as ''' + capitalize(column['name'])+','+'\n')
        file.write("'S' as MIG_FL_TEMP"+'\n')
        file.write('FROM'+'\n')
        file.write('''{{ref('')}}''' + '\n')
        file.write('''{{source('','')}}''')
        print(f'{filename}.sql done')
        logger.info(f'{filename}.sql done')
        file.close()
def generate_upstream(table):
    cliente = CLIENTE
    df = get_upstream_tables(table)
    for index, row in df.iterrows():
        generate_template(row['foreign_table_name'],row['foreign_table_name'],f'{pathlib.Path(__file__).parent.resolve().parent.resolve()}/dbt_veolia/models/{cliente}/marts/')
    logger.info(f'upstream tables generated')

def generate_downstream(table):
    cliente = CLIENTE
    df = get_downstream_tables(table)
    for index, row in df.iterrows():
        generate_template(row['table_name'],row['table_name'],f'{pathlib.Path(__file__).parent.resolve().parent.resolve()}/dbt_veolia/models/{cliente}/marts/')
    logger.info(f'downstream tables generated')
def generate_all_templates():
    cliente = CLIENTE
    tables = sansys.get_tables()
    for table in tables:
        generate_template(table,table,f'{pathlib.Path(__file__).parent.resolve().parent.resolve()}/dbt_veolia/models/{cliente}/marts/')
    logger.info(f'all templates generated')
if __name__=='__main__':

    # generate_downstream('tab_tabela_tarifaria_servico')
    cliente = CLIENTE
    generate_template('tab_tarifa_servico_definicao','tab_tarifa_servico_definicao',f'{pathlib.Path(__file__).parent.resolve().parent.resolve()}/dbt_veolia/models/{cliente}/marts/')
    