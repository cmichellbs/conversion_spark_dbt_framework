with base as (SELECT

EMREFLEDGER as NR_SERIAL,
coalesce(EMREF1, '') as DS_INFORMACOES,
EMREF2 as CD_ANALISE,
EMREF3 as DS_REFERENCIA,
EMOTHERPARTY as NM_PARTE,
AP.ID_PAGAMENTO as ID_PAGAMENTO,
'S' as MIG_FL_TEMP
FROM
"papakura_20221223"."dbo"."EMS_BANK_XREF" EBX
INNER JOIN "papakura_20221223"."dbo"."DEBT" DEBT ON CONCAT(EMREF1,':',EMREF2,':',EMREF3,':',EMOTHERPARTY) = DEXTDESC
INNER JOIN "papakura_20221223"."dbo_mig"."arr_pagamento" AP ON AP.MIG_DKEY_TEMP = DEBT.DKEY)

select * from base
-- order by ID_PAGAMENTO