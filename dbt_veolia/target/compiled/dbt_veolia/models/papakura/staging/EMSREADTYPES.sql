SELECT
row_number() over(order by RT$CODE) as CH_TIPO_LEITURA,
cast(RT$DESCRIPTION as varchar) as NM_TIPO_LEITURA,
1 as CH_ATIVO,
RT$CODE as CD_TIPO_LEITURA

from "papakura_20221223"."dbo"."EMSREADTYPES"