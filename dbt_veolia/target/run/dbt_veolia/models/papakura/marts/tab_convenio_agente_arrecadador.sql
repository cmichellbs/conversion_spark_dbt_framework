
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."tab_convenio_agente_arrecadador__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."tab_convenio_agente_arrecadador__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."tab_convenio_agente_arrecadador__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."tab_convenio_agente_arrecadador__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."tab_convenio_agente_arrecadador__dbt_tmp_temp_view" as
    WITH BASE AS (SELECT
2 AS ID_CONVENIO_AGENTE_ARRECADADOR
,''03-0399-0255426-02'' AS CD_CONVENIO
,''1970-01-01'' AS DT_INICIO_VIGENCIA_CONVENIO
,''2031-12-07 00:00:00.000'' AS DT_FINAL_VIGENCIA_CONVENIO
,0 AS VL_TARIFA_CONVENIO
,1 AS NR_SEQUENCIA_BANCARIA_ENVIO
,3 AS NR_SEQUENCIA_BANCARIA_RETORNO
,''N'' AS FL_ENVIO_ARQUIVO_AUTOMATICO
,''N'' AS FL_QUEBRA_LINHA_Z
,''N'' AS FL_RETORNA_REGISTRO_C
,0 AS NR_DIAS_CREDITO
,''N''AS FL_FRENTE_CAIXA
,''00255426-0000'' AS NR_CONTA_CENTRALIZADORA_ARRECADACAO,
cast(1 as BIT) as fl_permite_cadastro_debito_conta,
9 as QT_CARACTER_MATRICULA,
null as VL_CARACTER_ESQUERDA_MATRICULA,
1 as VL_CARACTER_DIREITA_MATRICULA,
4 as QT_CARACTER_AGENCIA,
null as VL_CARACTER_ESQUERDA_AGENCIA,
1 as VL_CARACTER_DIREITA_AGENCIA,
1 as QT_CARACTER_CONTA,
null as VL_CARACTER_ESQUERDA_CONTA,
1 as VL_CARACTER_DIREITA_CONTA,
cast(0 as BIT) as FL_CADASTRO_DEBITO_CONTA_DADOS_DEBITO,
1 as CH_TIPO_CONVENIO_AGENTE_ARRECADADOR,
21010004 as CH_VERSAO_FEBRABAN,
20+3 as ID_AGENTE_ARRECADADOR,
10+731 as ID_AGENCIA_CENTRALIZADORA_ARRECADACAO,
null as DS_CONVENIO,
null as CD_AGENCIA,
null as NR_CONTA,
null as NR_DV_CONTA,
null as CD_OPERACAO_CONTA,
null as FL_DEDUZIR_TARIFA_PGTO_DUPLICADO
FROM "papakura_20221223"."dbo_mig"."tab_agencia" ta
where CAST(ta.MIG_CD_AGENCIA_TEMP AS VARCHAR) = ''030399'')

SELECT * FROM BASE WHERE ID_AGENTE_ARRECADADOR = 20+3
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."tab_convenio_agente_arrecadador__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."tab_convenio_agente_arrecadador__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."tab_convenio_agente_arrecadador__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."tab_convenio_agente_arrecadador__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_tab_convenio_agente_arrecadador__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_tab_convenio_agente_arrecadador__dbt_tmp')
    )
  DROP index "dbo_mig"."tab_convenio_agente_arrecadador__dbt_tmp".dbo_mig_tab_convenio_agente_arrecadador__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_tab_convenio_agente_arrecadador__dbt_tmp_cci
    ON "dbo_mig"."tab_convenio_agente_arrecadador__dbt_tmp"

   
