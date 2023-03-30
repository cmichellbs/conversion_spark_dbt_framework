
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."tab_modelo_hidrometro__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."tab_modelo_hidrometro__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."tab_modelo_hidrometro__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."tab_modelo_hidrometro__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."tab_modelo_hidrometro__dbt_tmp_temp_view" as
    with model as(select em.MUKEY from "papakura_20221223"."dbo"."EMS_MUSE" em )

SELECT
row_number() over(order by MUKEY ) as CH_MODELO_HIDROMETRO,
7 as NU_DIGITOS,
null as QT_LIMITE_INF,
null as QT_VASAO_NOMINAL,
null as QT_VASAO_MAXIMA,
coalesce(4, 0) as CH_TIPO_HIDROMETRO,
1 as CH_ATIVO,
8 as ID_CAPACIDADE_HIDROMETRO,
DIAMETRO.CH_DIAMETRO_HIDROMETRO as CH_DIAMETRO_HIDROMETRO,
coalesce(13, 0) as ID_MARCA_HIDROMETRO,
coalesce(1, 0) as ID_CLASSE_METROLOGICA,
10 as QT_CARACTERES,
MUKEY AS DIAMETRO,
MUKEY AS MIG_DIAMETRO_TEMP
FROM MODEL
LEFT JOIN "papakura_20221223"."dbo_mig"."tab_diametro_hidrometro" DIAMETRO ON DIAMETRO.DIAMETRO = MODEL.MUKEY
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."tab_modelo_hidrometro__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."tab_modelo_hidrometro__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."tab_modelo_hidrometro__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."tab_modelo_hidrometro__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_tab_modelo_hidrometro__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_tab_modelo_hidrometro__dbt_tmp')
    )
  DROP index "dbo_mig"."tab_modelo_hidrometro__dbt_tmp".dbo_mig_tab_modelo_hidrometro__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_tab_modelo_hidrometro__dbt_tmp_cci
    ON "dbo_mig"."tab_modelo_hidrometro__dbt_tmp"

   

