{{config({
        "materialized": 'table',
        "post-hook": ["{{ create_nonclustered_index(columns = ['ID_CONTA_CORRENTE_MOVIMENTACAO',], ) }}", ]})}}
select * from {{ref('stage_fccm_trunc')}}
-- where cast(cast(DT_MOVIMENTACAO as date) as varchar) <= '2022-11-01'


