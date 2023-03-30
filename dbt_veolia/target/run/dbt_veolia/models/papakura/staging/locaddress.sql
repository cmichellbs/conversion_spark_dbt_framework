
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."locaddress__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."locaddress__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."locaddress__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."locaddress__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."locaddress__dbt_tmp_temp_view" as
    WITH LOCADDRESS AS (SELECT * FROM"papakura_20221223"."dbo"."LOCADDRESS" where LOCA_ITEMID  IN (SELECT INSTALL FROM "papakura_20221223"."dbo"."INSTALL"))
    select *, 
    row_number() over(partition by LOCA_ITEMID order by SEQNO DESC) as id  
    from LOCADDRESS
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."locaddress__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."locaddress__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."locaddress__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."locaddress__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_locaddress__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_locaddress__dbt_tmp')
    )
  DROP index "dbo_mig"."locaddress__dbt_tmp".dbo_mig_locaddress__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_locaddress__dbt_tmp_cci
    ON "dbo_mig"."locaddress__dbt_tmp"

   

