
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."CUSTOMER_ACCOUNT__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."CUSTOMER_ACCOUNT__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."CUSTOMER_ACCOUNT__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."CUSTOMER_ACCOUNT__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."CUSTOMER_ACCOUNT__dbt_tmp_temp_view" as
    WITH INTERM AS (SELECT C.*, ROW_NUMBER() OVER(PARTITION BY C.CINSTALL ORDER BY CONSUMERNO DESC)  AS RN FROM "papakura_20221223"."dbo"."CONSUMER" C

WHERE CSTATUSTYPE <> 30)

,FINAL AS(select *,1 AS RN from "papakura_20221223"."dbo"."CONSUMER" WHERE CSTATUSTYPE = 30
UNION

SELECT * FROM INTERM WHERE RN =1 )

SELECT F.CACCT, F.CINSTALL, F.CONSUMERNO  FROM FINAL F
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."CUSTOMER_ACCOUNT__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."CUSTOMER_ACCOUNT__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."CUSTOMER_ACCOUNT__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."CUSTOMER_ACCOUNT__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_CUSTOMER_ACCOUNT__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_CUSTOMER_ACCOUNT__dbt_tmp')
    )
  DROP index "dbo_mig"."CUSTOMER_ACCOUNT__dbt_tmp".dbo_mig_CUSTOMER_ACCOUNT__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_CUSTOMER_ACCOUNT__dbt_tmp_cci
    ON "dbo_mig"."CUSTOMER_ACCOUNT__dbt_tmp"

   

