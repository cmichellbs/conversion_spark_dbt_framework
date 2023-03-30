WITH ROTA_INTERM AS (SELECT RSD$INSTALL as CH_MATRICULA_UNIDADE, CAST(case 
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

),2)) as integer) AS READSEQ,
CASE WHEN RSD$KEYNUM IS NULL THEN cast(0001 as varchar)
ELSE cast(replace(replace(cast(RSD$KEYNUM as varchar),'o','0'),'O','0') as varchar) END AS SEQUENCIA

FROM GBREADSEQ GRS)

,ROTA_FINAL AS (SELECT RI.*, 

CAST(CONCAT(CAST(RIGHT(CONCAT('00000',READSEQ),4) AS VARCHAR),'.',CAST(RIGHT(CONCAT('000000',cast(SEQUENCIA as varchar)),6)AS VARCHAR) ) AS VARCHAR) AS SEQUENCIA_COMPLETA

FROM ROTA_INTERM RI)



SELECT
row_number() over(order by ROTA_FINAL.SEQUENCIA) as ID_ROTA_LEITURA_AGUA_SEQUENCIA,
21140001 as CH_TIPO_ROTA_LEITURA_AGUA,
ROTA_FINAL.SEQUENCIA as NR_SEQUENCIA,
ROTA_FINAL.SEQUENCIA_COMPLETA as NR_SEQUENCIA_COMPLETA,
CASE WHEN ROTA_FINAL.GPFAT = 99 THEN cast(0 as BIT) ELSE cast(1 as BIT) END as FL_ATIVO,
coalesce(NULL, CAST(GETDATE() AS DATE)) as DT_CADASTRO,
CASE WHEN GPFAT = 99 THEN CAST(GETDATE() AS DATE) ELSE NULL END as DT_INATIVACAO,
MRLA.ID_ROTA_LEITURA_AGUA as ID_ROTA_LEITURA_AGUA,
NULL as ID_FONTE_AGUA,
ROTA_FINAL.CH_MATRICULA_UNIDADE as CH_MATRICULA_UNIDADE

FROM ROTA_FINAL
LEFT JOIN {{ref('med_rota_leitura_agua')}} MRLA ON MRLA.READSEQ = ROTA_FINAL.READSEQ
