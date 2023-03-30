SELECT
row_number() over(order by CODE asc) +10   as CH_POSICAO_CAVALETE,
coalesce(DESCRIPTION, 'STRING') as NM_POSICAO_CAVALETE,
1 as CH_ATIVO,
CODE AS position,
CODE AS MIG_POSICAO_TEMP

FROM

{{source('papakura','EMS_LOCATION_CODE')}}