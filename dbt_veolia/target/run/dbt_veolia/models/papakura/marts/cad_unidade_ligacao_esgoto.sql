
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."cad_unidade_ligacao_esgoto__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."cad_unidade_ligacao_esgoto__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."cad_unidade_ligacao_esgoto__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."cad_unidade_ligacao_esgoto__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."cad_unidade_ligacao_esgoto__dbt_tmp_temp_view" as
    WITH CONTRACTS AS (SELECT ECC.*, ROW_NUMBER() OVER(PARTITION BY ECC.CCON_CONSUMER ORDER BY ECC.CCON_SEQ DESC) AS RN_C FROM EMS_CON_CONTRACT ECC)

,CONTRACTS_DISTINCT AS (SELECT * FROM CONTRACTS WHERE RN_C = 1)

, CONSUMER_ADJ_TEMP AS (SELECT CONSUMERNO, CACCT , CINSTALL, ROW_NUMBER() OVER(PARTITION BY CINSTALL ORDER BY CONSUMERNO DESC) AS RN FROM CONSUMER  )
,CONSUMER_ADJ AS (SELECT * FROM CONSUMER_ADJ_TEMP WHERE RN = 1)

,BASE AS(SELECT C.CONSUMERNO , C.CACCT AS ACCT , C.CINSTALL AS INSTALL ,CD.CCON_PLANID1 as PLAN1, CD.CCON_SEQ AS SEQ FROM CONSUMER_ADJ C
LEFT JOIN CONTRACTS_DISTINCT CD ON CAST(CD.CCON_CONSUMER AS VARCHAR)= CAST(C.CONSUMERNO AS VARCHAR))

,FINAL AS (SELECT ECC.*,B.* FROM EMS_CON_CONTRACT ECC
INNER JOIN BASE B ON ECC.CCON_SEQ = B.SEQ
WHERE B.PLAN1  IN (select ECPLAN_KEY from "papakura_20221223"."dbo_mig"."stage_has_sewer" where HAS_SEWER = 1))




SELECT
ROW_NUMBER() OVER(ORDER BY INSTALL.INSTALL) as ID_UNIDADE_LIGACAO_ESGOTO,
CAST(CCON_STARTDATE AS DATE) as DT_LIGACAO_ESGOTO,
CAST(CCON_STARTDATE AS DATE) as DT_SITUACAO_LIGACAO_ESGOTO,
coalesce(INSTALL.INSTALL, 0) as NR_LIGACAO_ESGOTO,
CAST(CCON_STARTDATE AS DATE) as DT_ULTIMA_VISITA,
NULL as PARECER_ULTIMA_VISITA,
CASE WHEN FINAL.CCON_PLANID1 IN (select ECPLAN_KEY from "papakura_20221223"."dbo_mig"."stage_has_sewer" where HAS_SEWER_TREATED = 1)
THEN cast(1 as BIT) ELSE cast(0 as BIT) END  as FL_ESGOTO_TRATADO,
1 as CH_POSICAO_CAIXA_INSPECAO,
case when INSTALL.IINST_STATUS = ''DI'' then 0 else 1 end as CH_ATIVO,
6 as CH_MATERIAL_RAMAL_LIGACAO_ESGOTO,
coalesce(1, 0) as CH_SITUACAO_LIGACAO_ESGOTO,
coalesce(2, 0) as CH_MOTIVO_SITUACAO_LIGACAO_ESGOTO,
coalesce(uc.CH_MATRICULA_UNIDADE, 0) as CH_MATRICULA_UNIDADE,
5 as CH_MATERIAL_CAIXA_INSPECAO,
7 as CH_DIAMETRO_RAMAL_LIGACAO_ESGOTO,
NULL as CH_TIPO_IRREGULARIDADE_INSTALACOES_HIDRO_SANITARIAS,
2 as CH_MATERIAL_TAMPA_CAIXA_INSPECAO,
1 as CH_SITUACAO_CAIXA_INSPECAO,
1 as CH_SITUACAO_CAIXA_GORDURA,
NULL as ID_BACIA_ESGOTO,
NULL as ID_ORIGEM_AGUA_ESGOTO,
NULL as ID_SUB_BACIA_ESGOTO,
NULL as NR_LATITUDE_RAMAL,
NULL as NR_LONGITUDE_RAMAL,
NULL as VL_GEOMETRIA_RAMAL,
null as DT_REGULARIZACAO,
CAST(CCON_STARTDATE AS DATE) as DT_INICIO_COBRANCA_ESGOTO,
null as NR_ZERO_PP,
null as VL_PROFUNDIDADE,
null as CH_ORIENTACAO,
null as NU_PROCESSO_EMPRESA,
null as QT_DISTANCIA_DIVISA,
null as CH_POSICAO_RAMAL_LIGACAO_ESGOTO,
INSTALL.INSTALL as MIG_PK_TEMP
FROM
"papakura_20221223"."dbo"."INSTALL" INSTALL
inner join "papakura_20221223"."dbo_mig"."cad_unidade_comercial" uc on uc.CH_MATRICULA_UNIDADE = INSTALL.INSTALL
INNER JOIN FINAL ON FINAL.INSTALL = uc.CH_MATRICULA_UNIDADE
left join "papakura_20221223"."dbo"."GBREADSEQ" RSEQ ON RSEQ.RSD$INSTALL = INSTALL.INSTALL
LEFT JOIN "papakura_20221223"."dbo_mig"."tab_posicao_cavalete" TPC ON TPC.position = RSEQ.RSD$LOC
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."cad_unidade_ligacao_esgoto__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."cad_unidade_ligacao_esgoto__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."cad_unidade_ligacao_esgoto__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."cad_unidade_ligacao_esgoto__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_cad_unidade_ligacao_esgoto__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_cad_unidade_ligacao_esgoto__dbt_tmp')
    )
  DROP index "dbo_mig"."cad_unidade_ligacao_esgoto__dbt_tmp".dbo_mig_cad_unidade_ligacao_esgoto__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_cad_unidade_ligacao_esgoto__dbt_tmp_cci
    ON "dbo_mig"."cad_unidade_ligacao_esgoto__dbt_tmp"

   

