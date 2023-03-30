

with AREA AS(SELECT 
DISTINCT CASE WHEN suburb IS NULL THEN 'NOT DEFINED SUBURB' ELSE suburb END AS LOCA_SUBURB_ADJ


 FROM "papakura_20221223"."dbo_mig"."LOCADDRESS_ADJ")

SELECT 
ROW_NUMBER() OVER(ORDER BY LOCA_SUBURB_ADJ) +1 as CH_BAIRRO,
100002 as ID_ESTRUTURA_EMPRESA,
1 AS CH_MUNICIPIO,
1 as CH_ATIVO,
NULL as ID_AGRUPAMENTO_LOCALIZACAO,
UPPER(AREA.LOCA_SUBURB_ADJ) as NM_BAIRRO

FROM AREA 

union ALL

select
9999 as CH_BAIRRO,
100002 as ID_ESTRUTURA_EMPRESA,
1 AS CH_MUNICIPIO,
1 as CH_ATIVO,
NULL as ID_AGRUPAMENTO_LOCALIZACAO,
UPPER('NOT DEFINED SUBURB') as NM_BAIRRO

-- esta é a tabela_bairro