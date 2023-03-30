with CTE AS (SELECT
cast(concat(year(FCF.DT_CALENDARIO_MESANO_REF),concat('-',concat(month(FCF.DT_CALENDARIO_MESANO_REF),concat('-',01)))) as date)  as DATA_ESTAGIO,
1 as ID_ESTAGIO,
FCF.ID_CALENDARIO_FATURAMENTO as ID_CALENDARIO_FATURAMENTO

FROM
"papakura_20221223"."dbo_mig"."fat_calendario_faturamento" FCF

UNION

SELECT
cast(concat(year(FCF.DT_CALENDARIO_MESANO_REF),concat('-',concat(month(FCF.DT_CALENDARIO_MESANO_REF),concat('-',01)))) as date)  as DATA_ESTAGIO,
3 as ID_ESTAGIO,
FCF.ID_CALENDARIO_FATURAMENTO as ID_CALENDARIO_FATURAMENTO

FROM
"papakura_20221223"."dbo_mig"."fat_calendario_faturamento" FCF

UNION

SELECT
cast(concat(year(FCF.DT_CALENDARIO_MESANO_REF),concat('-',concat(month(FCF.DT_CALENDARIO_MESANO_REF),concat('-',02)))) as date)  as DATA_ESTAGIO,
4 as ID_ESTAGIO,
FCF.ID_CALENDARIO_FATURAMENTO as ID_CALENDARIO_FATURAMENTO

FROM
"papakura_20221223"."dbo_mig"."fat_calendario_faturamento" FCF

UNION

SELECT
cast(concat(year(FCF.DT_CALENDARIO_MESANO_REF),concat('-',concat(month(FCF.DT_CALENDARIO_MESANO_REF),concat('-',02)))) as date)  as DATA_ESTAGIO,
5 as ID_ESTAGIO,
FCF.ID_CALENDARIO_FATURAMENTO as ID_CALENDARIO_FATURAMENTO

FROM
"papakura_20221223"."dbo_mig"."fat_calendario_faturamento" FCF

UNION

SELECT
cast(concat(year(FCF.DT_CALENDARIO_MESANO_REF),concat('-',concat(month(FCF.DT_CALENDARIO_MESANO_REF),concat('-',03)))) as date)  as DATA_ESTAGIO,
6 as ID_ESTAGIO,
FCF.ID_CALENDARIO_FATURAMENTO as ID_CALENDARIO_FATURAMENTO

FROM
"papakura_20221223"."dbo_mig"."fat_calendario_faturamento" FCF)

SELECT *,ROW_NUMBER() OVER(ORDER BY DATA_ESTAGIO)  AS ID_DATA_ESTAGIO FROM CTE