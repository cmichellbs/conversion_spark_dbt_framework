
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."ope_setor_operacional__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."ope_setor_operacional__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."ope_setor_operacional__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."ope_setor_operacional__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."ope_setor_operacional__dbt_tmp_temp_view" as
    SELECT
99 as CH_SETOR_OPERACIONAL,
''ALL'' as NM_SETOR_OPERACIONAL,
null as FL_UTILIZA_MATERIAL_ESTOQUE,
null as FL_MOBILE,
0 as TM_HORAS_LIMITE_ENCERRAMENTO,
1 as CH_ATIVO,
null as ID_USUARIO
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."ope_setor_operacional__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."ope_setor_operacional__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."ope_setor_operacional__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."ope_setor_operacional__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_ope_setor_operacional__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_ope_setor_operacional__dbt_tmp')
    )
  DROP index "dbo_mig"."ope_setor_operacional__dbt_tmp".dbo_mig_ope_setor_operacional__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_ope_setor_operacional__dbt_tmp_cci
    ON "dbo_mig"."ope_setor_operacional__dbt_tmp"

   

