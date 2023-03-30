SELECT
ROW_NUMBER() OVER(ORDER BY BANKNO) +20 as ID_AGENTE_ARRECADADOR,
RIGHT('000'+CAST(BANKNO AS VARCHAR),2) as CD_AGENTE_ARRECADADOR,
CONCAT(RIGHT('000'+CAST(BANKNO AS VARCHAR),2),' - ',coalesce(BSBBLONG, 'BANK_WITHOUT_NAME')) as NM_AGENTE_ARRECADADOR,
1 as CH_ATIVO,
2 as CH_TIPO_AGENTE_ARRECADADOR,
'STRING' as NU_CNPJ,
BSBBSHORT as abrev,
RIGHT('000'+CAST(BANKNO AS VARCHAR),2) as COD_BANCO
FROM

{{source('papakura','BSBBANKS')}}