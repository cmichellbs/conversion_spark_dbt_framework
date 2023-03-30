{{config({
        "materialized": 'table',
        "post-hook": ["{{ create_nonclustered_index(columns = ['ID_DIA_VENCIMENTO_ALTERNATIVO',], ) }}", ]})}}
SELECT
row_number() over(order by fgf.ID_GRUPO_FATURAMENTO) as ID_DIA_VENCIMENTO_ALTERNATIVO,
0 as DT_DIA,
1 as PRIORIDADE,
1 as CH_ATIVO,
fgf.ID_GRUPO_FATURAMENTO as ID_GRUPO_FATURAMENTO,

'S' as MIG_FL_TEMP
FROM
{{ref('fat_grupo_faturamento')}} fgf
