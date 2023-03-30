
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."stage_loc_adj2__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."stage_loc_adj2__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."stage_loc_adj2__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."stage_loc_adj2__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."stage_loc_adj2__dbt_tmp_temp_view" as
    with CTE AS (SELECT DISTINCT x.*,ROW_NUMBER() OVER(PARTITION BY x.SEQNO ORDER BY x.road_name DESC) AS RN FROM "papakura_20221223"."dbo_mig"."LOCADDRESS_ADJ" x
)

,LOCADDRESS_ADJ2 AS(SELECT * FROM CTE WHERE RN = 1)

select * from LOCADDRESS_ADJ2
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."stage_loc_adj2__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."stage_loc_adj2__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."stage_loc_adj2__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."stage_loc_adj2__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_stage_loc_adj2__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_stage_loc_adj2__dbt_tmp')
    )
  DROP index "dbo_mig"."stage_loc_adj2__dbt_tmp".dbo_mig_stage_loc_adj2__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_stage_loc_adj2__dbt_tmp_cci
    ON "dbo_mig"."stage_loc_adj2__dbt_tmp"

   

