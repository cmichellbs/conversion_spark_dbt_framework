
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."tab_percentual_indice_correcao__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."tab_percentual_indice_correcao__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."tab_percentual_indice_correcao__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."tab_percentual_indice_correcao__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."tab_percentual_indice_correcao__dbt_tmp_temp_view" as
    SELECT
coalesce(''2022-01-01'', ''2022-01-01'') as DT_MES_REF,
coalesce(0.0, 0.0) as VL_PERCENTUAL,
''2022-01-01'' as DT_PRIMEIRO_USO,
''STRING'' as NM_ROTINA_PRIMEIRO_USO,
coalesce(''2022-01-01'', ''2022-01-01'') as DT_CADASTRO,
coalesce(8, 8) as CH_INDICE_CORRECAO
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."tab_percentual_indice_correcao__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."tab_percentual_indice_correcao__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."tab_percentual_indice_correcao__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."tab_percentual_indice_correcao__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_tab_percentual_indice_correcao__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_tab_percentual_indice_correcao__dbt_tmp')
    )
  DROP index "dbo_mig"."tab_percentual_indice_correcao__dbt_tmp".dbo_mig_tab_percentual_indice_correcao__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_tab_percentual_indice_correcao__dbt_tmp_cci
    ON "dbo_mig"."tab_percentual_indice_correcao__dbt_tmp"

   

