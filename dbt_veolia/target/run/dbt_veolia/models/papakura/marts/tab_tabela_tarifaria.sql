
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."tab_tabela_tarifaria__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."tab_tabela_tarifaria__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."tab_tabela_tarifaria__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."tab_tabela_tarifaria__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."tab_tabela_tarifaria__dbt_tmp_temp_view" as
    with INTERM1 as (SELECT DISTINCT CRAT$DATE FROM "papakura_20221223"."dbo"."TARRATE")

,WAT AS (SELECT * FROM "papakura_20221223"."dbo"."TARRATE" WHERE CRAT$CODE = ''WVOL'')
,INTERM2 AS (SELECT INTERM1.*,ROW_NUMBER() OVER(ORDER BY CRAT$DATE ASC) AS RN FROM INTERM1)

,INTERM3 AS (SELECT T1.CRAT$DATE AS _FROM, T2.CRAT$DATE AS _TO
FROM INTERM2 T1
LEFT JOIN INTERM2 T2 ON T1.RN = (T2.RN -1))

,FINAL AS (SELECT _FROM, 
CASE 
	WHEN _TO IS NULL THEN DATEADD(DAY,-1,DATEADD(YEAR,1,_FROM)) ELSE _TO
END AS _TO,
WAT.CRAT$RATE/1000000 AS TARIFA
FROM INTERM3

LEFT JOIN WAT ON WAT.CRAT$DATE = INTERM3._FROM)


SELECT
row_number() over(order by _FROM) as ID_TABELA_TARIFARIA,
CONCAT(YEAR(_FROM),''/'',YEAR(_TO))as NM_TABELA_TARIFARIA,
 CASE WHEN LAG(_FROM,1) OVER(ORDER BY _FROM  DESC) = _TO THEN DATEADD(day,-1,_TO) ELSE _TO
END as DT_FIM_VIGENCIA,
_FROM as DT_INICIO_VIGENCIA,
coalesce(TARIFA,0) as VL_REFERENCIAL_AGUA,
null as VL_PERCENTUAL_ESGOTO_COLETADO,
null as VL_PERCENTUAL_ESGOTO_TRATADO,
null as FL_GRUPO_PROCESSADO,
100002 as ID_ESTRUTURA_EMPRESA,
21040005 as CH_TIPO_TARIFACAO_MINIMA,
1 as CH_ATIVO,
NULL as FL_COBRAR_ESGOTO_SERVICO_BASICO,
NULL as VL_PERCENTUAL_AGENCIA_REGULADORA,
TSD.ID_SERVICO_DEFINICAO as ID_SERVICO_DEFINICAO,
COALESCE(TR.CRAT$RATE/100,0)/3 AS VL_TARIFA_MINIMA,
TSD2.ID_SERVICO_DEFINICAO as ID_SERVICO_DEFINICAO_TARIFA_MINIMA
FROM FINAL
left join "papakura_20221223"."dbo_mig"."tab_servico_definicao" TSD ON TSD.GL_ID = ''WVOL''
left join "papakura_20221223"."dbo_mig"."tab_servico_definicao" TSD2 ON TSD2.GL_ID = ''MIN''
left join "papakura_20221223"."dbo"."TARRATE" TR ON TR.CRAT$CODE = ''MIN'' AND TR.CRAT$DATE= FINAL._FROM
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."tab_tabela_tarifaria__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."tab_tabela_tarifaria__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."tab_tabela_tarifaria__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."tab_tabela_tarifaria__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_tab_tabela_tarifaria__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_tab_tabela_tarifaria__dbt_tmp')
    )
  DROP index "dbo_mig"."tab_tabela_tarifaria__dbt_tmp".dbo_mig_tab_tabela_tarifaria__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_tab_tabela_tarifaria__dbt_tmp_cci
    ON "dbo_mig"."tab_tabela_tarifaria__dbt_tmp"

   

