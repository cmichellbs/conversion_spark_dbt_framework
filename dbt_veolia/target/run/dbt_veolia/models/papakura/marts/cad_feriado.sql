
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."cad_feriado__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."cad_feriado__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."cad_feriado__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."cad_feriado__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."cad_feriado__dbt_tmp_temp_view" as
    SELECT
''2022-01-01'' as DT_FERIADO,
coalesce(''Feriado'', ''Feriado'') as NM_FERIADO,
''2022-01-01'' as DT_REGISTRO,
1 AS CH_MUNICIPIO,
1 as CH_ATIVO,
null as CH_TIPO_FERIADO,
28 as  ID_UF
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."cad_feriado__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."cad_feriado__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."cad_feriado__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."cad_feriado__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_cad_feriado__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_cad_feriado__dbt_tmp')
    )
  DROP index "dbo_mig"."cad_feriado__dbt_tmp".dbo_mig_cad_feriado__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_cad_feriado__dbt_tmp_cci
    ON "dbo_mig"."cad_feriado__dbt_tmp"

   

