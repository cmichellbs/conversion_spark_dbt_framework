WITH CONTRACT AS (SELECT ECC.*, ROW_NUMBER() OVER(PARTITION BY ECC.CCON_CONSUMER ORDER BY ECC.CCON_SEQ DESC) RNC FROM EMS_CON_CONTRACT ECC )


,INVOICES AS (SELECT G.GBIINVOICE, G.GBICONSUMER , GC.GBICPLANID ,G.GBIDATE ,ROW_NUMBER() OVER(PARTITION BY G.GBICONSUMER,GC.GBICPLANID ORDER BY G.GBIINVOICE DESC) RN FROM GBINVOICE G
INNER JOIN GBINVOICE#CHARGES GC ON GC.GBIINVOICE = G.GBIINVOICE 
-- WHERE GC.GBICPLANID IS NOT NULL  
)

,BASE AS (SELECT * FROM INVOICES
)

,FINAL AS (
SELECT * FROM BASE
WHERE RN =1
)

,cad_economia as (SELECT
row_number() over(order by c.CH_MATRICULA_UNIDADE) as ID_ECONOMIA,
coalesce(1, 0) as NU_ECONOMIAS,
ECC.CCON_STARTDATE as DT_CADASTRO,
c.CH_CATEGORIA_TARIFA as CH_TIPO_CATEGORIA_TARIFA,
TCTT.ID_CATEGORIA_TIPO_TARIFA as ID_CATEGORIA_TIPO_TARIFA,
CH_MATRICULA_UNIDADE as CH_MATRICULA_UNIDADE,
TTAE.CH_TIPO_ATIVIDADE_ECONOMICA  as CH_TIPO_ATIVIDADE_ECONOMICA,
NULL as CH_TIPO_ATIVIDADE_ECONOMICA_NOVA,
null as ID_CATEGORIA_TIPO_TARIFA_SECUNDARIA,
null as ID_SERVICO,
ECC.CCON_SEQ AS SEQ,
ECC.CCON_CONSUMER as CCON_CONSUMER,
ECC.CCON_PLANID1 AS PLANID,
ECC.CCON_PLANID1 AS MIG_PK_TEMP
from {{ref('stage_cad_unidade_comercial')}} c
inner join {{source('papakura','CONSUMER')}} CA ON CA.CINSTALL = c.CH_MATRICULA_UNIDADE
LEFT JOIN {{source('papakura','EMS_CON_CONTRACT')}} ECC ON ECC.CCON_CONSUMER = CA.CONSUMERNO
left join {{source('papakura','INSTALL')}} INSTALL ON INSTALL.INSTALL = c.CH_MATRICULA_UNIDADE
left JOIN {{ref('tab_tipo_atividade_economica')}} TTAE on TTAE.PLAN_CODE = INSTALL.INZEDCODE
inner JOIN {{ref('tab_categoria_tipo_tarifa')}} TCTT ON TCTT.PLAN_CODE = ECC.CCON_PLANID1)
,ECONOMIA_DIST as (
select CE.*,ROW_NUMBER() OVER(PARTITION BY CE.CH_MATRICULA_UNIDADE ORDER BY CE.SEQ DESC) RNCE,

DATEADD(DAY,-1,LAG(DT_CADASTRO) OVER(PARTITION BY CE.CH_MATRICULA_UNIDADE ORDER BY CE.SEQ DESC)) AS DT_INATIVACAO,
CASE WHEN ROW_NUMBER() OVER(PARTITION BY CE.CH_MATRICULA_UNIDADE ORDER BY CE.SEQ DESC)=1 THEN 1 ELSE 0 END AS CH_ATIVO
from cad_economia CE
-- LEFT JOIN FINAL ON CE.CCON_CONSUMER = FINAL.GBICONSUMER AND FINAL.GBICPLANID = CE.PLANID
)

SELECT * FROM ECONOMIA_DIST
WHERE CH_ATIVO =1