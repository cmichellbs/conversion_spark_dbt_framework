
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."stage_ceuc_consumer__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."stage_ceuc_consumer__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."stage_ceuc_consumer__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."stage_ceuc_consumer__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."stage_ceuc_consumer__dbt_tmp_temp_view" as
    with 
CONSUMER_INTERM as (
    select *, 
    ROW_NUMBER() OVER(PARTITION BY CONS.CINSTALL ORDER BY CONS.CONSUMERNO) AS RN 
    from  "papakura_20221223"."dbo"."CONSUMER" CONS)
,CONSUMER_FINAL_INTERM AS (SELECT * FROM CONSUMER_INTERM WHERE RN =1)

,CONSUMER_FINAL_INTERM2 AS (SELECT C.CONSUMERNO, C.CINSTALL, C.CACCT,L.LOCA_ITEMID,L2.LOCA_ITEMID as LOCA_ITEMID2, CASE WHEN L.full_road_name2 = L2.full_road_name2 THEN 0 
ELSE 1 END AS HAS_ALT

FROM CONSUMER_FINAL_INTERM C
LEFT JOIN "papakura_20221223"."dbo_mig"."stage_loc_adj_adj" L ON L.LOCA_ITEMID  = C.CINSTALL
LEFT JOIN "papakura_20221223"."dbo_mig"."stage_loc_adj_adj" L2 ON L2.LOCA_ITEMID  = C.CACCT)

,CONSUMER_FINAL AS (SELECT * FROM CONSUMER_FINAL_INTERM2 WHERE HAS_ALT = 1)


select * from CONSUMER_FINAL
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."stage_ceuc_consumer__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."stage_ceuc_consumer__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."stage_ceuc_consumer__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."stage_ceuc_consumer__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_stage_ceuc_consumer__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_stage_ceuc_consumer__dbt_tmp')
    )
  DROP index "dbo_mig"."stage_ceuc_consumer__dbt_tmp".dbo_mig_stage_ceuc_consumer__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_stage_ceuc_consumer__dbt_tmp_cci
    ON "dbo_mig"."stage_ceuc_consumer__dbt_tmp"

   

