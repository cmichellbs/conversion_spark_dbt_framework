with PAYMENT_ADJ AS (SELECT fcc.id_conta_corrente, fccm.VL_SALDO_ATUAL, row_number() over(partition by fcc.id_conta_corrente order by NR_SEQUENCIAL_REGISTRO desc) RN FROM "papakura_20221223"."dbo_mig"."fin_conta_corrente_movimentacao" fccm
inner join "papakura_20221223"."dbo_mig"."fin_conta_corrente" fcc on fcc.id_conta_corrente = fccm.id_conta_corrente  )

,PAYMENT AS (SELECT * FROM PAYMENT_ADJ WHERE RN = 1)

select * from PAYMENT