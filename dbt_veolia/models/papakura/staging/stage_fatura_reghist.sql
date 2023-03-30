with REGHIST AS (SELECT g.*,g2.GBB$METERSERIAL AS SERIAL FROM {{source('papakura','GBREGISTER')}}  g 
LEFT JOIN {{source('papakura','GBBILLREG')}}  g2 ON g2.GBB$REGKEY = g.GBR$BREGKEY )

select * from REGHIST