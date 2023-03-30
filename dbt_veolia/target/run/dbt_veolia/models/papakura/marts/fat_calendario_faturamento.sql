
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."fat_calendario_faturamento__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."fat_calendario_faturamento__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."fat_calendario_faturamento__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."fat_calendario_faturamento__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."fat_calendario_faturamento__dbt_tmp_temp_view" as
    WITH REFERENCIAS AS (SELECT DISTINCT DT_MESANO_REF FROM "papakura_20221223"."dbo_mig"."fat_fatura")



SELECT
row_number() over(order by DT_MESANO_REF asc, fgf.ID_GRUPO_FATURAMENTO)as ID_CALENDARIO_FATURAMENTO,
REFERENCIAS.DT_MESANO_REF as DT_CALENDARIO_MESANO_REF,
1  as CH_ATIVO,
fgf.ID_GRUPO_FATURAMENTO as ID_GRUPO_FATURAMENTO,
1 as CH_DEFINICAO_ESTAGIO

FROM
"papakura_20221223"."dbo_mig"."fat_grupo_faturamento" fgf,REFERENCIAS
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."fat_calendario_faturamento__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."fat_calendario_faturamento__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."fat_calendario_faturamento__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."fat_calendario_faturamento__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_fat_calendario_faturamento__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_fat_calendario_faturamento__dbt_tmp')
    )
  DROP index "dbo_mig"."fat_calendario_faturamento__dbt_tmp".dbo_mig_fat_calendario_faturamento__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_fat_calendario_faturamento__dbt_tmp_cci
    ON "dbo_mig"."fat_calendario_faturamento__dbt_tmp"

   

