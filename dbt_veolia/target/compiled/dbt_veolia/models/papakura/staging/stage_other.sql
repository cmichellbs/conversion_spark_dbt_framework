WITH 
OTHER AS (SELECT GBSSTATEMENT, 
SUM(GBSTRAN_AMOUNT) sum_damt
-- 0 sum_damt 

FROM  GBSTATEMENT#TRANS gt 
WHERE GBSTRAN_TRN_TYPE  in (select mig_gbictrn_type_temp from "papakura_20221223"."dbo_mig"."fat_servico_unidade"
where MIG_TARIFA_FIXA_TEMP ='N' and MIG_GBICTRN_TYPE_TEMP not in ('WSERV','MIN')
)
group by GBSSTATEMENT)

select * from OTHER