
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."stage_ap__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."stage_ap__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."stage_ap__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."stage_ap__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."stage_ap__dbt_tmp_temp_view" as
    SELECT AP.MIG_STATEMENT_TEMP_ADJ,
       MAX(AP.ID_PAGAMENTO) ID_PAGAMENTO,
       SUM(AP.VL_DOCUMENTO_ARRECADACAO) VL_DOCUMENTO_ARRECADACAO
FROM "papakura_20221223"."dbo_mig"."arr_pagamento" AP
GROUP BY AP.MIG_STATEMENT_TEMP_ADJ
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."stage_ap__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."stage_ap__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."stage_ap__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."stage_ap__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_stage_ap__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_stage_ap__dbt_tmp')
    )
  DROP index "dbo_mig"."stage_ap__dbt_tmp".dbo_mig_stage_ap__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_stage_ap__dbt_tmp_cci
    ON "dbo_mig"."stage_ap__dbt_tmp"

   

