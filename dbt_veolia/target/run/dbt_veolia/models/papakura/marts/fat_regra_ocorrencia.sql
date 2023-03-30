
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."fat_regra_ocorrencia__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."fat_regra_ocorrencia__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."fat_regra_ocorrencia__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."fat_regra_ocorrencia__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."fat_regra_ocorrencia__dbt_tmp_temp_view" as
    SELECT
coalesce(''N'', ''STRING'') as FL_EXISTE_LEITURA,
coalesce(1, 0) as CH_TIPO_LEITURA,
null as CH_TIPO_MEDIA,
coalesce(2, 0) as CH_TIPO_CONSUMO_FATURADO,
1 as CH_ATIVO,
coalesce(1, 0) as CH_TIPO_CONSUMO_LIDO,
coalesce(8, 8) as ID_OCORRENCIA_LEITURA
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."fat_regra_ocorrencia__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."fat_regra_ocorrencia__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."fat_regra_ocorrencia__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."fat_regra_ocorrencia__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_fat_regra_ocorrencia__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_fat_regra_ocorrencia__dbt_tmp')
    )
  DROP index "dbo_mig"."fat_regra_ocorrencia__dbt_tmp".dbo_mig_fat_regra_ocorrencia__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_fat_regra_ocorrencia__dbt_tmp_cci
    ON "dbo_mig"."fat_regra_ocorrencia__dbt_tmp"

   

