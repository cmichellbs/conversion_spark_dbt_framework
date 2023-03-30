WITH ACCT AS (SELECT * FROM {{source('papakura','ACCOUNTS')}} WHERE ACPARENT IS NOT NULL)


SELECT
row_number() over(PARTITION BY ACCT.ACPARENT order by ACCT.ACCTNO)  as ID_UNIDADE_ORGAO_CENTRALIZADOR,
CDENTRY as DT_INICIO_CENTRALIZACAO,
NULL as DT_FIM_CENTRALIZACAO,
OC.ID_ORGAO_CENTRALIZADOR as ID_ORGAO_CENTRALIZADOR,
1 as CH_ATIVO,
CONS.CINSTALL as CH_MATRICULA_UNIDADE

FROM ACCT
inner JOIN {{source('papakura','CONSUMER')}} CONS ON CONS.CACCT = ACCT.ACCTNO

inner JOIN {{ref('cad_orgao_centralizador')}} OC ON OC.CH_CLIENTE = ACCT.ACPARENT