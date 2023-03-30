
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."fat_debito_conta__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."fat_debito_conta__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."fat_debito_conta__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."fat_debito_conta__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."fat_debito_conta__dbt_tmp_temp_view" as
    WITH BASE AS (SELECT * from "papakura_20221223"."dbo_mig"."stage_fat_debito_conta")
,BANCO as (SELECT * FROM BASE WHERE RN = 1)
,AGENCIA as (SELECT * FROM BASE WHERE RN = 2)
,CONTA as (SELECT * FROM BASE WHERE RN = 3)
,OPERACAO as (SELECT * FROM BASE WHERE RN = 4)

,LEDGER AS (SELECT *, row_number() over(partition by LP$LEDGER order by LP$KEY desc) as RN FROM LEDGERPAY WHERE LP$BANK IS NOT NULL)
,BANCO_CONTA as (SELECT BANCO.LP$KEY, CONCAT(BANCO.INFO,AGENCIA.INFO) AS CD_AGENCIA 
FROM BANCO LEFT JOIN AGENCIA ON BANCO.LP$KEY = AGENCIA.LP$KEY)



,INTERM AS(select

ROW_NUMBER() OVER (ORDER BY LEDGER.LP$KEY) as ID_DEBITO_CONTA,
LP$EFFDATE as DT_OPCAO_DEBITO,
CASE 
    WHEN row_number() over(partition by cuc.CH_MATRICULA_UNIDADE order by LP$EFFDATE desc) >1 THEN coalesce( LEDGER.LP$CANCELDATE,getdate())
    
    ELSE null
END  as DT_CANCELAMENTO,

concat(cast(CONTA.INFO as varchar),''-'',cast(OPERACAO.INFO as varchar)) as NU_CONTA_CORRENTE,
concat(cuc.CH_MATRICULA_UNIDADE,cuc.DIGITO_MATRICULA_UNIDADE) as CH_MATRICULA_REGISTRO_B,
case when row_number() over(partition by cuc.CH_MATRICULA_UNIDADE order by LEDGER.LP$KEY desc ) =1 then 1 ELSE  0 END CH_ATIVO,
a.ID_AGENCIA as ID_AGENCIA,
coalesce(cuc.CH_MATRICULA_UNIDADE, 0) as CH_MATRICULA_UNIDADE,
NULL as CH_MOTIVO_CANCELAMENTO_DAC,
NULL as ID_ARQUIVO_CONTEUDO,
NULL as ID_ARQUIVO_CONTEUDO_CANCELAMENTO,
NULL as CH_OCORRENCIA_RETORNO_DEBITO_CONTA,
20720003 as CH_SITUACAO_DEBITO_CONTA,
1 as ID_CONVENIO_AGENTE_ARRECADADOR,
LEDGER.LP$LEDGER AS MIG_PK_TEMP,
BANCO_CONTA.CD_AGENCIA,
CASE 
    WHEN row_number() over(partition by cuc.CH_MATRICULA_UNIDADE order by LP$EFFDATE desc) =1 THEN cast(0 as BIT)
    
    ELSE cast(1 as BIT)
END as  FL_PAUSAR_DEBITO,
LEDGER.LP$BANK AS MIG_LPT$BANKACCT_TEMP,
LEDGER.LP$KEY AS  MIG_LP$KEY_TEMP
FROM LEDGER
left JOIN "papakura_20221223"."dbo"."CONSUMER" c on c.CACCT =  LEDGER.LP$LEDGER
left JOIN "papakura_20221223"."dbo"."LEDGERPAY_STATUS" LPS ON LEDGER.LP$STATUS=LPS.PKEY
INNER JOIN "papakura_20221223"."dbo_mig"."cad_unidade_comercial" cuc on cuc.CH_MATRICULA_UNIDADE = c.CINSTALL
LEFT JOIN BANCO_CONTA ON BANCO_CONTA.LP$KEY = LEDGER.LP$KEY
LEFT join CONTA ON CONTA.LP$KEY = LEDGER.LP$KEY
LEFT JOIN "papakura_20221223"."dbo_mig"."tab_agencia" a on a.MIG_CD_AGENCIA_TEMP = BANCO_CONTA.CD_AGENCIA
left join OPERACAO ON OPERACAO.LP$KEY = LEDGER.LP$KEY)

,FIN AS (SELECT INTERM.*,ROW_NUMBER() OVER(PARTITION BY MIG_PK_TEMP,MIG_LPT$BANKACCT_TEMP
 ORDER BY MIG_LP$KEY_TEMP DESC) AS RN FROM INTERM)

SELECT * FROM FIN WHERE RN = 1

-- SELECT BANCO_CONTA.*,a.ID_AGENCIA FROM BANCO_CONTA 
-- INNER JOIN "papakura_20221223"."dbo_mig"."tab_agencia" a on CAST(a.CD_AGENCIA AS INTEGER) = CAST(BANCO_CONTA.CD_AGENCIA AS INTEGER)
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."fat_debito_conta__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."fat_debito_conta__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."fat_debito_conta__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."fat_debito_conta__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_fat_debito_conta__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_fat_debito_conta__dbt_tmp')
    )
  DROP index "dbo_mig"."fat_debito_conta__dbt_tmp".dbo_mig_fat_debito_conta__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_fat_debito_conta__dbt_tmp_cci
    ON "dbo_mig"."fat_debito_conta__dbt_tmp"

   

