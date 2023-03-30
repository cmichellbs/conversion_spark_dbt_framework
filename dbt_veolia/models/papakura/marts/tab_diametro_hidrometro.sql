with dist as (select distinct MUKEY  ,MUDESC from {{source('papakura','EMS_MUSE')}})

SELECT
ROW_NUMBER() over(order by  MUKEY) + 100 as CH_DIAMETRO_HIDROMETRO,
coalesce(MUDESC, 'STRING') as NM_DIAMETRO_HIDROMETRO,
1 as CH_ATIVO,
MUKEY AS DIAMETRO,
MUKEY AS MIG_DIAMETRO_TEMP

from dist