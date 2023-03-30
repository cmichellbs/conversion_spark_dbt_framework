SELECT
row_number() over(order by BSBID) + 10 as ID_AGENCIA,
coalesce(BSBBRANCH, 'STRING') as NM_AGENCIA,
RIGHT(CAST(BSBID  AS VARCHAR),4) as CD_AGENCIA,
coalesce(taa.ID_AGENTE_ARRECADADOR, 0) as ID_AGENTE_ARRECADADOR,
1 as CH_ATIVO,
CAST(BSBID  AS VARCHAR) as MIG_CD_AGENCIA_TEMP
FROM
{{source('papakura','EMS_BSB')}} ta

LEFT JOIN {{ref('tab_agente_arrecadador')}} taa on taa.COD_BANCO = CAST(SUBSTRING(ta.BSBID,1,2)  AS VARCHAR)