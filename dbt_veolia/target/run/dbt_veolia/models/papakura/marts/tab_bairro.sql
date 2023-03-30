
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."tab_bairro__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."tab_bairro__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."tab_bairro__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."tab_bairro__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."tab_bairro__dbt_tmp_temp_view" as
    

with AREA AS(SELECT 
DISTINCT CASE WHEN suburb IS NULL THEN ''NOT DEFINED SUBURB'' ELSE suburb END AS LOCA_SUBURB_ADJ


 FROM "papakura_20221223"."dbo_mig"."LOCADDRESS_ADJ")

SELECT 
ROW_NUMBER() OVER(ORDER BY LOCA_SUBURB_ADJ) +1 as CH_BAIRRO,
100002 as ID_ESTRUTURA_EMPRESA,
1 AS CH_MUNICIPIO,
1 as CH_ATIVO,
NULL as ID_AGRUPAMENTO_LOCALIZACAO,
UPPER(AREA.LOCA_SUBURB_ADJ) as NM_BAIRRO

FROM AREA 

union ALL

select
9999 as CH_BAIRRO,
100002 as ID_ESTRUTURA_EMPRESA,
1 AS CH_MUNICIPIO,
1 as CH_ATIVO,
NULL as ID_AGRUPAMENTO_LOCALIZACAO,
UPPER(''NOT DEFINED SUBURB'') as NM_BAIRRO

-- esta é a tabela_bairro
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."tab_bairro__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."tab_bairro__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."tab_bairro__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."tab_bairro__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_tab_bairro__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_tab_bairro__dbt_tmp')
    )
  DROP index "dbo_mig"."tab_bairro__dbt_tmp".dbo_mig_tab_bairro__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_tab_bairro__dbt_tmp_cci
    ON "dbo_mig"."tab_bairro__dbt_tmp"

   

