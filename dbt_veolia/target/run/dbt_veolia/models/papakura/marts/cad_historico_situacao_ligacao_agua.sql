
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."cad_historico_situacao_ligacao_agua__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."cad_historico_situacao_ligacao_agua__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."cad_historico_situacao_ligacao_agua__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."cad_historico_situacao_ligacao_agua__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."cad_historico_situacao_ligacao_agua__dbt_tmp_temp_view" as
    SELECT
cula.CH_MOTIVO_SITUACAO_LIGACAO_AGUA as ID_SITUACAO_ANTERIOR_LIGACAO,
cula.CH_MOTIVO_SITUACAO_LIGACAO_AGUA  as ID_SITUACAO_ATUAL_LIGACAO,
cula.DT_SITUACAO_LIGACAO_AGUA as DT_SITUACAO_ANTERIOR_LIGACAO,
cula.DT_SITUACAO_LIGACAO_AGUA as DT_SITUACAO_ATUAL_LIGACAO,
null as NR_LEITURA_SITUACAO_LIGACAO,
cast(GETDATE() as varchar) as DT_GRAVACAO_HISTORICO,
cula.ID_UNIDADE_LIGACAO_AGUA as ID_UNIDADE_LIGACAO_AGUA,
null as ID_SERVICO,
cast(0 as BIT) as FL_RECORTE
from "papakura_20221223"."dbo_mig"."cad_unidade_ligacao_agua" cula
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."cad_historico_situacao_ligacao_agua__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."cad_historico_situacao_ligacao_agua__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."cad_historico_situacao_ligacao_agua__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."cad_historico_situacao_ligacao_agua__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_cad_historico_situacao_ligacao_agua__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_cad_historico_situacao_ligacao_agua__dbt_tmp')
    )
  DROP index "dbo_mig"."cad_historico_situacao_ligacao_agua__dbt_tmp".dbo_mig_cad_historico_situacao_ligacao_agua__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_cad_historico_situacao_ligacao_agua__dbt_tmp_cci
    ON "dbo_mig"."cad_historico_situacao_ligacao_agua__dbt_tmp"

   

