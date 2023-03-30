

with final as (

SELECT
*
FROM

"papakura_20221223"."dbo_mig"."stage_ceuc_1"


union all


SELECT
*
FROM

"papakura_20221223"."dbo_mig"."stage_ceuc_2")



select *,ROW_NUMBER() OVER(ORDER BY CH_MATRICULA_UNIDADE) AS ID_ENDERECO_UNIDADE
 from final