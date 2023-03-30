SELECT
cast(case when substring(seqno,1,3) = '000' then 001 
when substring(seqno,1,3) = 'HOL' then 099 
else substring(seqno,1,3) end as integer) as ID_GRUPO_FATURAMENTO,
ID_LOCALIZACAO as ID_LOCALIZACAO,
3 as CH_TIPO_COLETA_LEITURA
from 
"papakura_20221223"."dbo_mig"."tab_localizacao"