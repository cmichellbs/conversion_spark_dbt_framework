
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."tab_logradouro__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."tab_logradouro__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."tab_logradouro__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."tab_logradouro__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."tab_logradouro__dbt_tmp_temp_view" as
    


WITH LOGRADOURO AS (SELECT DISTINCT UPPER(full_road_name) AS FULL_ROAD,UPPER(road_name) AS ROAD,
UPPER(road_type_name) AS ROAD_TYPE,UPPER(concat(road_name,'' '',road_name_type_abbrev)) AS FULL_ROAD_ABBREV,UPPER(road_name_type_value) AS ROAD_TYPE2,
UPPER(road_name_type_abbrev) AS ROAD_TYPE_ABBREV
FROM "papakura_20221223"."dbo"."nz_full_address" 
WHERE road_name IS NOT NULL)

,POBOX AS (SELECT DISTINCT LOCA_POBOX FROM "papakura_20221223"."dbo"."LOCADDRESS" WHERE LOCA_POBOX IS NOT NULL)

, interm as (
select 

1 as CH_ATIVO, 
466 as CH_TITULO_PATENTE,
1 AS CH_MUNICIPIO, 
COALESCE(RDTYPE.CH_TIPO_LOGRADOURO,999999) AS CH_TIPO_LOGRADOURO, 
null AS ID_LOGRADOURO_PREFEITURA, 
null AS NR_COD_RECADASTRAMENTO, 
LOGRADOURO.ROAD AS DE_LOGRADOURO,
CONCAT(LOGRADOURO.ROAD,'' '',COALESCE(RDTYPE.NM_TIPO_LOGRADOURO,'''')) AS DS_LOGRADOURO_COMPLETO, 
'' '' AS DS_OBSERVACAO,
FULL_ROAD AS FULL_ROAD

FROM  LOGRADOURO 
left JOIN "papakura_20221223"."dbo_mig"."tab_tipo_logradouro" RDTYPE ON RDTYPE.TP_LOG = LOGRADOURO.ROAD_TYPE_ABBREV

UNION ALL

SELECT
1 as CH_ATIVO, 
466 as CH_TITULO_PATENTE,
1 AS CH_MUNICIPIO, 
999999 AS CH_TIPO_LOGRADOURO, 
null AS ID_LOGRADOURO_PREFEITURA, 
null AS NR_COD_RECADASTRAMENTO, 
UPPER(POBOX.LOCA_POBOX) AS DE_LOGRADOURO,
UPPER(POBOX.LOCA_POBOX) AS DS_LOGRADOURO_COMPLETO, 
'' '' AS DS_OBSERVACAO,
UPPER(POBOX.LOCA_POBOX) AS FULL_ROAD

from POBOX


)

,final as (select distinct * from interm)

select *,
ROW_NUMBER() over(order by  DE_LOGRADOURO) + 1 as CH_LOGRADOURO, 
ROW_NUMBER() over(order by  DE_LOGRADOURO) + 1 as NR_COD_LOGR
from final
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."tab_logradouro__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."tab_logradouro__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."tab_logradouro__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."tab_logradouro__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_tab_logradouro__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_tab_logradouro__dbt_tmp')
    )
  DROP index "dbo_mig"."tab_logradouro__dbt_tmp".dbo_mig_tab_logradouro__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_tab_logradouro__dbt_tmp_cci
    ON "dbo_mig"."tab_logradouro__dbt_tmp"

   

