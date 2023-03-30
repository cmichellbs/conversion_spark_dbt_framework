
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."tab_diametro_hidrometro__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."tab_diametro_hidrometro__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."tab_diametro_hidrometro__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."tab_diametro_hidrometro__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."tab_diametro_hidrometro__dbt_tmp_temp_view" as
    with dist as (select distinct MUKEY  ,MUDESC from "papakura_20221223"."dbo"."EMS_MUSE")

SELECT
ROW_NUMBER() over(order by  MUKEY) + 100 as CH_DIAMETRO_HIDROMETRO,
coalesce(MUDESC, ''STRING'') as NM_DIAMETRO_HIDROMETRO,
1 as CH_ATIVO,
MUKEY AS DIAMETRO,
MUKEY AS MIG_DIAMETRO_TEMP

from dist
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."tab_diametro_hidrometro__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."tab_diametro_hidrometro__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."tab_diametro_hidrometro__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."tab_diametro_hidrometro__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_tab_diametro_hidrometro__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_tab_diametro_hidrometro__dbt_tmp')
    )
  DROP index "dbo_mig"."tab_diametro_hidrometro__dbt_tmp".dbo_mig_tab_diametro_hidrometro__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_tab_diametro_hidrometro__dbt_tmp_cci
    ON "dbo_mig"."tab_diametro_hidrometro__dbt_tmp"

   

