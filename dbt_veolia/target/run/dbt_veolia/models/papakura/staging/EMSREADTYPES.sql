
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."EMSREADTYPES__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."EMSREADTYPES__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."EMSREADTYPES__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."EMSREADTYPES__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."EMSREADTYPES__dbt_tmp_temp_view" as
    SELECT
row_number() over(order by RT$CODE) as CH_TIPO_LEITURA,
cast(RT$DESCRIPTION as varchar) as NM_TIPO_LEITURA,
1 as CH_ATIVO,
RT$CODE as CD_TIPO_LEITURA

from "papakura_20221223"."dbo"."EMSREADTYPES"
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."EMSREADTYPES__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."EMSREADTYPES__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."EMSREADTYPES__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."EMSREADTYPES__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_EMSREADTYPES__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_EMSREADTYPES__dbt_tmp')
    )
  DROP index "dbo_mig"."EMSREADTYPES__dbt_tmp".dbo_mig_EMSREADTYPES__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_EMSREADTYPES__dbt_tmp_cci
    ON "dbo_mig"."EMSREADTYPES__dbt_tmp"

   

