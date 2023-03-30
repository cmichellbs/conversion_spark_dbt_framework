
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."cad_unidade_alerta__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."cad_unidade_alerta__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."cad_unidade_alerta__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."cad_unidade_alerta__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."cad_unidade_alerta__dbt_tmp_temp_view" as
    SELECT
ROW_NUMBER() OVER(ORDER BY CA.CONSUMERNO) as ID_UNIDADE_ALERTA,
coalesce(concat(CCODE.PKEY,'' - '',CCODE.PDESC), ''STRING'') as DS_ALERTA,
coalesce(cast(1 as BIT), cast(1 as BIT)) as FL_ATIVO,
cast(getdate() as varchar) as DT_CADASTRO_ALERTA,
null as DT_INATIVACAO_ALERTA,
CUC.CH_MATRICULA_UNIDADE as CH_MATRICULA_UNIDADE,
1 as ID_USUARIO_CADASTRO,
null as ID_USUARIO_INATIVACAO,
cast(1 as BIT) as FL_EXIBE_JTECH_OS,
cast(1 as BIT) as FL_EXIBE_SANSYS_LEITURA
FROM
"papakura_20221223"."dbo"."CONSUMER" CA
INNER JOIN "papakura_20221223"."dbo_mig"."cad_unidade_comercial" CUC ON CUC.CH_MATRICULA_UNIDADE = CA.CINSTALL
LEFT JOIN "papakura_20221223"."dbo"."CRITICAL_CODE" CCODE ON CCODE.PKEY = CA.CCRITICALCODE
WHERE CA.CCRITICALCODE IS NOT NULL
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."cad_unidade_alerta__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."cad_unidade_alerta__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."cad_unidade_alerta__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."cad_unidade_alerta__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_cad_unidade_alerta__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_cad_unidade_alerta__dbt_tmp')
    )
  DROP index "dbo_mig"."cad_unidade_alerta__dbt_tmp".dbo_mig_cad_unidade_alerta__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_cad_unidade_alerta__dbt_tmp_cci
    ON "dbo_mig"."cad_unidade_alerta__dbt_tmp"

   

