
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."tab_servico_definicao__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."tab_servico_definicao__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."tab_servico_definicao__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."tab_servico_definicao__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."tab_servico_definicao__dbt_tmp_temp_view" as
    SELECT
row_number() over (order by GL_ID) + 1000 as ID_SERVICO_DEFINICAO,
''S'' as FL_COBRANCA_JURO,
1 as QT_PRAZO_PADRAO,
1 as QT_HORAS_EXECUCAO,
''N'' as FL_SERVICO_URGENTE,
''N'' as FL_TEM_PARCELA_AVISTA,
1 as NR_MAXIMO_PARCELAS,
1 as NR_MAXIMO_PARCELAS_TARIFA_SOCIAL,
1 as QT_MEMBROS_EQUIPE,
1 as NR_PRIORIDADE,
GL_DESC as DS_PADRAO,
row_number() over (order by GL_ID) + 1000  as CD_SERVICO,
''S'' as FL_INCIDENCIA_IMPOSTO,
0.0 as PC_MINIMO_PARCELA_AVISTA,
1 as NR_MAXIMO_POSTERGACAO,
1 as TP_SERVICO,
0 as NR_MAXIMO_MESES_CARENCIA,
''N'' as FL_SUSPENDER_SERVICO_PARCELA_AVISTA,
null as FL_ORDEM_TELA_ENCERRAMENTO,
''N'' as FL_PERMITE_ENCERRAMENTO,
null as QT_UNIDADE_MEDIDA,
null as FL_INCIDENCIA_PENALIDADE,
null as QT_DIAS_PRAZO_FATURAMENTO,
coalesce(cast(0 as BIT), cast(0 as BIT)) as FL_COBRANCA_MATERIAL,
coalesce(cast(0 as BIT), cast(0 as BIT)) as FL_COBRANCA_JURO_MATERIAL,
cast(0 as BIT) as FL_MULTIPLICAR_QTDE_EXECUTADO,
null as FL_OBRA,
cast(0 as BIT) as FL_COBRAR_TAXA_EXPEDIENTE,
cast(0 as BIT) as FL_IMPRIMIR_CROQUI,
null as FL_INCIDE_ISS,
null as FL_INCIDE_PIS_COFINS,
null as FL_INCIDE_ICMS,
null as QT_FOTOS_ENCERRAMENTO_MOBILE,
null as CH_FORMA_COBRANCA_TAXA_EXPEDIENTE,
null as TP_UNIDADE_MEDIDA_SERVICO_EXECUTADO,
coalesce(1, 1) as ID_ACAO_SERVICO,
11 as CH_AGRUPAMENTO_SERVICO,
coalesce(2, null) as CH_TIPO_FATURAMENTO,
1 as CH_ATIVO,
9 as CH_GRUPO_SERVICO,
null as CH_SUB_AGRUPAMENTO_SERVICO,
4 as CH_TIPO_SERVICO_DEFINICAO,
null as CH_SETOR_CONTROLE,
null as ID_MODELO_OS,
null as ID_TERMO,
null as ID_AGRUPAMENTO_ALIQUOTA_ISS,
null as ID_GRUPO_DADOS_EXTRA,
null as CH_TIPO_PARCELAMENTO_ORDEM_SERVICO,
1 as ID_MODELO_DOCUMENTO_OS,
null as FL_SERVICO_EXPRESS_MOBILE,
null as ID_TERMO_MOBILE,
null as FL_CANC_OS_POSTERGA_EXCEDIDA,
null as ID_SERVICO_POSTERGACAO_EXCEDIDA,
null as FL_OBRIGATORIO_ANEXO_ABERTURA,
null as FL_OBRIGATORIO_ANEXO_ENCERRAMENTO,
null as QT_VIDEOS_ENCERRAMENTO_MOBILE,
GL_ID as GL_ID,
''S'' AS MIG_SERVICO_TABELADO_TEMP,
GL_ID as MIG_GL_ID_TEMP,
cast(1 as bit) as FL_INCIDE_GST

FROM

"papakura_20221223"."dbo"."EMS_TRANS_CODES" ETC
WHERE ETC.GL_ID not in (select distinct TARC$CODE from "papakura_20221223"."dbo"."TARCHARGE" TC
where TARC$CODE <> ''MIN'')
and ETC.GL_ID not in (select distinct TARC$TEMPLATE from "papakura_20221223"."dbo"."TARCHARGE" TC
where TARC$TEMPLATE  <> ''MIN'')

UNION

