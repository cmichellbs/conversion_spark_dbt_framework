{{config({
        "materialized": 'table',
        "post-hook": ["{{ create_nonclustered_index(columns = ['ID_ENDERECO_UNIDADE',], ) }}", ]})}}

with final as (

SELECT
*
FROM

{{ref('stage_ceuc_1')}}


union all


SELECT
*
FROM

{{ref('stage_ceuc_2')}})



select *,ROW_NUMBER() OVER(ORDER BY CH_MATRICULA_UNIDADE) AS ID_ENDERECO_UNIDADE
 from final