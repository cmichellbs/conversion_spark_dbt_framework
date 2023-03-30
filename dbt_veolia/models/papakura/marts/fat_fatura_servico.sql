{{config({
        "materialized": 'table',
        "post-hook": ["{{ create_nonclustered_index(columns = ['ID_FATURA_SERVICO',], ) }}", ]})}}

SELECT
row_number() over(order by FPSU.ID_PARCELA_SERVICO_UNIDADE) as ID_FATURA_SERVICO,
FPSU.DT_SITUACAO_PARCELA as DT_GRAVACAO_SERVICO_FATURA,
'N' as FL_SERVICO_DOACAO,
'N' as FL_SERVICO_INSUMO,
FF.ID_FATURA as ID_FATURA,
FPSU.ID_PARCELA_SERVICO_UNIDADE as ID_PARCELA_SERVICO_UNIDADE,
FF.NR_FATURA AS MIG_PK_TEMP
FROM 
{{ref('fat_fatura')}} FF
inner join {{ref('fat_parcela_servico_unidade')}}FPSU ON FPSU.MIG_ID_FATURA_TEMP = FF.NR_FATURA
