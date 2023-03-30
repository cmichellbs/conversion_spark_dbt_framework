
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."cad_cliente_unidade_comercial__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."cad_cliente_unidade_comercial__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."cad_cliente_unidade_comercial__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."cad_cliente_unidade_comercial__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."cad_cliente_unidade_comercial__dbt_tmp_temp_view" as
    -- ROW ID_CLIENTE_UNIDADE_COMERCIAL



SELECT
CONS.CDFINAL as DT_VALIDADE,
CASE WHEN ROW_NUMBER() OVER(PARTITION BY CONS.CINSTALL ORDER BY CONS.CONSUMERNO DESC) = 1 THEN 1 ELSE 0 END as CH_ATIVO,
CONS.CACCT as CH_CLIENTE,
2 as CH_TIPO_CLIENTE,
CONS.CINSTALL as CH_MATRICULA_UNIDADE,
null as ID_SERVICO,
CONCAT(''CONSUMER NO. '',CAST(CONS.CONSUMERNO AS VARCHAR)) as NM_IDENTIFICACAO_UNIDADE,
cast(0 as BIT) as FL_PREFERENCIAL,
CONS.CONSUMERNO as MIG_PK_TEMP,
CONS.CSTATUSTYPE AS MIG_STATUSTYPE_TEMP
FROM "papakura_20221223"."dbo"."CONSUMER" CONS

UNION ALL

SELECT
CONS.CDFINAL as DT_VALIDADE,
CASE WHEN ROW_NUMBER() OVER(PARTITION BY CONS.CINSTALL ORDER BY CONS.CONSUMERNO DESC) = 1 THEN 1 ELSE 0 END as CH_ATIVO,
CONS.CACCT as CH_CLIENTE,
1 as CH_TIPO_CLIENTE,
CONS.CINSTALL as CH_MATRICULA_UNIDADE,
null as ID_SERVICO,
CONCAT(''CONSUMER NO. '',CAST(CONS.CONSUMERNO AS VARCHAR)) as NM_IDENTIFICACAO_UNIDADE,
cast(0 as BIT) as FL_PREFERENCIAL,
CONS.CONSUMERNO as MIG_PK_TEMP,
CONS.CSTATUSTYPE AS MIG_STATUSTYPE_TEMP

FROM "papakura_20221223"."dbo"."CONSUMER" CONS
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."cad_cliente_unidade_comercial__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."cad_cliente_unidade_comercial__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."cad_cliente_unidade_comercial__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."cad_cliente_unidade_comercial__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_cad_cliente_unidade_comercial__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_cad_cliente_unidade_comercial__dbt_tmp')
    )
  DROP index "dbo_mig"."cad_cliente_unidade_comercial__dbt_tmp".dbo_mig_cad_cliente_unidade_comercial__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_cad_cliente_unidade_comercial__dbt_tmp_cci
    ON "dbo_mig"."cad_cliente_unidade_comercial__dbt_tmp"

   

