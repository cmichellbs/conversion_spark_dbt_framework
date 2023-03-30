
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."LOCADDRESS_ADJ__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."LOCADDRESS_ADJ__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."LOCADDRESS_ADJ__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."LOCADDRESS_ADJ__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."LOCADDRESS_ADJ__dbt_tmp_temp_view" as
    SELECT L.*,
       LBM.LOC_BEST_MATCH3,
       NFA.full_road_name,
       NFA.road_name,
       NFA.road_name_type_value,
       NFA.road_name_type_abbrev,
       concat(NFA.road_name,'' '',NFA.road_name_type_abbrev) road_name_label,
       NFA.full_road_name AS full_road_name2,
       NFA.suburb,
       NFA.town
FROM "papakura_20221223"."dbo"."LOCADDRESS" L
LEFT JOIN "papakura_20221223"."dbo"."loc_best_match" LBM ON LBM.SEQNO = L.SEQNO
left JOIN "papakura_20221223"."dbo"."nz_full_address" NFA ON NFA.full_road_name = LBM.LOC_BEST_MATCH3
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."LOCADDRESS_ADJ__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."LOCADDRESS_ADJ__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."LOCADDRESS_ADJ__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."LOCADDRESS_ADJ__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_LOCADDRESS_ADJ__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_LOCADDRESS_ADJ__dbt_tmp')
    )
  DROP index "dbo_mig"."LOCADDRESS_ADJ__dbt_tmp".dbo_mig_LOCADDRESS_ADJ__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_LOCADDRESS_ADJ__dbt_tmp_cci
    ON "dbo_mig"."LOCADDRESS_ADJ__dbt_tmp"

   

