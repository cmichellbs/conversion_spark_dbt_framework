import time
from migration.migration import batch_migrate,init_migration
from migration.logger import *
from migration.project import *
from migration.conn import sansys,cliente

start_time = time.time()

if __name__ == '__main__':
    projeto = CLIENTE
    root_client_folder = './clientes/'+projeto
    schema = str(MSSCHEMA)+'_mig'
    
    batch_migrate(origin_schema=schema,
    preimportloc = f'{root_client_folder}/preimport.sql',
    posimportloc = f'{root_client_folder}/posimport.sql',    
    runner = 'spark')
    
    sansys.carrega_contacts_papakura()
   
    ##single table migration
    # init_migration('dbo_mig','tab_tarifa_servico_definicao',runner='pandas')
    
    ## update sequences:##
    # sansys.sequence_update()

    ## update inf_tabela_basica:##
    # inf_tabela_basica_update()

    print(f"""--- {((time.time() - start_time)/60)} minutes elapsed ---""")
    logger.info(f"""--- {((time.time() - start_time)/60)} minutes elapsed ---""")