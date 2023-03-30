
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."tab_agencia__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."tab_agencia__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."tab_agencia__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."tab_agencia__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."tab_agencia__dbt_tmp_temp_view" as
    SELECT
row_number() over(order by BSBID) + 10 as ID_AGENCIA,
coalesce(BSBBRANCH, ''STRING'') as NM_AGENCIA,
RIGHT(CAST(BSBID  AS VARCHAR),4) as CD_AGENCIA,
coalesce(taa.ID_AGENTE_ARRECADADOR, 0) as ID_AGENTE_ARRECADADOR,
1 as CH_ATIVO,
CAST(BSBID  AS VARCHAR) as MIG_CD_AGENCIA_TEMP
FROM
"papakura_20221223"."dbo"."EMS_BSB" ta

LEFT JOIN "papakura_20221223"."dbo_mig"."tab_agente_arrecadador" taa on taa.COD_BANCO = CAST(SUBSTRING(ta.BSBID,1,2)  AS VARCHAR)
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."tab_agencia__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."tab_agencia__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."tab_agencia__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."tab_agencia__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_tab_agencia__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_tab_agencia__dbt_tmp')
    )
  DROP index "dbo_mig"."tab_agencia__dbt_tmp".dbo_mig_tab_agencia__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_tab_agencia__dbt_tmp_cci
    ON "dbo_mig"."tab_agencia__dbt_tmp"

   

