
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."fat_contrato__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."fat_contrato__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."fat_contrato__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."fat_contrato__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."fat_contrato__dbt_tmp_temp_view" as
    WITH CONTRATO AS (SELECT * FROM TARCHARGE
WHERE TARC$CODE IN(select DISTINCT ECPfL.ECPLAN_FCHGCODE from EMS_CON_PLAN#FIXED_LIST ECPFL
))

SELECT
ROW_NUMBER() OVER(ORDER BY TARC$CODE) +100 as ID_CONTRATO,
TARC$DESC as DS_CONTRATO,
CASE 
    WHEN TARC$TEMPLATE = ''IC''
 THEN 3 else 2
END as CH_TIPO_PRESTACAO_SERVICO,
TARC$CODE as CODE,
TARC$CODE AS MIG_PK_TEMP
FROM
CONTRATO
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."fat_contrato__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."fat_contrato__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."fat_contrato__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."fat_contrato__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_fat_contrato__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_fat_contrato__dbt_tmp')
    )
  DROP index "dbo_mig"."fat_contrato__dbt_tmp".dbo_mig_fat_contrato__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_fat_contrato__dbt_tmp_cci
    ON "dbo_mig"."fat_contrato__dbt_tmp"

   

