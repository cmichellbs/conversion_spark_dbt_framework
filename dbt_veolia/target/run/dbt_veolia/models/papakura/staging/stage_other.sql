
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."stage_other__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."stage_other__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."stage_other__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."stage_other__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."stage_other__dbt_tmp_temp_view" as
    WITH 
OTHER AS (SELECT GBSSTATEMENT, 
SUM(GBSTRAN_AMOUNT) sum_damt
-- 0 sum_damt 

FROM  GBSTATEMENT#TRANS gt 
WHERE GBSTRAN_TRN_TYPE  in (select mig_gbictrn_type_temp from "papakura_20221223"."dbo_mig"."fat_servico_unidade"
where MIG_TARIFA_FIXA_TEMP =''N'' and MIG_GBICTRN_TYPE_TEMP not in (''WSERV'',''MIN'')
)
group by GBSSTATEMENT)

select * from OTHER
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."stage_other__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."stage_other__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."stage_other__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."stage_other__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_stage_other__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_stage_other__dbt_tmp')
    )
  DROP index "dbo_mig"."stage_other__dbt_tmp".dbo_mig_stage_other__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_stage_other__dbt_tmp_cci
    ON "dbo_mig"."stage_other__dbt_tmp"

   

