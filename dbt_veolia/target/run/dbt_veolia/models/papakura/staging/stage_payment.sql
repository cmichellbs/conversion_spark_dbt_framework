
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."stage_payment__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."stage_payment__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."stage_payment__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."stage_payment__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."stage_payment__dbt_tmp_temp_view" as
    with PAYMENT_ADJ AS (SELECT fcc.id_conta_corrente, fccm.VL_SALDO_ATUAL, row_number() over(partition by fcc.id_conta_corrente order by NR_SEQUENCIAL_REGISTRO desc) RN FROM "papakura_20221223"."dbo_mig"."fin_conta_corrente_movimentacao" fccm
inner join "papakura_20221223"."dbo_mig"."fin_conta_corrente" fcc on fcc.id_conta_corrente = fccm.id_conta_corrente  )

,PAYMENT AS (SELECT * FROM PAYMENT_ADJ WHERE RN = 1)

select * from PAYMENT
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."stage_payment__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."stage_payment__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."stage_payment__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."stage_payment__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_stage_payment__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_stage_payment__dbt_tmp')
    )
  DROP index "dbo_mig"."stage_payment__dbt_tmp".dbo_mig_stage_payment__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_stage_payment__dbt_tmp_cci
    ON "dbo_mig"."stage_payment__dbt_tmp"

   

