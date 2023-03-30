
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."stage_fatura_componente__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."stage_fatura_componente__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."stage_fatura_componente__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."stage_fatura_componente__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."stage_fatura_componente__dbt_tmp_temp_view" as
    with componentes as (SELECT
COD_FATURA,
SUM(CAST(VL_AGUA_CPTE_FATURA AS DECIMAL(16,2))) as VL_AGUA_CPTE_FATURA,
SUM(CAST(VL_ESGOTO_CPTE_FATURA AS DECIMAL(16,2))) as VL_ESGOTO_CPTE_FATURA,
SUM(CAST(VL_CONSUMO_CPTE_FATURA AS integer)) as VL_CONSUMO_CPTE_FATURA,
SUM(CAST(VL_CONSUMO_ESGOTO_CPTE_FATURA AS integer)) as VL_CONSUMO_ESGOTO_CPTE_FATURA
FROM "papakura_20221223"."dbo_mig"."stage_fat_fatura_componente2" ffc 
GROUP BY COD_FATURA)

select * from componentes
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."stage_fatura_componente__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."stage_fatura_componente__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."stage_fatura_componente__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."stage_fatura_componente__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_stage_fatura_componente__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_stage_fatura_componente__dbt_tmp')
    )
  DROP index "dbo_mig"."stage_fatura_componente__dbt_tmp".dbo_mig_stage_fatura_componente__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_stage_fatura_componente__dbt_tmp_cci
    ON "dbo_mig"."stage_fatura_componente__dbt_tmp"

   

