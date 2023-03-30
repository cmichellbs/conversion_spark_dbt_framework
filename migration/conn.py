import os
from .databases import Database
import os
from .utils import cliente_eval
from .project import *
import pathlib

# instanciar conexão com o sansys
sansys = Database(host=PGHOST, db=PGDB, usr=PGUSR, pwd=PGPWD, port=PGPORT, context=PGCONTEXT)

# instanciar conexão com o banco de origem do cliente
cliente = cliente_eval()


# if __name__ == '__main__':
    # sansys.sequence_update()
    # path = f'''{pathlib.Path(__file__).parent.resolve().parent.resolve()}'''
    # cliente.load_csv_to_client(f'''{path}/nz_full_address.csv''','nz_full_address','dbo')
    # cliente.load_csv_to_client(f'''{path}/locaddress_match.csv''','locaddress_match','dbo')
    # cliente.load_csv_to_client(f'''{path}/loc_best_match.csv''','loc_best_match','dbo')
    # cliente.generate_source_file()
    # print(path)
    