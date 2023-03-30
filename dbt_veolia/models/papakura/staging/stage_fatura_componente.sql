with componentes as (SELECT
COD_FATURA,
SUM(CAST(VL_AGUA_CPTE_FATURA AS DECIMAL(16,2))) as VL_AGUA_CPTE_FATURA,
SUM(CAST(VL_ESGOTO_CPTE_FATURA AS DECIMAL(16,2))) as VL_ESGOTO_CPTE_FATURA,
SUM(CAST(VL_CONSUMO_CPTE_FATURA AS integer)) as VL_CONSUMO_CPTE_FATURA,
SUM(CAST(VL_CONSUMO_ESGOTO_CPTE_FATURA AS integer)) as VL_CONSUMO_ESGOTO_CPTE_FATURA
FROM {{ref('stage_fat_fatura_componente2')}} ffc 
GROUP BY COD_FATURA)

select * from componentes