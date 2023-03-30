{{config({
        "materialized": 'table',
        "post-hook": ["{{ create_nonclustered_index(columns = ['ID_PAGAMENTO_FATURA',], ) }}", ]})}}

SELECT
ROW_NUMBER() OVER(ORDER BY AP.ID_PAGAMENTO) as ID_PAGAMENTO_FATURA,
FF.CH_SITUACAO_FATURA as CH_SITUACAO_FATURA,
FF.ID_FATURA as ID_FATURA,
AP.ID_PAGAMENTO as ID_PAGAMENTO
FROM
{{ref('arr_pagamento')}} AP
inner join {{source('papakura','GBINVOICE')}} GBI on GBI.GBISTATEMENT_NO = AP.MIG_STATEMENT_TEMP
INNER join {{ref('fat_fatura')}} FF on FF.NR_FATURA = GBI.GBIINVOICE