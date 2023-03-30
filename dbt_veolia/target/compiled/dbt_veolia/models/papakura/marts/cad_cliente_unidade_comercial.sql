-- ROW ID_CLIENTE_UNIDADE_COMERCIAL



SELECT
CONS.CDFINAL as DT_VALIDADE,
CASE WHEN ROW_NUMBER() OVER(PARTITION BY CONS.CINSTALL ORDER BY CONS.CONSUMERNO DESC) = 1 THEN 1 ELSE 0 END as CH_ATIVO,
CONS.CACCT as CH_CLIENTE,
2 as CH_TIPO_CLIENTE,
CONS.CINSTALL as CH_MATRICULA_UNIDADE,
null as ID_SERVICO,
CONCAT('CONSUMER NO. ',CAST(CONS.CONSUMERNO AS VARCHAR)) as NM_IDENTIFICACAO_UNIDADE,
cast(0 as BIT) as FL_PREFERENCIAL,
CONS.CONSUMERNO as MIG_PK_TEMP,
CONS.CSTATUSTYPE AS MIG_STATUSTYPE_TEMP
FROM "papakura_20221223"."dbo"."CONSUMER" CONS

UNION ALL

SELECT
CONS.CDFINAL as DT_VALIDADE,
CASE WHEN ROW_NUMBER() OVER(PARTITION BY CONS.CINSTALL ORDER BY CONS.CONSUMERNO DESC) = 1 THEN 1 ELSE 0 END as CH_ATIVO,
CONS.CACCT as CH_CLIENTE,
1 as CH_TIPO_CLIENTE,
CONS.CINSTALL as CH_MATRICULA_UNIDADE,
null as ID_SERVICO,
CONCAT('CONSUMER NO. ',CAST(CONS.CONSUMERNO AS VARCHAR)) as NM_IDENTIFICACAO_UNIDADE,
cast(0 as BIT) as FL_PREFERENCIAL,
CONS.CONSUMERNO as MIG_PK_TEMP,
CONS.CSTATUSTYPE AS MIG_STATUSTYPE_TEMP

FROM "papakura_20221223"."dbo"."CONSUMER" CONS