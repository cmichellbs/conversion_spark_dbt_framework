
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."tab_agente_arrecadador__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."tab_agente_arrecadador__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."tab_agente_arrecadador__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."tab_agente_arrecadador__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."tab_agente_arrecadador__dbt_tmp_temp_view" as
    SELECT
ROW_NUMBER() OVER(ORDER BY BANKNO) +20 as ID_AGENTE_ARRECADADOR,
RIGHT(''000''+CAST(BANKNO AS VARCHAR),2) as CD_AGENTE_ARRECADADOR,
CONCAT(RIGHT(''000''+CAST(BANKNO AS VARCHAR),2),'' - '',coalesce(BSBBLONG, ''BANK_WITHOUT_NAME'')) as NM_AGENTE_ARRECADADOR,
1 as CH_ATIVO,
2 as CH_TIPO_AGENTE_ARRECADADOR,
''STRING'' as NU_CNPJ,
BSBBSHORT as abrev,
RIGHT(''000''+CAST(BANKNO AS VARCHAR),2) as COD_BANCO
FROM

"papakura_20221223"."dbo"."BSBBANKS"
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."tab_agente_arrecadador__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."tab_agente_arrecadador__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."tab_agente_arrecadador__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."tab_agente_arrecadador__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_tab_agente_arrecadador__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_tab_agente_arrecadador__dbt_tmp')
    )
  DROP index "dbo_mig"."tab_agente_arrecadador__dbt_tmp".dbo_mig_tab_agente_arrecadador__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_tab_agente_arrecadador__dbt_tmp_cci
    ON "dbo_mig"."tab_agente_arrecadador__dbt_tmp"

   

