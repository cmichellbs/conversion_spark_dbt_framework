with INTERM as (select ce.*, row_number() over(partition by ce.CH_MATRICULA_UNIDADE order by ce.SEQ DESC ) AS RN from "papakura_20221223"."dbo_mig"."cad_economia" ce)

SELECT * FROM INTERM WHERE RN = 1