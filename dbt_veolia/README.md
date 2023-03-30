## Powered by

[![DBT](https://www.getdbt.com/ui/img/logos/dbt-logo.svg)](https://docs.getdbt.com/dbt-cli/cli-overview) [![PYTHON](https://www.python.org/static/img/python-logo.png)](https://www.python.org/doc/)
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

Welcome to your new dbt project!

### Using the starter project

Try running the following commands:
- dbt run
- dbt test
- dbt docs generate
- dbt docs serve --port 8002

### TUDO EM 'MARTS' SERÁ MIGRADO. CASO UMA TABELA NÃO INTENDA SER MIGRADA, DEVE PERMANCER EM 'STAGING'.

### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](https://community.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
