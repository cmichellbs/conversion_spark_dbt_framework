WITH LOCADDRESS AS (SELECT * FROM{{source('papakura','LOCADDRESS')}} where LOCA_ITEMID  IN (SELECT INSTALL FROM {{source('papakura','INSTALL')}}))
    select *, 
    row_number() over(partition by LOCA_ITEMID order by SEQNO DESC) as id  
    from LOCADDRESS

