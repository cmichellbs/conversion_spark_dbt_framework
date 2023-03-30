import sqlalchemy
from sqlalchemy import create_engine
import pandas as pd
import yaml
import json
import os
from sqlalchemy.sql import text
from glob import glob
import pathlib 
from .logger import *
from .project import *
from .spark_session import spark
                   
""" create a class that will receive the connection parameters"""   
class Database(object):
    # @lru_cache
    def __init__(self, host, db, usr, pwd, port, context, query = None,**kwargs):
        self.host = host
        self.db = db
        self.usr = usr
        self.pwd = pwd
        self.port = port
        self.context = context
        self.query = query
        self.kwargs = kwargs
        self.url= sqlalchemy.engine.URL.create(
            self.context,
            username= self.usr,
            password= self.pwd,
            host= self.host,
            port= self.port,
            database=  self.db,
            query = self.query,)
        self.engine = create_engine(self.url)
        self.inspect=sqlalchemy.inspect(self.engine)
        logger.info("database connected")
    
    ##################################################################################################

    def get_constraints(self,table):
        query = f"""SELECT con.*
                    FROM pg_catalog.pg_constraint con
                            INNER JOIN pg_catalog.pg_class rel
                                    ON rel.oid = con.conrelid
                            INNER JOIN pg_catalog.pg_namespace nsp
                                    ON nsp.oid = connamespace
                    WHERE nsp.nspname = 'public'
                            AND rel.relname = '{table}';"""
        df = pd.read_sql_query(query,self.engine)
        # logger.info("constraints generated")
        return df

    ##################################################################################################

    def get_ddl_sansys(self,table = None):
        def dump(sql, *multiparams, **params):
            print(sql.compile(dialect=engine.dialect))
        meta = self.meta

        db_uri = self.url
        engine = create_engine(db_uri, strategy='mock', executor=dump)  
        # logger.info("ddl generated")

        return meta.create_all(bind=engine)
    
    ##################################################################################################

    def get_constraints_sansys(self,table):
        query = f"""select table_name,  column_name, data_type as "type",
                        case 
                            when is_nullable = 'YES' then 'NULL' else 'NOT NULL' 
                        end as is_nullable,
                        column_default, is_generated,
                        udt_name 
                        from 
                        information_schema."columns"
                        where table_name ='{table}'
                        order by ordinal_position asc"""
        df = pd.read_sql_query(query,self.engine)
        # logger.info("constraints returned")
        return df
    
    ##################################################################################################

    def get_constraints_sansys_all(self):
        tables = self.get_tables()
        for table in tables:
            result = self.get_constraints_sansys(table)
            if tables.index(table) == 0:
                df = result
            else:
                df = pd.concat([df,result],ignore_index=True)
            print(f'{table} done')
            logger.info(f'{table} done')
        return df
    
    ##################################################################################################

    def get_tables(self):
        tables = self.inspect.get_table_names()
        tables.sort()
        # logger.info(f'tables returned:\n {tables}')

        return tables
    
    ##################################################################################################

    def get_columns(self, table = None,schema = None):
        columns = self.inspect.get_columns(table, schema)
        # logger.info(f'columns for {table} returned')
        return columns
    
    ##################################################################################################

    def get_column_data(self, table = None,schema = None, column = None):
        retrieve = None
        columns = self.inspect.get_columns(table, schema)
        for col in columns:
            if col['name'] == column:
                retrieve = col
            else:
                continue
        # logger.info(f'column data for {column} returned')
        return retrieve
    
    ##################################################################################################

    def generate_yaml(self,file_name):
        data_table = []
        tables = self.get_tables()
        for table in tables:
            result = self.get_columns(table)
            data_col=[]
            for i in result:
                data_col.append({'name':i['name']})
            data_table.append([{'name':table},{'columns':data_col}])
        
        data = data_table
        data = json.dumps(data)
       
        with open(f'{file_name}.yaml','w') as f:
            yaml.dump(json.loads(data),f)
        logger.info(f'yaml for database generated')
    
    ##################################################################################################

    def get_where_association(self):
        lista = glob(f'''{pathlib.Path(__file__).parent.resolve().parent.resolve()}/dbt_veolia/models/{CLIENTE}/marts/*''')
        where = []
        for item in lista:
            arg = os.path.basename(item)
            arg = arg.split('.')[0]
            where.append(arg)

        return where
    
    ##################################################################################################

    def association_generate(self):
        where = self.get_where_association()
        sql = f"""DROP TABLE IF EXISTS CTE_AllTables; 
                -- CREATE TEMPORARY TABLE IF NOT EXISTS CTE_AllTables 

        	    CREATE TEMPORARY TABLE CTE_AllTables AS 
                SELECT 
                    ist.table_schema AS OnTableSchema 
                    ,ist.table_name AS OnTableName  
                    ,tForeignKeyInformation.FkNullable 
                    -- WARNING: TableSchema or Tablename can contain entry-separator (';' used) 
                    ,CAST(DENSE_RANK() OVER (ORDER BY ist.table_schema, ist.table_name) AS varchar(20)) AS OnTableId 
                    ,tForeignKeyInformation.AgainstTableSchema AS AgainstTableSchema 
                    ,tForeignKeyInformation.AgainstTableName AS AgainstTableName 
                FROM INFORMATION_SCHEMA.TABLES AS ist 

                LEFT JOIN 
                ( 
                    SELECT 
                        KCU1.table_schema AS OnTableSchema 
                        ,KCU1.table_name AS OnTableName 
                    -- ,isc.COLUMN_NAME -- WARNING: Multi-column foreign-keys 
                    ,MIN(isc.IS_NULLABLE) AS FkNullable  
                        ,KCU2.table_schema AS AgainstTableSchema 
                    ,KCU2.table_name AS AgainstTableName 
                    FROM information_schema.referential_constraints AS RC 
                    
                    INNER JOIN information_schema.key_column_usage AS KCU1 
                        on KCU1.constraint_schema = 'public' 
                        AND KCU1.constraint_name = RC.constraint_name 
                        
                    INNER JOIN information_schema.key_column_usage AS KCU2 
                        on KCU2.constraint_schema = 'public'  
                        AND KCU2.constraint_name = RC.unique_constraint_name 
                        AND KCU2.ordinal_position = KCU1.ordinal_position 
                        
                    INNER JOIN INFORMATION_SCHEMA.COLUMNS AS isc 
                        ON isc.table_schema = 'public'   
                        AND isc.table_name = KCU1.table_name
                        AND isc.column_name = KCU1.column_name 
                        
                        
                    -- WARNING: table can have recursive dependency on itselfs... 
                    -- if it is ommitted, table doesn't appear because of NOCYCLE-check 
                    WHERE KCU1.table_name <> KCU2.table_name 

                    GROUP BY 
                        KCU1.table_schema -- OnTableSchema 
                        ,KCU1.table_name -- OnTableName 
                        ,KCU2.table_schema -- AgainstTableSchema 
                        ,KCU2.table_name -- AgainstTableName 

                    -- Uncomment below when you only want to check FKs that aren't nullable 
                    -- HAVING MIN(isc.IS_NULLABLE) = 'NO' 
                ) AS tForeignKeyInformation 
                    ON tForeignKeyInformation.OnTableName = ist.table_name 
                    AND tForeignKeyInformation.OnTableSchema = ist.table_schema 

                WHERE (1=1) 
                AND ist.table_type = 'BASE TABLE' 
                AND ist.table_schema IN ('public') 

                --AND NOT 
                --( 
                --	ist.table_schema = 'dbo' 
                --	AND 
                --	ist.table_name IN  
                --	( 
                --		 'MSreplication_options', 'spt_fallback_db', 'spt_fallback_dev', 'spt_fallback_usg', 'spt_monitor' 
                --		 ,'sysdiagrams', 'dtproperties' 
                --	) 
                --) 

                -- AND ist.table_name LIKE 'T[_]%' 
                -- AND ist.table_name NOT LIKE '%[_]bak[_]%' 
                -- AND ist.table_name NOT LIKE 'T[_]LOG[_]%' 

                ORDER BY OnTableSchema, OnTableName 
                ; 


                -- SELECT DISTINCT OnTableSchema, OnTableName FROM #CTE_AllTables; 


                ; WITH RECURSIVE CTE_RecursiveDependencyResolution AS 
                ( 
                    SELECT 
                        OnTableSchema 
                        ,OnTableName 
                        ,FkNullable 
                        ,AgainstTableSchema 
                        ,AgainstTableName 
                        ,CONCAT(N';', OnTableSchema, N'.',  OnTableName, N';') AS PathName 
                        --,CAST(N';' || OnTableSchema  || N'.' || OnTableName || N';' AS text) AS PathName 
                        --,CAST(';' || OnTableId || ';' AS text) AS Path 
                        ,CONCAT(';', OnTableId, ';' ) AS Path 
                        ,0 AS lvl 
                    FROM CTE_AllTables 
                    WHERE (1=1) 
                    AND AgainstTableName IS NULL 


                    UNION ALL 


                    SELECT 
                        CTE_AllTables.OnTableSchema 
                        ,CTE_AllTables.OnTableName 
                        ,CTE_AllTables.FkNullable 
                        ,CTE_AllTables.AgainstTableSchema 
                        ,CTE_AllTables.AgainstTableName 
                        ,CONCAT(CTE_RecursiveDependencyResolution.PathName, CTE_AllTables.OnTableSchema, N'.', CTE_AllTables.OnTableName, N';') AS PathName 
                        --,CAST(CTE_RecursiveDependencyResolution.PathName || CTE_AllTables.OnTableSchema || N'.' || CTE_AllTables.OnTableName || N';' AS text) AS PathName 
                        --,CAST(CTE_RecursiveDependencyResolution.Path || CTE_AllTables.OnTableId || N';' AS text) AS Path 
                        ,CONCAT(CTE_RecursiveDependencyResolution.Path, CTE_AllTables.OnTableId, N';') AS Path 
                        ,CTE_RecursiveDependencyResolution.Lvl + 1 AS Lvl 
                    FROM CTE_RecursiveDependencyResolution 

                    INNER JOIN CTE_AllTables 
                        ON CTE_AllTables.AgainstTableName = CTE_RecursiveDependencyResolution.OnTableName 
                        AND CTE_AllTables.AgainstTableSchema = CTE_RecursiveDependencyResolution.OnTableSchema 
                        -- NOCYCLE-check - WARNING: Recursion source must not contain same-table foreign-key(s) 
                        AND CTE_RecursiveDependencyResolution.Path NOT LIKE '%;' || CTE_AllTables.OnTableId || ';%' 
                ) 
                -- SELECT * FROM CTE_RecursiveDependencyResolution; 
                -- SELECT * FROM CTE_RecursiveDependencyResolution WHERE AgainstTableName = 'T_FMS_Navigation'; 
                ,final as (
                SELECT
                    MAX(lvl) AS Level 
                    ,OnTableSchema 
                    ,OnTableName 
                    ,MIN(FkNullable) AS FkNullable 
                    
                    -- T-SQL: 
                    --,N'DELETE FROM ' + QUOTENAME(OnTableSchema) + N'.' + QUOTENAME(OnTableName) + N'; ' AS cmdDelete 
                    --,N'TRUNCATE TABLE ' + QUOTENAME(OnTableSchema) + N'.' + QUOTENAME(OnTableName) + N'; ' AS cmdTruncate 
                    --,N'DBCC CHECKIDENT (''' + REPLACE(OnTableSchema, N'''', N'''''') + '.' + REPLACE(OnTableName, N'''', N'''''') + N''', RESEED, 0)' AS cmdReseed 
                    
                    -- plPgSQL: 
                    --,'DELETE FROM ' || QUOTE_IDENT(OnTableSchema) || '.' || QUOTE_IDENT(OnTableName) || ';' || ' ' AS cmdDelete 
                    ,CONCAT(N'DELETE FROM ', QUOTE_IDENT(OnTableSchema), N'.', QUOTE_IDENT(OnTableName), N'; ') AS cmdDelete 
                    
                    -- ,N'TRUNCATE TABLE ' || QUOTE_IDENT(OnTableSchema) || N'.' || QUOTE_IDENT(OnTableName) || N'; ' AS cmdTruncate 
                    ,CONCAT(N'TRUNCATE TABLE ', QUOTE_IDENT(OnTableSchema), N'.', QUOTE_IDENT(OnTableName), N'; ') AS cmdTruncate1 
                FROM CTE_RecursiveDependencyResolution 

                GROUP BY OnTableSchema, OnTableName 

                ORDER BY 
                    Level, 
                    OnTableSchema 
                    ,OnTableName 
                    ,FkNullable
                    
                    
                -- OPTION (MAXRECURSION 0) 
                )
                ,sql as (select row_number() over(order by Level,OnTableSchema,OnTableName,FkNullable desc ) as nr_order, OnTableName as nm_dominio from final
                where OnTableName in ('{"','".join(where)}'))
                select * from sql order by nr_order asc"""
        logger.info(f'association query returned')
        return sql

    ##################################################################################################

    def get_association(self):
        query = text(self.association_generate())
        df = pd.read_sql_query(query, self.engine)
        logger.info(f'association generated')
        return df
    
    ##################################################################################################

    def generate_source_file(self,name =None, schema= None, description = None):
        path = f'''{pathlib.Path(__file__).parent.resolve().parent.resolve()}/dbt_veolia/models/{CLIENTE}/'''
        filename = path+'source.yml'
        with open(f'{filename}','w') as file:
            file.write(f'version: 2'+'\n')
            file.write(f'\n')
            file.write(f'sources:'+'\n')
            file.write(f'  - name: {name}'+'\n')
            file.write(f'    description: {description}'+'\n')
            file.write(f'    database: {self.db}'+'\n')
            file.write(f'    schema: {schema}'+'\n')
            file.write(f'    tables: '+'\n')
            for table in self.get_tables():
                file.write(f'    - name: {table}'+'\n')
                file.write(f'      columns: '+'\n')
                for column in self.get_columns(table=table):
                    file.write(f'''      - name: {column['name']}'''+'\n')
        logger.info(f'source file generated')
    
    ##################################################################################################

    def get_table_index(self,table):
        id_col = None
        for column in self.get_columns(table):
            if str(column['default']).startswith('nextval') and column['autoincrement']:
                id_col={'table': f'''{table}''','id': f'''{column['name']}'''}
            else:
                continue
        return id_col
    
    ##################################################################################################

    def create_fkey_sql(self):
        fetch =[]
        for table in self.get_tables():
            const = f'''SELECT
                        tc.table_schema, 
                        tc.constraint_name, 
                        tc.table_name, 
                        kcu.column_name, 
                        ccu.table_schema AS foreign_table_schema,
                        ccu.table_name AS foreign_table_name,
                        ccu.column_name AS foreign_column_name,
                        tc.constraint_type as constraint_type
                    FROM 
                        information_schema.table_constraints AS tc 
                        JOIN information_schema.key_column_usage AS kcu
                          ON tc.constraint_name = kcu.constraint_name
                          AND tc.table_schema = kcu.table_schema
                        JOIN information_schema.constraint_column_usage AS ccu
                          ON ccu.constraint_name = tc.constraint_name
                          AND ccu.table_schema = tc.table_schema
                    WHERE tc.constraint_type = 'FOREIGN KEY' AND tc.table_name='{table}';'''
            df = pd.read_sql_query(const,self.engine)
            if df.empty:
                continue
            else:
                for index, row in df.iterrows():
                    fk = f'''ALTER TABLE {table} ADD CONSTRAINT {row['constraint_name']} FOREIGN KEY ({row['column_name']}) REFERENCES {row['foreign_table_name']}({row['foreign_column_name']});'''
                    fetch.append(fk)
            # create_sql = ''' '''.join(fetch)
        return fetch

    ##################################################################################################

    def drop_fkey_sql(self):
        fetch =[]
        for table in self.get_tables():
            const = f'''SELECT
                        tc.table_schema, 
                        tc.constraint_name, 
                        tc.table_name, 
                        kcu.column_name, 
                        ccu.table_schema AS foreign_table_schema,
                        ccu.table_name AS foreign_table_name,
                        ccu.column_name AS foreign_column_name,
                        tc.constraint_type as constraint_type
                    FROM 
                        information_schema.table_constraints AS tc 
                        JOIN information_schema.key_column_usage AS kcu
                          ON tc.constraint_name = kcu.constraint_name
                          AND tc.table_schema = kcu.table_schema
                        JOIN information_schema.constraint_column_usage AS ccu
                          ON ccu.constraint_name = tc.constraint_name
                          AND ccu.table_schema = tc.table_schema
                    WHERE tc.constraint_type = 'FOREIGN KEY' AND tc.table_name='{table}';'''
            df = pd.read_sql_query(const,self.engine)
            if df.empty:
                continue
            else:
                for index, row in df.iterrows():
                    fk = f'''ALTER TABLE {row['table_name']} DROP CONSTRAINT {row['constraint_name']};'''
                    fetch.append(fk)
            # drop_sql = ''' '''.join(fetch)
        return fetch
    ##################################################################################################

    def load_csv_to_client(self,path,name,schema):
        df = pd.read_csv(path)
        df_spark = spark.read.csv(path,header=True)

        try:
            df_spark.write.mode("overwrite").format("jdbc") \
            .option("url", f"""jdbc:sqlserver://{self.host}:{self.port};databaseName={self.db};""") \
            .option("user", f"""{self.usr}""") \
            .option("password", f"""{self.pwd}""") \
            .option("fetchsize", "100000") \
            .option("batchsize", "100000") \
            .option("driver", "com.microsoft.sqlserver.jdbc.SQLServerDriver") \
            .option("trustServerCertificate", "true") \
            .option("dbtable", f"{schema}.{name}") \
            .save()
        except Exception as e:
            logger.error(e)
            print('Não foi possível salvar arquivo no banco')

    ##################################################################################################

    def sequence_update(self):
        with self.engine.connect() as conn2:
            # atualizando o sequence da tabela do sansys
            where = self.get_where_association()
            for table in self.get_tables():
                column = self.get_columns(table)[0]
                try:
                    column = self.get_columns(table)[0]
                    if column['default'] is None:
                        continue
                    else:
                        sql = f''' SELECT setval({column['default'].split('(')[1].split('::')[0]}, max({column['name']}), true) from {table}'''
                        conn2.execute(sql)
                except Exception as e:
                    print(e)
                    logger.error(e)
                    print('ocorreu um erro')

    ##################################################################################################

    def inf_tabela_basica_update(self):
        sql = 'select * from inf_tabela_basica'
        df = pd.read_sql_query(sql, self.engine)
        with self.engine.connect() as conn:
            for index, row in df.iterrows():
                update_sttm = f"""update inf_tabela_basica set id_proxima_tabela = (select coalesce(max({row['nm_campo_chave']}),0) + 1 from {row['nm_tabela_banco']}) where nm_tabela_banco = '{row['nm_tabela_banco']}';"""
                try:
                    conn.execute(text(update_sttm))
                except Exception as e:
                    # print(e)
                    logger.error(e)
                    print(
                        f'''row {row['nm_tabela_banco']} from inf_tabela_basica !!!!NOT!!!! updated successfully!''')
                    continue
    
    ##################################################################################################

    def carrega_contacts_papakura(self):
        df = pd.read_csv(f'{pathlib.Path(__file__).parent.resolve().parent.resolve()}/clientes/papakura/contacts.csv')
        df = df.replace('NaN','')
        df = df.fillna('')
        update=[]
        with open('./insert_cad_client.sql','w') as file:
            for index,row in df.iterrows():
                update.append(f'''update cad_cliente set nu_telefone_cliente = '{row['phone']}', nu_telefone_cliente_cel = '{row['mobile']}', email = '{row['email']}' where ch_cliente = {row['account']};''')
        update = ''' '''.join(update)
        with self.engine.connect() as conn:
                conn.execute(text(update))
    
    ##################################################################################################

    
# if __name__ == '__main__':
#     print(pathlib.Path(__file__).parent.resolve().parent.resolve())