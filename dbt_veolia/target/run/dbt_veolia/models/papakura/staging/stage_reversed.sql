
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."stage_reversed__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."stage_reversed__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."stage_reversed__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."stage_reversed__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."stage_reversed__dbt_tmp_temp_view" as
    WITH BASE AS (SELECT GBI.GBIINVOICE,GBI.GBILEDGER , GBI.GBICUR_NO_DAYS, GBI.GBITOT_DOLLAR, GBI.GBIREV_TYPE ,
LAG(GBI.GBITOT_DOLLAR) OVER(PARTITION BY GBI.GBILEDGER ORDER BY GBI.GBIINVOICE DESC) FAT_ANTERIOR,
GBI.GBITOT_DOLLAR + LAG(GBI.GBITOT_DOLLAR) OVER(PARTITION BY GBI.GBILEDGER ORDER BY GBI.GBIINVOICE DESC) AS DIF_FATURAS,
CASE 
	WHEN (GBI.GBICUR_NO_DAYS + LAG(GBI.GBICUR_NO_DAYS) OVER(PARTITION BY GBI.GBILEDGER ORDER BY GBI.GBIINVOICE DESC)) = 0 or (GBI.GBITOT_DOLLAR + LAG(GBI.GBITOT_DOLLAR) OVER(PARTITION BY GBI.GBILEDGER ORDER BY GBI.GBIINVOICE DESC)) IN (0,1) OR GBI.GBITOT_DOLLAR < 0THEN 
1 	ELSE 0 END AS REVERSED,
CASE WHEN (GBI.GBICUR_NO_DAYS + LAG(GBI.GBICUR_NO_DAYS) OVER(PARTITION BY GBI.GBILEDGER ORDER BY GBI.GBIINVOICE DESC)) = 0 or (GBI.GBITOT_DOLLAR + LAG(GBI.GBITOT_DOLLAR) OVER(PARTITION BY GBI.GBILEDGER ORDER BY GBI.GBIINVOICE DESC)) = 0  THEN 
GBI.GBITOT_DOLLAR 
WHEN  GBI.GBITOT_DOLLAR < 0 THEN GBITOT_DOLLAR * -1
ELSE GBI.GBITOT_DOLLAR END AS GBITOT_DOLLAR_ADJ
FROM GBINVOICE GBI
--WHERE GBILEDGER IN (100009107)
)

SELECT * FROM BASE 
WHERE REVERSED = 1
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."stage_reversed__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."stage_reversed__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."stage_reversed__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."stage_reversed__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_stage_reversed__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_stage_reversed__dbt_tmp')
    )
  DROP index "dbo_mig"."stage_reversed__dbt_tmp".dbo_mig_stage_reversed__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_stage_reversed__dbt_tmp_cci
    ON "dbo_mig"."stage_reversed__dbt_tmp"

   

