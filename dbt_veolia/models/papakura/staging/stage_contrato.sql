WITH CONTRATO_INTER AS (SELECT *, ROW_NUMBER() OVER(PARTITION BY CCON_CONSUMER ORDER BY CCON_SEQ DESC) RN FROM {{source('papakura','EMS_CON_CONTRACT')}})

,CONTRATO_FINAL AS (SELECT * FROM CONTRATO_INTER WHERE RN =1)

SELECT * FROM CONTRATO_FINAL