
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."tab_tipo_logradouro__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."tab_tipo_logradouro__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."tab_tipo_logradouro__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."tab_tipo_logradouro__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."tab_tipo_logradouro__dbt_tmp_temp_view" as
    WITH RDTYPE AS(SELECT DISTINCT UPPER(road_name_type_value) AS NM_TIPO_LOGRADOURO,
UPPER(road_name_type_abbrev) NM_TIPO_LOGRADOURO_ABREV FROM "papakura_20221223"."dbo"."nz_full_address"  )


SELECT
ROW_NUMBER() OVER(ORDER BY RDTYPE.NM_TIPO_LOGRADOURO_ABREV) + 1000 as CH_TIPO_LOGRADOURO,
COALESCE(RDTYPE.NM_TIPO_LOGRADOURO,'''') as NM_TIPO_LOGRADOURO,
COALESCE(RDTYPE.NM_TIPO_LOGRADOURO_ABREV,'''') as NM_TIPO_LOGRADOURO_ABREV,
1 as CH_ATIVO,
RDTYPE.NM_TIPO_LOGRADOURO_ABREV AS TP_LOG,
RDTYPE.NM_TIPO_LOGRADOURO_ABREV AS MIG_TP_LOG_TEMP
FROM
RDTYPE

UNION ALL

SELECT
999999 as CH_TIPO_LOGRADOURO,
'''' as NM_TIPO_LOGRADOURO,
'''' as NM_TIPO_LOGRADOURO_ABREV,
1 as CH_ATIVO,
'''' AS TP_LOG,
'''' AS MIG_TP_LOG_TEMP
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."tab_tipo_logradouro__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."tab_tipo_logradouro__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."tab_tipo_logradouro__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."tab_tipo_logradouro__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_tab_tipo_logradouro__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_tab_tipo_logradouro__dbt_tmp')
    )
  DROP index "dbo_mig"."tab_tipo_logradouro__dbt_tmp".dbo_mig_tab_tipo_logradouro__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_tab_tipo_logradouro__dbt_tmp_cci
    ON "dbo_mig"."tab_tipo_logradouro__dbt_tmp"

   

