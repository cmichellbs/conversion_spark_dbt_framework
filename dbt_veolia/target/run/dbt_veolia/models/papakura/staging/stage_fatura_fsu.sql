
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."stage_fatura_fsu__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."stage_fatura_fsu__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."stage_fatura_fsu__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."stage_fatura_fsu__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."stage_fatura_fsu__dbt_tmp_temp_view" as
    with FSU AS(SELECT FSU.MIG_ID_FATURA_TEMP, SUM(FSU.VL_TOTAL_SERVICO) AS VL_TOTAL_SERVICO  FROM "papakura_20221223"."dbo_mig"."fat_servico_unidade" FSU
GROUP BY FSU.MIG_ID_FATURA_TEMP)


SELECT * FROM FSU
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."stage_fatura_fsu__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."stage_fatura_fsu__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."stage_fatura_fsu__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."stage_fatura_fsu__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_stage_fatura_fsu__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_stage_fatura_fsu__dbt_tmp')
    )
  DROP index "dbo_mig"."stage_fatura_fsu__dbt_tmp".dbo_mig_stage_fatura_fsu__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_stage_fatura_fsu__dbt_tmp_cci
    ON "dbo_mig"."stage_fatura_fsu__dbt_tmp"

   

