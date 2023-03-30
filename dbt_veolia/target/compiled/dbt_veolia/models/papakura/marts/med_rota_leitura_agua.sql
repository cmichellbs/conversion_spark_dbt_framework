WITH ROTA AS (SELECT DISTINCT CAST(case 
	when cast(substring(GRS.RSD$READSEQ, 1,3) as varchar) = '000' then '001' 
	when cast(substring(GRS.RSD$READSEQ, 1,3) as varchar) = 'HOL' then '099'
	else cast(substring(GRS.RSD$READSEQ, 1,3) as varchar)
end as integer) AS GPFAT,CAST(CONCAT(
case 
	when cast(substring(GRS.RSD$READSEQ, 1,3) as varchar) = '000' then '001' 
	when cast(substring(GRS.RSD$READSEQ, 1,3) as varchar) = 'HOL' then '099'
	else cast(substring(GRS.RSD$READSEQ, 1,3) as varchar)
end,
RIGHT(CONCAT('0000',case 
	when cast(substring(GRS.RSD$READSEQ, 4,6) as varchar) = '000' then '001' 
	when cast(substring(GRS.RSD$READSEQ, 4,6) as varchar) = 'D' then '099'
	else cast(substring(GRS.RSD$READSEQ, 4,6) as varchar)
end

),2)) as integer) AS READSEQ FROM GBREADSEQ GRS)

SELECT
ROW_NUMBER() OVER(ORDER BY READSEQ) as ID_ROTA_LEITURA_AGUA,
READSEQ as CD_ROTA_LEITURA_AGUA,
CASE 
WHEN GPFAT =1 THEN 'FORMER 000000'
WHEN GPFAT =99 THEN 'FORMER HOLD'
ELSE '' END as DS_OBSERVACAO,
GPFAT as ID_GRUPO_FATURAMENTO,
2 as CH_TIPO_COLETA_LEITURA,
READSEQ as READSEQ,
READSEQ as MIG_READSEQ_TEMP

FROM ROTA