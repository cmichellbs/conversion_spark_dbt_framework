
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."stage_base_status_pago__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."stage_base_status_pago__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."stage_base_status_pago__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."stage_base_status_pago__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."stage_base_status_pago__dbt_tmp_temp_view" as
    with BASE_STTM AS (
 select d.DSTATEMENT AS FATURA, sum(DAMT) as DAMT , sum(DPAID) as DPAID,SUM(DBAL) AS DBAL , SUM(DSTATUS)/(3*COUNT(DKEY)) AS PT from "papakura_20221223"."dbo"."DEBT" d 
where d.DSTATEMENT IS NOT NULL
GROUP BY DSTATEMENT 
)

, BASE_INV AS ( select d.DINVOICEREF AS FATURA, sum(DAMT) as DAMT , sum(DPAID) as DPAID,SUM(DBAL) AS DBAL, SUM(DSTATUS)/(3*COUNT(DKEY)) AS PT from "papakura_20221223"."dbo"."DEBT" d 
where DINVOICEREF is not null and DSTATEMENT is null and left(DREF,3) <> ''Rev'' and left(DREF,3) <> ''REV'' and left(DREF,3) <> ''rev''
GROUP BY DINVOICEREF)

,STATUS_PAGO AS (
SELECT * FROM BASE_STTM

UNION ALL

SELECT * FROM BASE_INV
)

select * from STATUS_PAGO
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."stage_base_status_pago__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."stage_base_status_pago__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."stage_base_status_pago__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."stage_base_status_pago__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_stage_base_status_pago__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_stage_base_status_pago__dbt_tmp')
    )
  DROP index "dbo_mig"."stage_base_status_pago__dbt_tmp".dbo_mig_stage_base_status_pago__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_stage_base_status_pago__dbt_tmp_cci
    ON "dbo_mig"."stage_base_status_pago__dbt_tmp"

   

