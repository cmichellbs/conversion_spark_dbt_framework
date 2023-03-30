WITH LOCADDRESS AS (SELECT * FROM"papakura_20221223"."dbo"."LOCADDRESS" where LOCA_ITEMID  IN (SELECT INSTALL FROM "papakura_20221223"."dbo"."INSTALL"))
    select *, 
    row_number() over(partition by LOCA_ITEMID order by SEQNO DESC) as id  
    from LOCADDRESS