WITH FSU AS(SELECT FSU.MIG_ID_FATURA_TEMP, SUM(FSU.VL_TOTAL_SERVICO) AS VL_TOTAL_SERVICO  FROM "papakura_20221223"."dbo_mig"."fat_servico_unidade" FSU
GROUP BY FSU.MIG_ID_FATURA_TEMP)

,FATURAS AS(SELECT *,
cast(concat(year(fat.GBIDATE),concat('-',concat(month(fat.GBIDATE),concat('-',01)))) as date) as DT_MESANO_REF
FROM "papakura_20221223"."dbo"."GBINVOICE" fat)

, NEG_FAT AS (SELECT GBI.GBIINVOICE,GBI.GBILEDGER , GBI.GBICUR_NO_DAYS, GBI.GBITOT_DOLLAR, GBI.GBIREV_TYPE ,
LAG(GBI.GBITOT_DOLLAR) OVER(PARTITION BY GBI.GBILEDGER ORDER BY GBI.GBIINVOICE DESC) FAT_ANTERIOR,
GBI.GBITOT_DOLLAR + LAG(GBI.GBITOT_DOLLAR) OVER(PARTITION BY GBI.GBILEDGER ORDER BY GBI.GBIINVOICE DESC) AS DIF_FATURAS,
CASE 
	WHEN (GBI.GBICUR_NO_DAYS + LAG(GBI.GBICUR_NO_DAYS) OVER(PARTITION BY GBI.GBILEDGER ORDER BY GBI.GBIINVOICE DESC)) = 0 or (GBI.GBITOT_DOLLAR + LAG(GBI.GBITOT_DOLLAR) OVER(PARTITION BY GBI.GBILEDGER ORDER BY GBI.GBIINVOICE DESC)) IN (0,1) OR GBI.GBITOT_DOLLAR < 0  or GBI.GBIREV_TYPE is not null THEN 
1 	ELSE 0 END AS REVERSED,
CASE WHEN (GBI.GBICUR_NO_DAYS + LAG(GBI.GBICUR_NO_DAYS) OVER(PARTITION BY GBI.GBILEDGER ORDER BY GBI.GBIINVOICE DESC)) = 0 or (GBI.GBITOT_DOLLAR + LAG(GBI.GBITOT_DOLLAR) OVER(PARTITION BY GBI.GBILEDGER ORDER BY GBI.GBIINVOICE DESC)) = 0  THEN 
GBI.GBITOT_DOLLAR 
WHEN  GBI.GBITOT_DOLLAR < 0 THEN GBITOT_DOLLAR * 1
ELSE GBI.GBITOT_DOLLAR END AS GBITOT_DOLLAR_ADJ
FROM GBINVOICE GBI
--WHERE GBILEDGER IN (100009107)
)
,REGISTERS_INTERM as (select GBIR.*,
ROW_NUMBER() OVER(PARTITION BY GBIR.GBIINVOICE ORDER BY VMC DESC)  AS RN from GBINVOICE#REGISTERS GBIR)

,REGISTERS AS(SELECT * FROM REGISTERS_INTERM WHERE RN=1)

,CONSUMO_INTERM as (select GBIR.GBIINVOICE,
CASE WHEN GBIR.GBIMCURR_TYPE IS NULL THEN 'AB' ELSE GBIR.GBIMCURR_TYPE END  as GBIMCURR_TYPE_ADJ,
ROW_NUMBER() OVER(PARTITION BY GBIR.GBIINVOICE ORDER BY VMC DESC)  AS RN from GBINVOICE#REGISTERS GBIR)

,CONSUMO_HIST AS (SELECT GBIINVOICE, GBIMCURR_TYPE_ADJ FROM CONSUMO_INTERM WHERE RN=1)


,FINAL_NEG_FAT AS (SELECT * FROM NEG_FAT 
WHERE REVERSED = 1) 

,BASE AS (
SELECT GBI.GBIINVOICE,GBS.GBSCLOSEBAL AS FAT_ATUAL, 
LAG(GBS.GBSOPENBAL,1) OVER(PARTITION BY GBS.GBSLEDGER ORDER BY GBS.GBSSTATEMENT DESC) ULTIMO_PAGAMENTO$,
GBIREV_TYPE


FROM GBINVOICE GBI
INNER JOIN GBSTATEMENT GBS ON GBS.GBSSTATEMENT = GBI.GBISTATEMENT_NO 
)
,PAYMENT_ADJ AS (SELECT fcc.ch_matricula_unidade, fccm.VL_SALDO_ATUAL, row_number() over(partition by fcc.ch_matricula_unidade order by NR_SEQUENCIAL_REGISTRO desc) RN FROM "papakura_20221223"."dbo_mig"."fin_conta_corrente_movimentacao" fccm
inner join "papakura_20221223"."dbo_mig"."fin_conta_corrente" fcc on fcc.id_conta_corrente = fccm.id_conta_corrente  )

,PAYMENT AS (SELECT * FROM PAYMENT_ADJ WHERE RN = 1)
,SITUACAO AS (SELECT *, 


CASE 
    WHEN GBIREV_TYPE IS NOT NULL THEN 3 
    ELSE
        CASE
            WHEN FAT_ATUAL = ULTIMO_PAGAMENTO$ THEN 2
            ELSE 1 END END AS CH_SITUACAO_FATURA


FROM BASE)


,gastos2 as (select 
GBC.GBIINVOICE ,
SUM(CASE WHEN TARCHARGE.TARC$INV$HEAD$GRP = 'SEWER' THEN coalesce(GBICDOLLAR,0) ELSE 0 END) AS ESGOTO_VL,
SUM(CASE WHEN TARCHARGE.TARC$INV$HEAD$GRP = 'WATER' THEN coalesce(GBICDOLLAR,0) ELSE 0 END) AS AGUA_VL,
SUM(CASE WHEN TARCHARGE.TARC$INV$HEAD$GRP = 'OTHER' THEN coalesce(GBICDOLLAR,0) ELSE 0 END) AS ADMIN_FEE_VL,
SUM(CASE WHEN TARCHARGE.TARC$INV$HEAD$GRP = NULL THEN coalesce(GBICDOLLAR,0) ELSE 0 END) AS SERVICO_VL,
SUM(CASE WHEN TARCHARGE.TARC$INV$HEAD$GRP = 'SEWER' THEN coalesce(GBICTAX,0) ELSE 0 END) AS ESGOTO_TX,
SUM(CASE WHEN TARCHARGE.TARC$INV$HEAD$GRP = 'WATER' THEN coalesce(GBICTAX,0) ELSE 0 END) AS AGUA_TX,
SUM(CASE WHEN TARCHARGE.TARC$INV$HEAD$GRP = 'OTHER' THEN coalesce(GBICTAX,0) ELSE NULL END) AS ADMIN_FEE_TX,
SUM(CASE WHEN TARCHARGE.TARC$INV$HEAD$GRP = NULL THEN coalesce(GBICTAX,0) ELSE 0 END) AS SERVICO_TX,

MAX(CASE WHEN TARCHARGE.TARC$INV$HEAD$GRP = 'WATER' THEN 1 ELSE 0 END) AS HIST_FL_COBRAR_AGUA,
MAX(CASE WHEN TARCHARGE.TARC$INV$HEAD$GRP = 'SEWER' THEN 1 ELSE 0 END) AS HIST_FL_COBRAR_ESGOTO






from GBINVOICE#CHARGES GBC
inner join TARCHARGE on TARCHARGE.TARC$CODE =  GBC.GBICCHARGE
WHERE GBC.GBICCHARGE IS NOT NULL AND TARCHARGE.TARC$CODE IN (SELECT TARC$CODE  FROM TARCHARGE
WHERE TARC$CODE  IN(select DISTINCT T.TARC$CODE from EMS_CON_PLAN#REGISTER_LIST ECPRL
INNER JOIN TARCHARGE T ON T.TARC$CODE = ECPRL.ECPLAN_TARCODE))
GROUP BY GBC.GBIINVOICE

)

,gastos as( 
    select gastos2.*,
(cast(coalesce(ESGOTO_VL,0) as double precision) + cast(coalesce(AGUA_VL,0) as double precision) + cast(coalesce(ADMIN_FEE_VL,0) as double precision) + cast(coalesce(SERVICO_VL,0) as double precision) + cast(coalesce(ESGOTO_TX,0) as double precision) + cast(coalesce(AGUA_TX,0) as double precision) + cast(coalesce(ADMIN_FEE_TX,0) as double precision) + cast(coalesce(SERVICO_TX,0) as double precision)) /100 AS VL_TOTAL_FATURA,
coalesce((cast(coalesce(ESGOTO_VL,0) as double precision) + cast(coalesce(ESGOTO_TX,0) as double precision)),0) /100 AS VL_TOTAL_ESGOTO,
coalesce((cast(coalesce(AGUA_VL,0) as double precision) + cast(coalesce(AGUA_TX,0) as double precision)),0) /100 AS VL_TOTAL_AGUA,
coalesce((cast(coalesce(ADMIN_FEE_VL,0) as double precision) + cast(coalesce(ADMIN_FEE_TX,0) as double precision)),0) /100 AS VL_TOTAL_ADMIN_FEE,
coalesce((cast(coalesce(ESGOTO_TX,0) as double precision) + cast(coalesce(AGUA_TX,0) as double precision) + cast(coalesce(SERVICO_TX,0) as double precision)),0) /100 AS VL_TOTAL_IMPOSTO,
coalesce((cast(coalesce(ESGOTO_VL,0) as double precision) + cast(coalesce(AGUA_VL,0) as double precision) + cast(coalesce(SERVICO_VL,0) as double precision)),0) /100 AS VL_BASE_IMPOSTO,
coalesce((cast(coalesce(SERVICO_VL,0)as double precision) + cast(coalesce(SERVICO_TX,0) as double precision) + cast(coalesce(ADMIN_FEE_VL,0) as double precision) + cast(coalesce(ADMIN_FEE_TX,0) as double precision)),0)  /100 AS VL_TOTAL_SERVICOS
 from gastos2)


,fatura as (
SELECT
row_number() over(order by fat.GBIINVOICE asc) as ID_FATURA,
CASE WHEN DENSE_RANK()  over(partition by uc.CH_MATRICULA_UNIDADE order by fat.DT_MESANO_REF desc) = 1
AND row_number() OVER(PARTITION BY uc.CH_MATRICULA_UNIDADE,fat.DT_MESANO_REF order by fat.DT_MESANO_REF, fat.GBIINVOICE) > 1
AND row_number() OVER(PARTITION BY uc.CH_MATRICULA_UNIDADE,fat.DT_MESANO_REF order by fat.DT_MESANO_REF, fat.GBIINVOICE DESC) = 1 
AND S.CH_SITUACAO_FATURA not in (3,7)
THEN DATEADD(month,1,fat.DT_MESANO_REF)  

ELSE fat.DT_MESANO_REF END as DT_MESANO_REF,
cast(cast(case
    when fat.GBIDUE_DATE is null then dateadd(day,28,fat.GBIDATE)
    else fat.GBIDUE_DATE
end as datetime) as varchar) as DT_VENCIMENTO_FATURA,
cast(cast(case when reg.GBIMCONSUMP <0 then reg.GBIMCONSUMP * 1 else reg.GBIMCONSUMP end as float) as varchar)  as QT_VOLUME_FATURADO_FATURA,
cast(cast(fat.GBIDATE as datetime) as varchar) as DT_SITUACAO_FATURA,
cast(cast(fat.GBIDATE as datetime) as varchar) as DT_EMISSAO_FATURA,
case when gastos.VL_TOTAL_AGUA < 0 then gastos.VL_TOTAL_AGUA * 1 else gastos.VL_TOTAL_AGUA end as VL_TOTAL_AGUA,
case when gastos.VL_TOTAL_ESGOTO < 0 then gastos.VL_TOTAL_ESGOTO * 1 ELSE gastos.VL_TOTAL_ESGOTO END as VL_TOTAL_ESGOTO, 
coalesce(FSU.VL_TOTAL_SERVICO,0) as VL_TOTAL_SERVICOS,
0 as VL_TOTAL_DESCONTOS,
0 as VL_TOTAL_OUTORGA,
0 as VL_TOTAL_OUTORGA_ESGOTO,
-- CASE WHEN COALESCE(GBS.GBSCLOSEBAL/100,fat.GBITOT_DOLLAR/100) < 0 THEN COALESCE(GBS.GBSCLOSEBAL/100,fat.GBITOT_DOLLAR/100) * -1 ELSE COALESCE(GBS.GBSCLOSEBAL/100,fat.GBITOT_DOLLAR/100) END as VL_TOTAL_FATURA,
-- CASE WHEN COALESCE(GBS.GBSCLOSEBAL/100,fat.GBITOT_DOLLAR/100) < 0 THEN COALESCE(GBS.GBSCLOSEBAL/100,fat.GBITOT_DOLLAR/100) * -1 ELSE COALESCE(GBS.GBSCLOSEBAL/100,fat.GBITOT_DOLLAR/100) END as VL_BASE_JUROS_MULTA,
null as VL_PAGO,

'S' as FL_COBRAR_MULTA_ATRASO,
null as FL_COBRAR_JUROS_ATRASO,
null as FL_COBRAR_CORRECAO_ATRASO,
null as FL_SITUACAO_FECHAMENTO_MENSAL_FATURA,
reg.GBIMSERIAL as HIST_NR_HIDROMETRO,
7 as HIST_NR_DIGITOS_HIDROMETRO,
uc.NR_LOCALIZACAO_UNIDADE as HIST_NR_LOCALIZACAO,
cast(AVG(CASE WHEN reg.GBIMCONSUMP < 0 THEN reg.GBIMCONSUMP * 1 ELSE reg.GBIMCONSUMP END) OVER(PARTITION BY fat.GBIINSTALL) as integer)  as HIST_CONSUMO_MEDIO,
case 
    when fat.GBIREAD_TODATE >= CAST('1990-01-01 00:00:00.000' AS DATE) AND fat.GBIREAD_TODATE <=  CAST('1999-12-31 00:00:00.000' AS DATE)then 1
    when fat.GBIREAD_TODATE >= CAST('2000-01-01 00:00:00.000' AS DATE) AND fat.GBIREAD_TODATE <=  CAST('2010-09-30 00:00:00.000' AS DATE) then 2
    when fat.GBIREAD_TODATE >= CAST('2010-10-01 00:00:00.000' AS DATE) AND fat.GBIREAD_TODATE <=  CAST('2011-06-30 00:00:00.000' AS DATE) then 3
    when fat.GBIREAD_TODATE >= CAST('2011-07-01 00:00:00.000' AS DATE) AND fat.GBIREAD_TODATE <=  CAST('2012-06-30 00:00:00.000' AS DATE) then 4
    when fat.GBIREAD_TODATE >= CAST('2012-07-01 00:00:00.000' AS DATE) AND fat.GBIREAD_TODATE <=  CAST('2013-06-30 00:00:00.000' AS DATE) then 5
    when fat.GBIREAD_TODATE >= CAST('2013-07-01 00:00:00.000' AS DATE) AND fat.GBIREAD_TODATE <=  CAST('2014-06-30 00:00:00.000' AS DATE) then 6
    when fat.GBIREAD_TODATE >= CAST('2014-07-01 00:00:00.000' AS DATE) AND fat.GBIREAD_TODATE <=  CAST('2015-06-30 00:00:00.000' AS DATE) then 7
    when fat.GBIREAD_TODATE >= CAST('2015-07-01 00:00:00.000' AS DATE) AND fat.GBIREAD_TODATE <=  CAST('2016-06-30 00:00:00.000' AS DATE)then 8
    when fat.GBIREAD_TODATE >= CAST('2016-07-01 00:00:00.000' AS DATE) AND fat.GBIREAD_TODATE <=  CAST('2017-06-30 00:00:00.000' AS DATE) then 9
    when fat.GBIREAD_TODATE >= CAST('2017-07-01 00:00:00.000' AS DATE) AND fat.GBIREAD_TODATE <=  CAST('2018-06-30 00:00:00.000' AS DATE) then 10
    when fat.GBIREAD_TODATE >= CAST('2018-07-01 00:00:00.000' AS DATE) AND fat.GBIREAD_TODATE <=  CAST('2019-06-30 00:00:00.000' AS DATE) then 11
    when fat.GBIREAD_TODATE >= CAST('2019-07-01 00:00:00.000' AS DATE) AND fat.GBIREAD_TODATE <=  CAST('2020-06-30 00:00:00.000' AS DATE) then 12
    when fat.GBIREAD_TODATE >= CAST('2020-07-01 00:00:00.000' AS DATE) AND fat.GBIREAD_TODATE <=  CAST('2021-06-30 00:00:00.000' AS DATE) then 13
    when fat.GBIREAD_TODATE >= CAST('2021-07-01 00:00:00.000' AS DATE) AND fat.GBIREAD_TODATE <=  CAST('2022-06-30 00:00:00.000' AS DATE) then 14
    when fat.GBIREAD_TODATE >= CAST('2022-07-01 00:00:00.000' AS DATE) AND fat.GBIREAD_TODATE <=  CAST('2023-06-30 00:00:00.000' AS DATE) then 15

    else 1
end as HIST_COD_TABELA_TARIFARIA,
cast(cast(case
    when fat.GBIDUE_DATE is null then dateadd(month,1,fat.GBIDATE)
    else fat.GBIDUE_DATE
end  as date) as varchar) as HIST_DT_VENCIMENTO_FATURA,
1 as HIST_COD_TIPO_FATURA,
1 as HIST_COD_TIPO_COBRANCA,
CASE WHEN gastos.HIST_FL_COBRAR_AGUA = 1 THEN 'S' ELSE 'N' END as HIST_FL_COBRAR_AGUA,
CASE WHEN gastos.HIST_FL_COBRAR_ESGOTO = 1 THEN 'S' ELSE 'N' END as HIST_FL_COBRAR_ESGOTO,
1 as HIST_COD_CATEGORIA_PRINCIPAL,
case when reg.GBIMCURR_READ < 0 then reg.GBIMCURR_READ * 1 else reg.GBIMCURR_READ end as HIST_NR_LEITURA_ATUAL,
case when reg.GBIMPREV_READ < 0 then reg.GBIMPREV_READ * 1 else reg.GBIMPREV_READ end as HIST_NR_LEITURA_ANTERIOR,
0 as HIST_QT_SALDO_CONSUMO,
cast(cast(reg.GBIMPREV_DATE as date) as varchar) as HIST_DATA_LEITURA_ANTERIOR,
cast(cast(reg.GBIMCURR_DATE as date) as varchar) as HIST_DATA_LEITURA_ATUAL,
NULL as HIST_DADOS_BANCARIOS_DEBITO_CONTA,
NULL as HIST_ID_ORGAO_CENTRALIZADOR,
NULL as HIST_ID_OCORRENCIA_LEITURA,
la.CH_SITUACAO_LIGACAO_AGUA as HIST_CH_SITUACAO_LIGACAO_AGUA,
CASE
WHEN CONSUMO_HIST.GBIMCURR_TYPE_ADJ = 'AB' then 8
WHEN CONSUMO_HIST.GBIMCURR_TYPE_ADJ = 'AE' then 1
WHEN CONSUMO_HIST.GBIMCURR_TYPE_ADJ = 'BR' then 7
WHEN CONSUMO_HIST.GBIMCURR_TYPE_ADJ = 'CR' then 2
WHEN CONSUMO_HIST.GBIMCURR_TYPE_ADJ = 'E1' then 1
WHEN CONSUMO_HIST.GBIMCURR_TYPE_ADJ = 'E2' then 1
WHEN CONSUMO_HIST.GBIMCURR_TYPE_ADJ = 'E3' then 1
WHEN CONSUMO_HIST.GBIMCURR_TYPE_ADJ = 'EM' then 1
WHEN CONSUMO_HIST.GBIMCURR_TYPE_ADJ = 'GE' then 1
WHEN CONSUMO_HIST.GBIMCURR_TYPE_ADJ = 'GR' then 2
WHEN CONSUMO_HIST.GBIMCURR_TYPE_ADJ = 'IM' then 2
WHEN CONSUMO_HIST.GBIMCURR_TYPE_ADJ = 'ME' then 1
WHEN CONSUMO_HIST.GBIMCURR_TYPE_ADJ = 'MR' then 4
WHEN CONSUMO_HIST.GBIMCURR_TYPE_ADJ = 'NM' then 8
WHEN CONSUMO_HIST.GBIMCURR_TYPE_ADJ = 'OR' then 2
WHEN CONSUMO_HIST.GBIMCURR_TYPE_ADJ = 'RD' then 1
WHEN CONSUMO_HIST.GBIMCURR_TYPE_ADJ = 'RM' then 2
ELSE 8

END as HIST_CH_TIPO_CONSUMO_FATURADO,
loc.ID_LOCALIZACAO as HIST_ID_LOCALIZACAO_UNIDADE,
cast(case when reg.GBIMCONSUMP < 0 then reg.GBIMCONSUMP * 1 else reg.GBIMCONSUMP end as integer) as HIST_CONSUMO_REAL,
cast(0 as BIT) as HIST_FL_ESGOTO_TRATADO,
case when gastos.VL_TOTAL_IMPOSTO < 0 then gastos.VL_TOTAL_IMPOSTO * 1 else gastos.VL_TOTAL_IMPOSTO END as VL_TOTAL_IMPOSTO,
CASE WHEN gastos.VL_BASE_IMPOSTO < 0 THEN gastos.VL_BASE_IMPOSTO * 1 ELSE gastos.VL_BASE_IMPOSTO END as VL_TOTAL_BASE_IMPOSTO,
'N' as HIST_POSSUI_ISENCAO_TARIFA_AGUA,
'N' as HIST_POSSUI_ISENCAO_TARIFA_ESGOTO,
NULL as HIST_POSSUI_ISENCAO_TARIFA_SERVICO,
null as ID_PAGAMENTO,
null as FL_DESCONTO,
null as FL_PARCELAMENTO,
null as FL_FATURA_PDD,
cast(cast(fat.GBIDATE  as date) as varchar) as DT_GRAVACAO_FATURA,
null as FL_SITUACAO_SPC,
null as FL_SITUACAO_SERASA,
null as FL_CONTABILIZADA,
null as FL_DIVIDA_ATIVA,
null as FL_PERMITE_INCLUSAO_SPC,
cast(cast(fat.GBIDATE  as date) as varchar) as DT_IMPRESSAO_FATURA,
fat.GBIINVOICE as NR_FATURA,
0 as VL_REPASSE_ESGOTO_TERCEIRO,
0 as QT_PESO_LIGACAO_PARTICULAR,
CASE WHEN fat.GBIINVOICE IN (SELECT GBIINVOICE FROM FINAL_NEG_FAT) THEN 3 
-- WHEN AP.ID_PAGAMENTO IS NOT NULL THEN 2
ELSE COALESCE(S.CH_SITUACAO_FATURA,3)
END as CH_SITUACAO_FATURA,
case 
    when  uc.CH_MATRICULA_UNIDADE IN (SELECT CH_MATRICULA_UNIDADE FROM "papakura_20221223"."dbo_mig"."fat_debito_conta") THEN 1 
    ELSE 2
end as CH_TIPO_COBRANCA,
1 as CH_MOTIVO_EMISSAO_FATURA,
CASE WHEN DENSE_RANK() over(partition by uc.CH_MATRICULA_UNIDADE order by fat.DT_MESANO_REF desc) = 1
AND row_number() OVER(PARTITION BY uc.CH_MATRICULA_UNIDADE,fat.DT_MESANO_REF order by fat.DT_MESANO_REF, fat.GBIINVOICE) > 1 
AND row_number() OVER(PARTITION BY uc.CH_MATRICULA_UNIDADE,fat.DT_MESANO_REF order by fat.DT_MESANO_REF, fat.GBIINVOICE DESC) = 1 

 AND S.CH_SITUACAO_FATURA not in (3,7)
THEN 6 ELSE 1 END  as CH_TIPO_FATURA,
1 as CH_MOTIVO_SITUACAO_FATURA,
3 as CH_TIPO_EMISSAO_FATURA,
1 as CH_TIPO_DOCUMENTO_COBRANCA,
4 as CH_TIPO_ENTREGA_FATURA_COLETOR,
uc.ID_GRUPO_FATURAMENTO as ID_GRUPO_FATURAMENTO,
49 as ID_USUARIO,
null as ID_FECHAMENTOS,
uc.CH_MATRICULA_UNIDADE as CH_MATRICULA_UNIDADE,
1 as CH_REGRA_FATURAMENTO,
NULL as ID_CONTRATO_ALUGUEL,
cast(cast(fat.GBIDUE_DATE  as date) as varchar) as DT_TOLERANCIA_VENCIMENTO,
0 as VL_TOTAL_LIXO,
-- CASE WHEN COALESCE(GBS.GBSCLOSEBAL/100,fat.GBITOT_DOLLAR/100) < 0 THEN COALESCE(GBS.GBSCLOSEBAL/100,fat.GBITOT_DOLLAR/100) * -1 ELSE COALESCE(GBS.GBSCLOSEBAL/100,fat.GBITOT_DOLLAR/100) END as VL_BASE_JUROS_CORRECAO,
-- CASE WHEN COALESCE(GBS.GBSCLOSEBAL/100,fat.GBITOT_DOLLAR/100) < 0 THEN COALESCE(GBS.GBSCLOSEBAL/100,fat.GBITOT_DOLLAR/100) * -1 ELSE COALESCE(GBS.GBSCLOSEBAL/100,fat.GBITOT_DOLLAR/100) END as VL_BASE_MULTA,
NULL as HIST_POSSUI_ISENCAO_TARIFA_LIXO,

reg.GBIMPREV_READ as HIST_NR_LEITURA_ANTERIOR_REAL
-- CASE WHEN COALESCE(GBS.GBSCLOSEBAL/100,fat.GBITOT_DOLLAR/100) < 0 THEN COALESCE(GBS.GBSCLOSEBAL/100,fat.GBITOT_DOLLAR/100) * -1 ELSE COALESCE(GBS.GBSCLOSEBAL/100,fat.GBITOT_DOLLAR/100) END as VL_BASE_JUROS,
-- CASE WHEN COALESCE(GBS.GBSCLOSEBAL/100,fat.GBITOT_DOLLAR/100) < 0 THEN COALESCE(GBS.GBSCLOSEBAL/100,fat.GBITOT_DOLLAR/100) * -1 ELSE COALESCE(GBS.GBSCLOSEBAL/100,fat.GBITOT_DOLLAR/100) END as VL_BASE_CORRECAO
FROM

FATURAS fat
left join REGISTERS reg on cast(reg.GBIINVOICE as varchar) = cast(fat.GBIINVOICE as varchar)
left JOIN  gastos ON gastos.GBIINVOICE = fat.GBIINVOICE
left join "papakura_20221223"."dbo_mig"."cad_unidade_comercial" uc on cast(uc.CH_MATRICULA_UNIDADE as varchar) = cast(fat.GBIINSTALL as varchar)
left join "papakura_20221223"."dbo_mig"."cad_unidade_ligacao_agua" la on cast(la.CH_MATRICULA_UNIDADE as varchar) = cast(uc.CH_MATRICULA_UNIDADE as varchar)
left join "papakura_20221223"."dbo_mig"."tab_localizacao" loc on cast(loc.NU_LOCALIZACAO_COMPLETA as varchar) = cast(substring(uc.NR_LOCALIZACAO_UNIDADE,1,10) as varchar)
left join SITUACAO S ON S.GBIINVOICE = fat.GBIINVOICE
LEFT JOIN CONSUMO_HIST ON CONSUMO_HIST.GBIINVOICE = fat.GBIINVOICE
LEFT JOIN FSU ON FSU.MIG_ID_FATURA_TEMP = fat.GBIINVOICE




)

select *, 
(VL_TOTAL_AGUA+ VL_TOTAL_ESGOTO+VL_TOTAL_SERVICOS+VL_TOTAL_DESCONTOS) as VL_TOTAL_FATURA,
(VL_TOTAL_AGUA+ VL_TOTAL_ESGOTO+VL_TOTAL_SERVICOS+VL_TOTAL_DESCONTOS) as VL_BASE_JUROS_MULTA,
(VL_TOTAL_AGUA+ VL_TOTAL_ESGOTO+VL_TOTAL_SERVICOS+VL_TOTAL_DESCONTOS) as VL_BASE_JUROS_CORRECAO,
(VL_TOTAL_AGUA+ VL_TOTAL_ESGOTO+VL_TOTAL_SERVICOS+VL_TOTAL_DESCONTOS) as VL_BASE_MULTA,
(VL_TOTAL_AGUA+ VL_TOTAL_ESGOTO+VL_TOTAL_SERVICOS+VL_TOTAL_DESCONTOS) as VL_BASE_JUROS,
(VL_TOTAL_AGUA+ VL_TOTAL_ESGOTO+VL_TOTAL_SERVICOS+VL_TOTAL_DESCONTOS) as VL_BASE_CORRECAO,
NR_FATURA AS MIG_PK_TEMP
from fatura
WHERE NR_FATURA IN (SELECT DISTINCT DINVOICEREF FROM DEBT WHERE DEBT.DINVOICEREF IS NOT NULL)