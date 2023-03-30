import pandas as pd
from migration.databases import Database


class Table(Database):
    # @lru_cache
    def __init__(self,schema,table):
        self.schema= schema
        self.table= table
        self.columns = self.get_columns(table,schema)

    def data(self,schema, table):
        df = pd.read_sql_table(table,self.engine,schema,index = None)
        return df

        