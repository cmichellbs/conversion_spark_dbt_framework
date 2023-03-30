
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."tab_parametro_localizacao__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."tab_parametro_localizacao__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."tab_parametro_localizacao__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."tab_parametro_localizacao__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."tab_parametro_localizacao__dbt_tmp_temp_view" as
    SELECT
cast(case when substring(seqno,1,3) = ''000'' then 001 
when substring(seqno,1,3) = ''HOL'' then 099 
else substring(seqno,1,3) end as integer) as ID_GRUPO_FATURAMENTO,
ID_LOCALIZACAO as ID_LOCALIZACAO,
3 as CH_TIPO_COLETA_LEITURA
from 
"papakura_20221223"."dbo_mig"."tab_localizacao"
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."tab_parametro_localizacao__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."tab_parametro_localizacao__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."tab_parametro_localizacao__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."tab_parametro_localizacao__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_tab_parametro_localizacao__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_tab_parametro_localizacao__dbt_tmp')
    )
  DROP index "dbo_mig"."tab_parametro_localizacao__dbt_tmp".dbo_mig_tab_parametro_localizacao__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_tab_parametro_localizacao__dbt_tmp_cci
    ON "dbo_mig"."tab_parametro_localizacao__dbt_tmp"

   

