
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."stage_status_fatura__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."stage_status_fatura__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."stage_status_fatura__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."stage_status_fatura__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."stage_status_fatura__dbt_tmp_temp_view" as
    SELECT GBIINVOICE,
(CASE WHEN GBIREV_TYPE IS NULL THEN
   (SELECT CASE
   WHEN SUM(DBAL) = 0 THEN 2
   WHEN SUM(DBAL) > 0 THEN 1
   ELSE 5
   END 
      FROM DEBT WHERE DINVOICEREF = GBINVOICE.gbiinvoice  
      )
      ELSE 3
         END) as status
         FROM GBINVOICE
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."stage_status_fatura__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."stage_status_fatura__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."stage_status_fatura__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."stage_status_fatura__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_stage_status_fatura__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_stage_status_fatura__dbt_tmp')
    )
  DROP index "dbo_mig"."stage_status_fatura__dbt_tmp".dbo_mig_stage_status_fatura__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_stage_status_fatura__dbt_tmp_cci
    ON "dbo_mig"."stage_status_fatura__dbt_tmp"

   

