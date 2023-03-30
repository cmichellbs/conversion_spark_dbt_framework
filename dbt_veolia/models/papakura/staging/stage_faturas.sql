SELECT *,
cast(concat(year(fat.GBIDATE),concat('-',concat(month(fat.GBIDATE),concat('-',01)))) as date) as DT_MESANO_REF
FROM {{source('papakura','GBINVOICE')}} fat
-- where GBISTATEMENT_NO is not null
-- where GBIINSTALL = 11000123