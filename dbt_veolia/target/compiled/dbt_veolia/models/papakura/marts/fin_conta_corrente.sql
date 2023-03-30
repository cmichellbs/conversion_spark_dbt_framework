with base as (select *, row_number() over(partition by id_conta_corrente order by nr_sequencial_registro desc) rn from "papakura_20221223"."dbo_mig"."fin_conta_corrente_movimentacao" fccm)

,silver as (select * from base where rn =1)


, MOV AS (SELECT * from silver )



,CTC AS (SELECT
L.LEDGERID as ID_CONTA_CORRENTE,
coalesce(CONS.CDENTRY, getdate()) as DT_CRIACAO,
coalesce(CONS.CINSTALL, 0) as CH_MATRICULA_UNIDADE,
coalesce(L.LEDGERID, 0) as CH_CLIENTE,
case WHEN CONS.CSTATUSTYPE = 30 THEN 40960001 ELSE 40960002 END as CH_SITUACAO_CONTA_CORRENTE,
MOV.ID_CONTA_CORRENTE_MOVIMENTACAO as ID_CONTA_CORRENTE_MOVIMENTACAO,
coalesce(L.LEDGERID, 0) as NR_CONTA_CORRENTE,
dbo.Modulo11(L.LEDGERID) as DIGITO_CONTA_CORRENTE,
ROW_NUMBER() OVER(PARTITION BY L.LEDGERID ORDER BY CONS.CONSUMERNO DESC) AS RN
FROM
"papakura_20221223"."dbo"."LEDGER" L
left JOIN MOV ON MOV.LEDGERID = L.LEDGERID

inner JOIN "papakura_20221223"."dbo"."CONSUMER" CONS ON L.LEDGERID = CONS.CACCT)


,final as(SELECT CTC.*
-- ,row_number() over(partition by CTC.ID_CONTA_CORRENTE order by CTC.ID_CONTA_CORRENTE,CTC.DT_CRIACAO desc)  as linha 
FROM CTC 
WHERE RN = 1
)

select * FROM final