
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."stage_fatura_consumohist__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."stage_fatura_consumohist__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."stage_fatura_consumohist__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."stage_fatura_consumohist__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."stage_fatura_consumohist__dbt_tmp_temp_view" as
    with CONSUMO_INTERM as (select GBIR.GBIINVOICE,
CASE WHEN GBIR.GBIMCURR_TYPE IS NULL THEN ''AB'' ELSE GBIR.GBIMCURR_TYPE END  as GBIMCURR_TYPE_ADJ,
ROW_NUMBER() OVER(PARTITION BY GBIR.GBIINVOICE ORDER BY VMC DESC)  AS RN from GBINVOICE#REGISTERS GBIR)

,CONSUMO_HIST AS (SELECT GBIINVOICE, GBIMCURR_TYPE_ADJ FROM CONSUMO_INTERM WHERE RN=1)

select * FROM CONSUMO_HIST
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."stage_fatura_consumohist__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."stage_fatura_consumohist__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."stage_fatura_consumohist__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."stage_fatura_consumohist__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_stage_fatura_consumohist__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_stage_fatura_consumohist__dbt_tmp')
    )
  DROP index "dbo_mig"."stage_fatura_consumohist__dbt_tmp".dbo_mig_stage_fatura_consumohist__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_stage_fatura_consumohist__dbt_tmp_cci
    ON "dbo_mig"."stage_fatura_consumohist__dbt_tmp"

   

