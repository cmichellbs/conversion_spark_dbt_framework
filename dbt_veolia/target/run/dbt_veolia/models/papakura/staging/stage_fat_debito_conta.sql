
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."stage_fat_debito_conta__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."stage_fat_debito_conta__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."stage_fat_debito_conta__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."stage_fat_debito_conta__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."stage_fat_debito_conta__dbt_tmp_temp_view" as
    WITH BASE AS (SELECT LEDGERPAY.LP$KEY, VALUE AS INFO ,ROW_NUMBER() OVER(PARTITION BY LEDGERPAY.LP$KEY ORDER BY LEDGERPAY.LP$KEY) AS RN FROM LEDGERPAY  LEDGERPAY CROSS APPLY STRING_SPLIT(LEDGERPAY.LP$BANK,''-'') WHERE LP$BANK IS NOT NULL)


select * from base
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."stage_fat_debito_conta__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."stage_fat_debito_conta__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."stage_fat_debito_conta__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."stage_fat_debito_conta__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_stage_fat_debito_conta__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_stage_fat_debito_conta__dbt_tmp')
    )
  DROP index "dbo_mig"."stage_fat_debito_conta__dbt_tmp".dbo_mig_stage_fat_debito_conta__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_stage_fat_debito_conta__dbt_tmp_cci
    ON "dbo_mig"."stage_fat_debito_conta__dbt_tmp"

   

