
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."cad_endereco_unidade__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."cad_endereco_unidade__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."cad_endereco_unidade__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."cad_endereco_unidade__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."cad_endereco_unidade__dbt_tmp_temp_view" as
    

with final as (

SELECT
*
FROM

"papakura_20221223"."dbo_mig"."stage_ceuc_1"


union all


SELECT
*
FROM

"papakura_20221223"."dbo_mig"."stage_ceuc_2")



select *,ROW_NUMBER() OVER(ORDER BY CH_MATRICULA_UNIDADE) AS ID_ENDERECO_UNIDADE
 from final
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."cad_endereco_unidade__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."cad_endereco_unidade__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."cad_endereco_unidade__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."cad_endereco_unidade__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_cad_endereco_unidade__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_cad_endereco_unidade__dbt_tmp')
    )
  DROP index "dbo_mig"."cad_endereco_unidade__dbt_tmp".dbo_mig_cad_endereco_unidade__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_cad_endereco_unidade__dbt_tmp_cci
    ON "dbo_mig"."cad_endereco_unidade__dbt_tmp"

   

