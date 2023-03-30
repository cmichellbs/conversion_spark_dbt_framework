{{config({
        "materialized": 'table',
        "post-hook": ["{{ create_nonclustered_index(columns = ['ID_FECHAMENTOS',], ) }}", ]})}}


WITH REFERENCIAS AS (SELECT DISTINCT DT_MESANO_REF FROM {{ref('stage_fat_fatura')}} fat)

,final as(
SELECT
DT_MESANO_REF as MES_REFERENCIA,
DATEADD(MONTH,1,DT_MESANO_REF) as DT_REAL_FECHAMENTO,
CASE WHEN DATEDIFF(month,DT_MESANO_REF,cast(concat(year(GETDATE()),concat('-',concat(month(GETDATE()),concat('-',01)))) as date)) = 0
THEN 'N' ELSE 'S' end as FL_FECHAMENTO_REALIZADO,
NULL as NR_ESTAGIO,
3 as CH_PROCESSO,
'S' as MIG_PK_TEMP,
'S' as ORIGEM_MIG

FROM
REFERENCIAS

union ALL

SELECT
DT_MESANO_REF as MES_REFERENCIA,
DATEADD(MONTH,1,DT_MESANO_REF) as DT_REAL_FECHAMENTO,
CASE WHEN DATEDIFF(month,DT_MESANO_REF,cast(concat(year(GETDATE()),concat('-',concat(month(GETDATE()),concat('-',01)))) as date)) = 0
THEN 'N' ELSE 'S' end as FL_FECHAMENTO_REALIZADO,
NULL as NR_ESTAGIO,
4 as CH_PROCESSO,
'S' as MIG_PK_TEMP,
'S' as ORIGEM_MIG

FROM
REFERENCIAS



union ALL

SELECT

DT_MESANO_REF as MES_REFERENCIA,
DATEADD(MONTH,1,DT_MESANO_REF) as DT_REAL_FECHAMENTO,
CASE WHEN DATEDIFF(month,DT_MESANO_REF,cast(concat(year(GETDATE()),concat('-',concat(month(GETDATE()),concat('-',01)))) as date)) = 0
THEN 'N' ELSE 'S' end as FL_FECHAMENTO_REALIZADO,
NULL as NR_ESTAGIO,
30 as CH_PROCESSO,
'S' as MIG_PK_TEMP,
'S' as ORIGEM_MIG

FROM
REFERENCIAS
)

select *,ROW_NUMBER() OVER(ORDER BY MES_REFERENCIA asc, CH_PROCESSO ASC) as ID_FECHAMENTOS from final