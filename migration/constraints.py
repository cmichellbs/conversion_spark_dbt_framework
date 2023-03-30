from .conn import sansys


# Contraints creation 
constraints_add_list = sansys.create_fkey_sql()
# Constraints drop
constraints_drop_list = sansys.drop_fkey_sql()