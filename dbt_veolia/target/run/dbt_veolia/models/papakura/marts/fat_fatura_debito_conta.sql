
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."fat_fatura_debito_conta__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."fat_fatura_debito_conta__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."fat_fatura_debito_conta__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."fat_fatura_debito_conta__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."fat_fatura_debito_conta__dbt_tmp_temp_view" as
    SELECT
row_number() over(order by FF.ID_FATURA) as ID_FATURA_DEBITO_CONTA,
FF.ID_FATURA as ID_FATURA,
FDC.ID_DEBITO_CONTA as ID_DEBITO_CONTA,
cast(0 as BIT) as FL_CANCELAMENTO,
NULL as DT_ENVIO_CANCELAMENTO,
NULL as ID_COBRANCA_DIVERSA
FROM
"papakura_20221223"."dbo_mig"."stage_fat_fatura" FF
INNER JOIN "papakura_20221223"."dbo"."GBINVOICE" GBI ON GBI.GBIINVOICE = FF.MIG_PK_TEMP
INNER JOIN "papakura_20221223"."dbo"."DEBT" DEBT ON DEBT.DSTATEMENT = GBI.GBISTATEMENT_NO
INNER JOIN "papakura_20221223"."dbo"."LPTRAN_BANK#LPBK$PAY" LPBLP ON LPBLP.LPBK$DEBTID = DEBT.DKEY
INNER JOIN "papakura_20221223"."dbo"."LPTRAN_BANK" LPB ON LPB.LPBK$ID = LPBLP.LPBK$ID
inner join "papakura_20221223"."dbo_mig"."fat_debito_conta" FDC on FDC.MIG_PK_TEMP = LPBLP.LPBK$LEDGER AND FDC.MIG_LPT$BANKACCT_TEMP=LPB.LPBK$BANKACCT
where FDC.CH_ATIVO =1
GROUP BY FF.ID_FATURA,FDC.ID_DEBITO_CONTA
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."fat_fatura_debito_conta__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."fat_fatura_debito_conta__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."fat_fatura_debito_conta__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."fat_fatura_debito_conta__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_fat_fatura_debito_conta__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_fat_fatura_debito_conta__dbt_tmp')
    )
  DROP index "dbo_mig"."fat_fatura_debito_conta__dbt_tmp".dbo_mig_fat_fatura_debito_conta__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_fat_fatura_debito_conta__dbt_tmp_cci
    ON "dbo_mig"."fat_fatura_debito_conta__dbt_tmp"

   