SELECT
row_number() over (order by TC.TARC$CODE) + 4000 as ID_SERVICO_DEFINICAO,
''S'' as FL_COBRANCA_JURO,
1 as QT_PRAZO_PADRAO,
1 as QT_HORAS_EXECUCAO,
''N'' as FL_SERVICO_URGENTE,
''N'' as FL_TEM_PARCELA_AVISTA,
1 as NR_MAXIMO_PARCELAS,
1 as NR_MAXIMO_PARCELAS_TARIFA_SOCIAL,
1 as QT_MEMBROS_EQUIPE,
1 as NR_PRIORIDADE,
TARC$DESC as DS_PADRAO,
row_number() over (order by TC.TARC$CODE) + 4000 as CD_SERVICO,
''S'' as FL_INCIDENCIA_IMPOSTO,
0.0 as PC_MINIMO_PARCELA_AVISTA,
1 as NR_MAXIMO_POSTERGACAO,
1 as TP_SERVICO,
0 as NR_MAXIMO_MESES_CARENCIA,
''N'' as FL_SUSPENDER_SERVICO_PARCELA_AVISTA,
null as FL_ORDEM_TELA_ENCERRAMENTO,
''N'' as FL_PERMITE_ENCERRAMENTO,
null as QT_UNIDADE_MEDIDA,
null as FL_INCIDENCIA_PENALIDADE,
null as QT_DIAS_PRAZO_FATURAMENTO,
coalesce(cast(0 as BIT), cast(0 as BIT)) as FL_COBRANCA_MATERIAL,
coalesce(cast(0 as BIT), cast(0 as BIT)) as FL_COBRANCA_JURO_MATERIAL,
cast(0 as BIT) as FL_MULTIPLICAR_QTDE_EXECUTADO,
null as FL_OBRA,
cast(0 as BIT) as FL_COBRAR_TAXA_EXPEDIENTE,
cast(0 as BIT) as FL_IMPRIMIR_CROQUI,
null as FL_INCIDE_ISS,
null as FL_INCIDE_PIS_COFINS,
null as FL_INCIDE_ICMS,
null as QT_FOTOS_ENCERRAMENTO_MOBILE,
null as CH_FORMA_COBRANCA_TAXA_EXPEDIENTE,
null as TP_UNIDADE_MEDIDA_SERVICO_EXECUTADO,
15 as ID_ACAO_SERVICO,
11 as CH_AGRUPAMENTO_SERVICO,
coalesce(2, null) as CH_TIPO_FATURAMENTO,
1 as CH_ATIVO,
9 as CH_GRUPO_SERVICO,
null as CH_SUB_AGRUPAMENTO_SERVICO,
3 as CH_TIPO_SERVICO_DEFINICAO,
null as CH_SETOR_CONTROLE,
null as ID_MODELO_OS,
null as ID_TERMO,
null as ID_AGRUPAMENTO_ALIQUOTA_ISS,
null as ID_GRUPO_DADOS_EXTRA,
null as CH_TIPO_PARCELAMENTO_ORDEM_SERVICO,
1 as ID_MODELO_DOCUMENTO_OS,
null as FL_SERVICO_EXPRESS_MOBILE,
null as ID_TERMO_MOBILE,
null as FL_CANC_OS_POSTERGA_EXCEDIDA,
null as ID_SERVICO_POSTERGACAO_EXCEDIDA,
null as FL_OBRIGATORIO_ANEXO_ABERTURA,
null as FL_OBRIGATORIO_ANEXO_ENCERRAMENTO,
null as QT_VIDEOS_ENCERRAMENTO_MOBILE,
TC.TARC$CODE as GL_ID,
''N'' AS MIG_SERVICO_TABELADO_TEMP,

TC.TARC$CODE as MIG_GL_ID_TEMP,
cast(1 as bit) as FL_INCIDE_GST
FROM

"papakura_20221223"."dbo"."TARCHARGE" TC

WHERE TC.TARC$CODE IN (SELECT TARC$CODE  FROM TARCHARGE
WHERE TARC$CODE  IN (select DISTINCT T.TARC$CODE from EMS_CON_PLAN#FIXED_LIST ECPFL
INNER JOIN TARCHARGE T ON T.TARC$CODE = ECPFL.ECPLAN_FCHGCODE))
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."tab_servico_definicao__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."tab_servico_definicao__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."tab_servico_definicao__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."tab_servico_definicao__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_tab_servico_definicao__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_tab_servico_definicao__dbt_tmp')
    )
  DROP index "dbo_mig"."tab_servico_definicao__dbt_tmp".dbo_mig_tab_servico_definicao__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_tab_servico_definicao__dbt_tmp_cci
    ON "dbo_mig"."tab_servico_definicao__dbt_tmp"

   
