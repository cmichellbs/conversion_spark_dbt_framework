
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."ope_equipe__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."ope_equipe__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."ope_equipe__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."ope_equipe__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."ope_equipe__dbt_tmp_temp_view" as
    SELECT
99 as ID_EQUIPE,
''DEFAULT'' as CD_EQUIPE,
''DEFAULT'' as NM_LOGIN,
null as NM_SENHA,
null as NM_SENHA2,
''2022-01-01'' as DT_CADASTRO_EQUIPE,
null as CH_TIPO_EQUIPE,
1 as CH_ATIVO,
null as ID_EMPREITEIRA,
null as QT_MINIMA_FUNCIONARIOS,
null as QT_MAXIMA_FUNCIONARIOS,
null as ID_EQUIPE_PERIODO
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."ope_equipe__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."ope_equipe__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."ope_equipe__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."ope_equipe__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_ope_equipe__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_ope_equipe__dbt_tmp')
    )
  DROP index "dbo_mig"."ope_equipe__dbt_tmp".dbo_mig_ope_equipe__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_ope_equipe__dbt_tmp_cci
    ON "dbo_mig"."ope_equipe__dbt_tmp"

   

