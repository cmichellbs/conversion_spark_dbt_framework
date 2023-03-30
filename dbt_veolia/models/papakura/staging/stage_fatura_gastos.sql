with gastos2 as (select 
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
-- WHERE GBC.GBICCHARGE IS NOT NULL AND TARCHARGE.TARC$CODE IN (SELECT TARC$CODE  FROM TARCHARGE
-- WHERE TARC$CODE  IN(select DISTINCT T.TARC$CODE from EMS_CON_PLAN#REGISTER_LIST ECPRL
-- INNER JOIN TARCHARGE T ON T.TARC$CODE = ECPRL.ECPLAN_TARCODE))
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


select * from gastos