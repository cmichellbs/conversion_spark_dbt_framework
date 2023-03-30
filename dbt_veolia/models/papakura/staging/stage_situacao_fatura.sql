with 


BASE AS (
select b.* from {{ref('stage_final_neg_fat')}} b
)

,SITUACAO AS (SELECT *, 


CASE 
    WHEN REVERSED =1 or cancelado =1 THEN 3 
    when  STATUS_PAGO =1 and REVERSED <> 1 and  cancelado <>1  THEN 2
    ELSE 1 END AS CH_SITUACAO_FATURA


FROM BASE)

select * from SITUACAO