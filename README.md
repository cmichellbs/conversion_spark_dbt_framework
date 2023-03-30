# MIGRATION SERVICE
&nbsp;
###### Suite de produtividade para conversão de banco de dados
&nbsp;
&nbsp;
## Powered by

[![DBT](https://www.getdbt.com/ui/img/logos/dbt-logo.svg)](https://docs.getdbt.com/dbt-cli/cli-overview) [![PYTHON](https://www.python.org/static/img/python-logo.png)](https://www.python.org/doc/)
&nbsp;
[![Build Status](https://github.com/dbt-labs/dbt-core/actions/workflows/main.yml/badge.svg?event=push)](https://github.com/dbt-labs/dbt-core/actions/workflows/main.yml)

##### Este projeto foi idealizado na utilização de plain sql scripts para a conversão de dados para o sansys
&nbsp;
&nbsp;
&nbsp;
&nbsp;

## Dependencies
&nbsp;
&nbsp;
| Project | README |
| ------ | ------ |
| dbt-veolia | https://gitlab.com/veolia.com/brasil/jtech/data-science/dbt_veolia/-/blob/main/README.md |

-
## Features

- Conversão de banco de dados
- Hot updates
- Database utils

&nbsp;
&nbsp;
&nbsp;
&nbsp;
&nbsp;

___

## Before start
&nbsp;
###### É recomendaddo que faça o curso/tutorial em:
&nbsp;
[![DBT-COURSES](https://import.cdn.thinkific.com/342803/courses/1539942/epg1Qi2USSiXGS6JZJkG_dbt%20Fundamentals.png)](https://courses.getdbt.com/collections)
&nbsp;

###### https://courses.getdbt.com/collections

&nbsp;
&nbsp;
___


## Installation

This project require [Python](https://www.python.org/doc/) v3.6+ to run.

**Clonning the repository and installing dependencies:**

```sh
$ cd path-to-project-folder

$ git clone --recurse-submodules --branch develop https://gitlab.com/veolia.com/brasil/jtech/data-science/migration.git

$ cd migration

$ pip install -r requirements.txt
```

Config dbt-env

**Export the enviroment variables:**

###### *For the current user*
&nbsp;
```sh
$ echo '''export DBT_PROFILES_DIR='/{path-to-project}/migration/.dbt'''' >> ~/.bashrc
```
OR

###### *For the current run*
&nbsp;

```sh
$ export DBT_PROFILES_DIR='/{path-to-project}/migration/.dbt'
```
&nbsp;
**Setup profiles.yml:**

```sh
$ cd /{path-to-project}/migration/.dbt
$ nano profiles.yml
```
**Edit the profiles.yml file as shown on:** [DBT Profiles](https://docs.getdbt.com/reference/warehouse-setups/postgres-setup)

**EM CASO DE DÚVIDAS OU DIFICULDADES AO CONFIGURAR:** [DBT Profiles setup](https://docs.getdbt.com/docs/get-started/connection-profiles)
&nbsp;
&nbsp;
##### **Setup dbt-project.yml**

**Go to dbt-veolia folder and open dbt-project.yml:**
&nbsp;
```sh
$ cd dbt-veolia/
$ nano dbt-project.yml
```

At the models section of the file, configure as follow:
```yaml
models:
  dbt_veolia:
    # Config indicated by + and applies to all files under models/example/
    {nameOfCliente}: <----- here you must be as simple as possible, like "riobranco","papakura"
        +schema: mig
        +tags: migration
        marts:        
            +materialized: table
        staging:
            +materialized: table
```
&nbsp;
&nbsp;
**Now create the folders that were setup on the file above, like:**
&nbsp;
```sh
$ cd dbt-veolia/models/
$ mkdir {nameOfCliente}
$ cd {nameOfCliente}/
$ mkdir marts
$ mkdir staging
```

&nbsp;
&nbsp;
##### **Create a .env file at migration root folder ({path-to-folder}/migration/):**
&nbsp;
**For the sansys connection:**
&nbsp;
```.env
###parametros projeto###
CLIENTE = {nameOfCliente}

###conexão destino (SANSYS)###
PGHOST = "0.0.0.0" #SANSYS HOST
PGDB = "sansys_{nameOfCliente}" #SANSYS DATABASE name
PGUSR = "postgres" #SANSYS USER
PGPWD = "postgres" #SANSYS PASSWORD
PGPORT= "5432" #SANSYS PORT
PGCONTEXT = "postgresql+psycopg2" #example #this remains same
```
&nbsp;
&nbsp;
**For the client/origin connection:**
&nbsp;
```.env
###conexão com banco de origem###
MSHOST = "0.0.0.0"                      #Client/origin HOST
MSDB = "database"                  #Client/origin DB
MSUSR = "user"                                #Client/origin USER
MSPWD = "pwd"  #Client/origin PASSWORD
MSPORT= "1434"                              #Client/origin PORT
MSCONTEXT = "mssql+pyodbc" #example                  #Client/origin CONTEXT("mssql+pyodbc" PARA SQL SERVER, "postgresql+psycopg2" PARA POSTGRES,"mysql+pymysql" PARA MYSQL)
MSQUERY={"driver": os.getenv('MSDRIVER')}   #Client/origin CONECTION QUERY (IF REQUIRES A DRIVER)
MSDRIVER = "ODBC Driver 17 for SQL Server"  #Client/origin HOST
```
&nbsp;
**PARA ODBC DRIVER MS SQL SERVER:**
https://learn.microsoft.com/en-us/sql/connect/odbc/linux-mac/installing-the-microsoft-odbc-driver-for-sql-server?view=sql-server-ver16
&nbsp;
&nbsp;
&nbsp;
&nbsp;
&nbsp;
&nbsp;
&nbsp;
___



## Running the service
&nbsp;

After creating your .sql files to build the model (**SEE "BEFORE START" SECTION**)

**Building the model:**

```sh
$ cd path-to-project-folder/migration/dbt-veolia

$ dbt-run
```
**Run the service:**
```sh
$ cd path-to-project-folder/migration/

$ python3 service.py
```

&nbsp;
&nbsp;
&nbsp;
&nbsp;
&nbsp;
&nbsp;
&nbsp;
