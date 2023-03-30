
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."stage_faturas__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."stage_faturas__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."stage_faturas__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."stage_faturas__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."stage_faturas__dbt_tmp_temp_view" as
    SELECT *,
cast(concat(year(fat.GBIDATE),concat(''-'',concat(month(fat.GBIDATE),concat(''-'',01)))) as date) as DT_MESANO_REF
FROM "papakura_20221223"."dbo"."GBINVOICE" fat
-- where GBISTATEMENT_NO is not null
-- where GBIINSTALL = 11000123
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."stage_faturas__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."stage_faturas__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."stage_faturas__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."stage_faturas__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_stage_faturas__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_stage_faturas__dbt_tmp')
    )
  DROP index "dbo_mig"."stage_faturas__dbt_tmp".dbo_mig_stage_faturas__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_stage_faturas__dbt_tmp_cci
    ON "dbo_mig"."stage_faturas__dbt_tmp"

   

