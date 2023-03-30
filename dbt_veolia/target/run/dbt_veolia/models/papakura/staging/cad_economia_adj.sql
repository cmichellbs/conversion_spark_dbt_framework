
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."cad_economia_adj__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."cad_economia_adj__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."cad_economia_adj__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."cad_economia_adj__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."cad_economia_adj__dbt_tmp_temp_view" as
    with INTERM as (select ce.*, row_number() over(partition by ce.CH_MATRICULA_UNIDADE order by ce.SEQ DESC ) AS RN from "papakura_20221223"."dbo_mig"."cad_economia" ce)

SELECT * FROM INTERM WHERE RN = 1
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."cad_economia_adj__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."cad_economia_adj__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."cad_economia_adj__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."cad_economia_adj__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_cad_economia_adj__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_cad_economia_adj__dbt_tmp')
    )
  DROP index "dbo_mig"."cad_economia_adj__dbt_tmp".dbo_mig_cad_economia_adj__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_cad_economia_adj__dbt_tmp_cci
    ON "dbo_mig"."cad_economia_adj__dbt_tmp"

   

