
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."EMS_CON_CONTRACT__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."EMS_CON_CONTRACT__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."EMS_CON_CONTRACT__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."EMS_CON_CONTRACT__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."EMS_CON_CONTRACT__dbt_tmp_temp_view" as
    WITH INTERM AS (SELECT ECC.*,ROW_NUMBER() OVER(PARTITION BY CCON_CONSUMER ORDER BY CCON_SEQ DESC) AS RN FROM "papakura_20221223"."dbo"."EMS_CON_CONTRACT" ECC)

SELECT * FROM INTERM
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."EMS_CON_CONTRACT__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."EMS_CON_CONTRACT__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."EMS_CON_CONTRACT__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."EMS_CON_CONTRACT__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_EMS_CON_CONTRACT__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_EMS_CON_CONTRACT__dbt_tmp')
    )
  DROP index "dbo_mig"."EMS_CON_CONTRACT__dbt_tmp".dbo_mig_EMS_CON_CONTRACT__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_EMS_CON_CONTRACT__dbt_tmp_cci
    ON "dbo_mig"."EMS_CON_CONTRACT__dbt_tmp"

   

