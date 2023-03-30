
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."tab_posicao_cavalete__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."tab_posicao_cavalete__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."tab_posicao_cavalete__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."tab_posicao_cavalete__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."tab_posicao_cavalete__dbt_tmp_temp_view" as
    SELECT
row_number() over(order by CODE asc) +10   as CH_POSICAO_CAVALETE,
coalesce(DESCRIPTION, ''STRING'') as NM_POSICAO_CAVALETE,
1 as CH_ATIVO,
CODE AS position,
CODE AS MIG_POSICAO_TEMP

FROM

"papakura_20221223"."dbo"."EMS_LOCATION_CODE"
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."tab_posicao_cavalete__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."tab_posicao_cavalete__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."tab_posicao_cavalete__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."tab_posicao_cavalete__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_tab_posicao_cavalete__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_tab_posicao_cavalete__dbt_tmp')
    )
  DROP index "dbo_mig"."tab_posicao_cavalete__dbt_tmp".dbo_mig_tab_posicao_cavalete__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_tab_posicao_cavalete__dbt_tmp_cci
    ON "dbo_mig"."tab_posicao_cavalete__dbt_tmp"

   

