

--select *,MIG_STATEMENT_TEMP from FCCM
--WHERE MIG_STATEMENT_TEMP_ADJ IS NOT NULL
--ORDER BY MIG_LEDGERID_TEMP DESC,NR_SEQUENCIAL_REGISTRO DESC

with BASE AS (SELECT
-- ROW_NUMBER() OVER(ORDER BY ID_CONTA_CORRENTE_MOVIMENTACAO) as ID_PAGAMENTO,
null as CD_REGISTRO,
TAA.CD_AGENTE_ARRECADADOR as CD_BANCO_PAGTO,
TA.CD_AGENCIA as CD_AGENCIA_PAGTO,
FCCM.DT_MOVIMENTACAO as DT_INCLUSAO_SISTEMA,
FCCM.DT_MOVIMENTACAO as DT_GERACAO_PAGTO,
NULL as NU_SEQUENCIAL_PAGTO,
FCCM.MIG_DDATEDUE_PK_TEMP as DT_VENCIMENTO_DEBITO,
CASE WHEN FCCM.VL_MOVIMENTACAO < 0 THEN FCCM.VL_MOVIMENTACAO * -1 ELSE FCCM.VL_MOVIMENTACAO END as VL_VALOR_DEBITO,
0 as CD_RETORNO_DEBITO,
FCCM.DT_MOVIMENTACAO as DT_PAGAMENTO_DEBITO,
FCCM.DT_MOVIMENTACAO as DT_CREDITO,
0.0 as VL_TARIFA,
FCCM.NR_SEQUENCIAL_REGISTRO as NU_SEQUENCIAL_REGISTRO,
FCCM.MIG_DKEY_TEMP as CH_DOCUMENTO_ARRECADACAO,
1 as TP_DOCUMENTO_ARRECADACAO,
cast(concat(year(FCCM.DT_MOVIMENTACAO),concat('-',concat(month(FCCM.DT_MOVIMENTACAO),concat('-',01)))) as date) as DT_REF_DOCUMENTO_ARRECADACAO,
CASE WHEN FCCM.VL_MOVIMENTACAO < 0 THEN FCCM.VL_MOVIMENTACAO * -1 ELSE FCCM.VL_MOVIMENTACAO END as VL_DOCUMENTO_ARRECADACAO,
'S' as FL_SITUACAO_FECHAMENTO_MENSAL,
'N' as FL_ESTORNO_PAGAMENTO,
'N' as FL_PAGAMENTO_DUPLICADO,
FCCM.DT_MOVIMENTACAO as DT_TRANSFERENCIA,
NULL as FL_DEPOSITO_IDENTIFICADO,
0 as ID_DEPOSITO_BANCARIO,
NULL as FL_INTRA_ORCAMENTARIA,
CASE 
    WHEN FCCM.MIG_DTYPE_TEMP = 'DCF' THEN 4 ELSE 1
END as CH_TIPO_PAGAMENTO_ARRECADACAO,
CF.ID_FECHAMENTOS as ID_FECHAMENTOS,
NULL as ID_ARQUIVO_CONTEUDO,
1 as CH_SITUACAO_PAGTO,
9 as CH_TIPO_FORMA_ARRECADACAO,
NULL as CH_OCORRENCIA_RETORNO_DEBITO_CONTA,
FCCM.MIG_LEDGERID_TEMP AS MIG_LEDGERID_TEMP,
FCCM.MIG_STATEMENT_TEMP_ADJ AS MIG_STATEMENT_TEMP,
FCCM.MIG_INVOICE_TEMP AS MIG_INVOICE_TEMP,
FCCM.MIG_DTYPE_TEMP AS MIG_DTYPE_TEMP,
FCCM.MIG_DKEY_TEMP AS MIG_DKEY_TEMP,
FCCM.MIG_DDATEDUE_PK_TEMP AS MIG_DDATEDUE_PK_TEMP,
ID_CONTA_CORRENTE_MOVIMENTACAO as MIG_ID_CONTA_CORRENTE_MOVIMENTACAO_TEMP,
FF.ID_FATURA AS MIG_ID_FATURA,
FCCM.NR_SEQUENCIAL_REGISTRO AS MIG_NR_SEQUENCIAL_REGISTRO_TEMP,
FCCM.MIG_STATEMENT_TEMP_ADJ
FROM
 "papakura_20221223"."dbo_mig"."stage_fccm" FCCM
LEFT JOIN "papakura_20221223"."dbo"."GBINVOICE"  GBI ON GBI.GBISTATEMENT_NO = FCCM.MIG_STATEMENT_TEMP_ADJ
LEFT JOIN "papakura_20221223"."dbo_mig"."stage_fat_fatura" FF ON FF.NR_FATURA = GBI.GBIINVOICE
LEFT JOIN "papakura_20221223"."dbo_mig"."fat_fatura_debito_conta"  FFDC ON FFDC.ID_FATURA = FF.ID_FATURA
LEFT JOIN "papakura_20221223"."dbo_mig"."fat_debito_conta"  FDC ON FDC.ID_DEBITO_CONTA = FFDC.ID_DEBITO_CONTA
LEFT JOIN "papakura_20221223"."dbo_mig"."tab_agencia"  TA ON TA.ID_AGENCIA = FDC.ID_AGENCIA
LEFT JOIN "papakura_20221223"."dbo_mig"."tab_agente_arrecadador"  TAA ON TAA.ID_AGENTE_ARRECADADOR = TA.ID_AGENTE_ARRECADADOR
left JOIN "papakura_20221223"."dbo_mig"."cad_fechamentos"  CF on CAST(CF.MES_REFERENCIA AS DATE) = cast(concat(year(FCCM.DT_MOVIMENTACAO),concat('-',concat(month(FCCM.DT_MOVIMENTACAO),concat('-',01)))) as date) AND CF.CH_PROCESSO = 4
where FCCM.MIG_STATEMENT_TEMP_ADJ is not null
)


,fin_order as (
SELECT *, ROW_NUMBER() OVER(ORDER BY MIG_ID_CONTA_CORRENTE_MOVIMENTACAO_TEMP) as ID_PAGAMENTO FROM BASE
)
select * from fin_order 
-- order by ID_PAGAMENTO