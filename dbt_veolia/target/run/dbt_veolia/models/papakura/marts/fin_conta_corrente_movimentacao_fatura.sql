
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."fin_conta_corrente_movimentacao_fatura__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."fin_conta_corrente_movimentacao_fatura__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."fin_conta_corrente_movimentacao_fatura__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."fin_conta_corrente_movimentacao_fatura__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."fin_conta_corrente_movimentacao_fatura__dbt_tmp_temp_view" as
    SELECT
ROW_NUMBER() OVER(ORDER BY FF.ID_FATURA ) as ID_CONTA_CORRENTE_MOVIMENTACAO_FATURA,
FCCM.ID_CONTA_CORRENTE_MOVIMENTACAO as ID_CONTA_CORRENTE_MOVIMENTACAO,
FF.ID_FATURA as ID_FATURA



FROM "papakura_20221223"."dbo_mig"."stage_fin_conta_corrente_movimentacao_adj" FCCM

inner JOIN "papakura_20221223"."dbo_mig"."fat_fatura" FF ON FF.NR_FATURA = FCCM.INVOICE
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."fin_conta_corrente_movimentacao_fatura__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."fin_conta_corrente_movimentacao_fatura__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."fin_conta_corrente_movimentacao_fatura__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."fin_conta_corrente_movimentacao_fatura__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_fin_conta_corrente_movimentacao_fatura__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_fin_conta_corrente_movimentacao_fatura__dbt_tmp')
    )
  DROP index "dbo_mig"."fin_conta_corrente_movimentacao_fatura__dbt_tmp".dbo_mig_fin_conta_corrente_movimentacao_fatura__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_fin_conta_corrente_movimentacao_fatura__dbt_tmp_cci
    ON "dbo_mig"."fin_conta_corrente_movimentacao_fatura__dbt_tmp"

   

