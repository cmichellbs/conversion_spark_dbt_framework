
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."tab_tarifa_servico_definicao__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."tab_tarifa_servico_definicao__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."tab_tarifa_servico_definicao__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."tab_tarifa_servico_definicao__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."tab_tarifa_servico_definicao__dbt_tmp_temp_view" as
    WITH ECC AS (
SELECT 
    ECC.*  FROM "papakura_20221223"."dbo"."EMS_CON_PLAN" ECC
WHERE  ECC.ECPLAN_KEY IN (SELECT DISTINCT ECPLAN_KEY FROM  "papakura_20221223"."dbo"."EMS_CON_PLAN#FIXED_LIST"))

,TCHARGE AS (SELECT TC.*,

CASE 
	WHEN TC.TARC$CODE       NOT 
	IN (SELECT DISTINCT CRAT$CODE FROM TARRATE)
	THEN TC.TARC$TEMPLATE ELSE TC.TARC$CODE 
END AS TARC$CODE2
FROM TARCHARGE TC
)
,TR AS (
SELECT 
CRAT$CODE,
CRAT$DATE inicio,  
DATEADD(DAY,-1,COALESCE(LAG(CRAT$DATE,1) OVER(PARTITION BY CRAT$CODE ORDER BY CRAT$DATE DESC),DATEADD(YEAR,1,CRAT$DATE))) fim,
t.CRAT$RATE  
FROM TARRATE t)

, RATES AS (
SELECT TC.TARC$CODE,TC.TARC$CODE2,TR.* FROM TCHARGE TC
INNER JOIN TR ON TR.CRAT$CODE = TC.TARC$CODE2

)

,FINAL AS(
    
SELECT
coalesce(cast(TR.CRAT$RATE/1000000 as decimal(16,2)), 0.0) as VL_SERVICO_TARIFA,
cast(1 as BIT) as FL_MULTIPLICAR_ECONOMIA,
cast(1 as BIT) as FL_VALOR_DIARIO,
TSD.ID_SERVICO_DEFINICAO as ID_SERVICO_DEFINICAO,
TT.ID_TARIFA as ID_TARIFA,
TR.inicio,
TR.fim,
TR.CRAT$CODE as CHARGE,
ECC.ECPLAN_KEY AS MIG_PLANO_TEMP
from ECC
inner JOIN  "papakura_20221223"."dbo"."EMS_CON_PLAN#FIXED_LIST" ECPFL ON ECPFL.ECPLAN_KEY = ECC.ECPLAN_KEY 
LEFT JOIN "papakura_20221223"."dbo_mig"."tab_tarifa" TT on TT.MIG_PLAN_CODE_TEMP = ECC.ECPLAN_KEY
LEFT JOIN "papakura_20221223"."dbo_mig"."tab_tabela_tarifaria" TTT on TT.ID_TABELA_TARIFARIA = TTT.ID_TABELA_TARIFARIA
inner JOIN RATES TR ON TR.TARC$CODE = ECPFL.ECPLAN_FCHGCODE  AND (inicio >= TTT.DT_INICIO_VIGENCIA AND fim <= TTT.DT_FIM_VIGENCIA)
left join "papakura_20221223"."dbo_mig"."tab_servico_definicao" TSD ON TSD.MIG_GL_ID_TEMP = ECPFL.ECPLAN_FCHGCODE AND TSD.MIG_SERVICO_TABELADO_TEMP =''N''
)

,TTSD AS (SELECT DISTINCT * FROM FINAL)

SELECT ROW_NUMBER() OVER(ORDER BY ID_TARIFA) as ID_TARIFA_SERVICO_DEFINICAO,
* FROM TTSD
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."tab_tarifa_servico_definicao__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."tab_tarifa_servico_definicao__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."tab_tarifa_servico_definicao__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."tab_tarifa_servico_definicao__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_tab_tarifa_servico_definicao__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_tab_tarifa_servico_definicao__dbt_tmp')
    )
  DROP index "dbo_mig"."tab_tarifa_servico_definicao__dbt_tmp".dbo_mig_tab_tarifa_servico_definicao__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_tab_tarifa_servico_definicao__dbt_tmp_cci
    ON "dbo_mig"."tab_tarifa_servico_definicao__dbt_tmp"

   
