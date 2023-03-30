
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."stage_situacao_fatura__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."stage_situacao_fatura__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."stage_situacao_fatura__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."stage_situacao_fatura__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."stage_situacao_fatura__dbt_tmp_temp_view" as
    with 


BASE AS (
select b.* from "papakura_20221223"."dbo_mig"."stage_final_neg_fat" b
)

,SITUACAO AS (SELECT *, 


CASE 
    WHEN REVERSED =1 or cancelado =1 THEN 3 
    when  STATUS_PAGO =1 and REVERSED <> 1 and  cancelado <>1  THEN 2
    ELSE 1 END AS CH_SITUACAO_FATURA


FROM BASE)

select * from SITUACAO
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."stage_situacao_fatura__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."stage_situacao_fatura__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."stage_situacao_fatura__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."stage_situacao_fatura__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_stage_situacao_fatura__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_stage_situacao_fatura__dbt_tmp')
    )
  DROP index "dbo_mig"."stage_situacao_fatura__dbt_tmp".dbo_mig_stage_situacao_fatura__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_stage_situacao_fatura__dbt_tmp_cci
    ON "dbo_mig"."stage_situacao_fatura__dbt_tmp"

   

