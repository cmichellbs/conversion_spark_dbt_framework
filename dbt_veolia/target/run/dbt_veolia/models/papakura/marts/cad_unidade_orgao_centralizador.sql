
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."cad_unidade_orgao_centralizador__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."cad_unidade_orgao_centralizador__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."cad_unidade_orgao_centralizador__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."cad_unidade_orgao_centralizador__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."cad_unidade_orgao_centralizador__dbt_tmp_temp_view" as
    WITH ACCT AS (SELECT * FROM "papakura_20221223"."dbo"."ACCOUNTS" WHERE ACPARENT IS NOT NULL)


SELECT
row_number() over(PARTITION BY ACCT.ACPARENT order by ACCT.ACCTNO)  as ID_UNIDADE_ORGAO_CENTRALIZADOR,
CDENTRY as DT_INICIO_CENTRALIZACAO,
NULL as DT_FIM_CENTRALIZACAO,
OC.ID_ORGAO_CENTRALIZADOR as ID_ORGAO_CENTRALIZADOR,
1 as CH_ATIVO,
CONS.CINSTALL as CH_MATRICULA_UNIDADE

FROM ACCT
inner JOIN "papakura_20221223"."dbo"."CONSUMER" CONS ON CONS.CACCT = ACCT.ACCTNO

inner JOIN "papakura_20221223"."dbo_mig"."cad_orgao_centralizador" OC ON OC.CH_CLIENTE = ACCT.ACPARENT
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."cad_unidade_orgao_centralizador__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."cad_unidade_orgao_centralizador__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."cad_unidade_orgao_centralizador__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."cad_unidade_orgao_centralizador__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_cad_unidade_orgao_centralizador__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_cad_unidade_orgao_centralizador__dbt_tmp')
    )
  DROP index "dbo_mig"."cad_unidade_orgao_centralizador__dbt_tmp".dbo_mig_cad_unidade_orgao_centralizador__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_cad_unidade_orgao_centralizador__dbt_tmp_cci
    ON "dbo_mig"."cad_unidade_orgao_centralizador__dbt_tmp"

   

