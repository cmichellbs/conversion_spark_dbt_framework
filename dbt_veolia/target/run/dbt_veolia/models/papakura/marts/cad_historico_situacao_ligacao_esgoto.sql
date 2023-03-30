
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."cad_historico_situacao_ligacao_esgoto__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."cad_historico_situacao_ligacao_esgoto__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."cad_historico_situacao_ligacao_esgoto__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."cad_historico_situacao_ligacao_esgoto__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."cad_historico_situacao_ligacao_esgoto__dbt_tmp_temp_view" as
    SELECT
row_number() over(order by cule.CH_SITUACAO_LIGACAO_ESGOTO) as ID_HISTORICO_SITUACAO_LIGACAO_ESGOTO,
cule.CH_SITUACAO_LIGACAO_ESGOTO as ID_SITUACAO_ATUAL_LIGACAO,
cule.CH_SITUACAO_LIGACAO_ESGOTO as ID_SITUACAO_ANTERIOR_LIGACAO,
cule.DT_SITUACAO_LIGACAO_ESGOTO as DT_SITUACAO_ANTERIOR_LIGACAO,
cule.DT_SITUACAO_LIGACAO_ESGOTO as DT_SITUACAO_ATUAL_LIGACAO,
getdate() as DT_GRAVACAO_HISTORICO,
cule.ID_UNIDADE_LIGACAO_ESGOTO as ID_UNIDADE_LIGACAO_ESGOTO,
null as ID_SERVICO
FROM
"papakura_20221223"."dbo_mig"."cad_unidade_ligacao_esgoto" cule
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."cad_historico_situacao_ligacao_esgoto__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."cad_historico_situacao_ligacao_esgoto__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."cad_historico_situacao_ligacao_esgoto__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."cad_historico_situacao_ligacao_esgoto__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_cad_historico_situacao_ligacao_esgoto__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_cad_historico_situacao_ligacao_esgoto__dbt_tmp')
    )
  DROP index "dbo_mig"."cad_historico_situacao_ligacao_esgoto__dbt_tmp".dbo_mig_cad_historico_situacao_ligacao_esgoto__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_cad_historico_situacao_ligacao_esgoto__dbt_tmp_cci
    ON "dbo_mig"."cad_historico_situacao_ligacao_esgoto__dbt_tmp"

   

