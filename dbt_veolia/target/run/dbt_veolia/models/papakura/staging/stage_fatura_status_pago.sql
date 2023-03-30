
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."stage_fatura_status_pago__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."stage_fatura_status_pago__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."stage_fatura_status_pago__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."stage_fatura_status_pago__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."stage_fatura_status_pago__dbt_tmp_temp_view" as
    select DINVOICEREF AS GBIINVOICE,
sum(cast(DAMT as decimal(16,2)))/ 100 as DAMT,
sum(cast(DPAID as decimal(16,2)))/100 as DPAID, 
sum(cast(DBAL as decimal(16,2)))/100 as DBAL , 
case when ((sum(cast(DAMT as decimal(16,2)))/ 100)- (sum(cast(DPAID as decimal(16,2)))/ 100)) > 0 then 0 else 1 end as STATUS_PAGO
from DEBT d 
where DINVOICEREF is not NULL 
and left(DREF,3) <> ''Rev'' and left(DREF,3) <> ''REV'' and left(DREF,3) <> ''rev''
group by DINVOICEREF
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."stage_fatura_status_pago__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."stage_fatura_status_pago__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."stage_fatura_status_pago__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."stage_fatura_status_pago__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_stage_fatura_status_pago__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_stage_fatura_status_pago__dbt_tmp')
    )
  DROP index "dbo_mig"."stage_fatura_status_pago__dbt_tmp".dbo_mig_stage_fatura_status_pago__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_stage_fatura_status_pago__dbt_tmp_cci
    ON "dbo_mig"."stage_fatura_status_pago__dbt_tmp"

   

