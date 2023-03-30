
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."fat_unidade_comercial_referencia__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."fat_unidade_comercial_referencia__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."fat_unidade_comercial_referencia__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."fat_unidade_comercial_referencia__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."fat_unidade_comercial_referencia__dbt_tmp_temp_view" as
    SELECT FF.CH_MATRICULA_UNIDADE, FF.DT_MESANO_REF AS DT_MES_REF_UNIDADE, MIN(FF.ID_FATURA) AS ID_FATURA_ORIGINAL, FCF.ID_CALENDARIO_FATURAMENTO, MAX(FF.ID_FATURA) AS ID_FATURA_ATUAL 
FROM "papakura_20221223"."dbo_mig"."fat_fatura" FF
inner JOIN "papakura_20221223"."dbo_mig"."fat_calendario_faturamento" FCF ON (FCF.ID_GRUPO_FATURAMENTO = FF.ID_GRUPO_FATURAMENTO AND FCF.DT_CALENDARIO_MESANO_REF = FF.DT_MESANO_REF) 
-- WHERE   1=1
--AND NOT EXISTS (SELECT 1 FROM dbo_mig.fat_unidade_comercial_referencia A WHERE A.CH_MATRICULA_UNIDADE = FF.CH_MATRICULA_UNIDADE AND A.DT_MES_REF_UNIDADE = FF.DT_MESANO_REF)
GROUP BY FF.CH_MATRICULA_UNIDADE, FF.DT_MESANO_REF, FCF.ID_CALENDARIO_FATURAMENTO
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."fat_unidade_comercial_referencia__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."fat_unidade_comercial_referencia__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."fat_unidade_comercial_referencia__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."fat_unidade_comercial_referencia__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_fat_unidade_comercial_referencia__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_fat_unidade_comercial_referencia__dbt_tmp')
    )
  DROP index "dbo_mig"."fat_unidade_comercial_referencia__dbt_tmp".dbo_mig_fat_unidade_comercial_referencia__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_fat_unidade_comercial_referencia__dbt_tmp_cci
    ON "dbo_mig"."fat_unidade_comercial_referencia__dbt_tmp"

   

