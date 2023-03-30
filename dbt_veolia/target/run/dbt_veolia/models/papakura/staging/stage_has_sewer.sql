
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."stage_has_sewer__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."stage_has_sewer__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."stage_has_sewer__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."stage_has_sewer__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."stage_has_sewer__dbt_tmp_temp_view" as
    --select * from EMS_CON_PLAN
WITH BASE AS (

SELECT ECPLAN_KEY,ECPLAN_FCHGCODE AS TARC$CODE FROM EMS_CON_PLAN#FIXED_LIST

UNION

SELECT ECPLAN_KEY,ECPLAN_TARCODE FROM EMS_CON_PLAN#REGISTER_LIST

UNION

SELECT ECPLAN_KEY, CASE WHEN ECPLAN_KEY = ''UWA'' THEN ''NO_TARC_CODE'' ELSE ECPLAN_KEY END AS TARC$CODE
FROM EMS_CON_PLAN ecp 
)
,BASE2 AS (
SELECT BASE.*, TC.TARC$INV$HEAD$GRP AS WS FROM BASE
LEFT JOIN TARCHARGE TC ON TC.TARC$CODE = BASE.TARC$CODE

UNION

SELECT BASE.*, CASE WHEN ECPLAN_KEY = ''UWA'' THEN ''DO_NOT_USE'' ELSE TC.TARC$INV$HEAD$GRP END AS WS FROM BASE
LEFT JOIN TARCHARGE TC ON TC.TARC$TEMPLATE = BASE.TARC$CODE
)
,FINAL AS (
SELECT BASE2.ECPLAN_KEY, MAX(CASE WHEN WS = ''SEWER'' THEN 1 ELSE 0 END) AS HAS_SEWER, MAX(CASE WHEN  WS = ''SEWER'' AND ((TARC$CODE <> ''STREA0'' AND TARC$CODE LIKE ''%STREA%'') OR TARC$CODE = ''SVOL'')  THEN 1 ELSE 0 END) AS HAS_SEWER_TREATED  FROM BASE2
WHERE WS IS NOT NULL
GROUP BY ECPLAN_KEY
)

SELECT *FROM FINAL 
--BASE2
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."stage_has_sewer__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."stage_has_sewer__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."stage_has_sewer__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."stage_has_sewer__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_stage_has_sewer__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_stage_has_sewer__dbt_tmp')
    )
  DROP index "dbo_mig"."stage_has_sewer__dbt_tmp".dbo_mig_stage_has_sewer__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_stage_has_sewer__dbt_tmp_cci
    ON "dbo_mig"."stage_has_sewer__dbt_tmp"

   

