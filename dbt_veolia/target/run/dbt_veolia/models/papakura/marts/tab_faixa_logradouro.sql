
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."tab_faixa_logradouro__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."tab_faixa_logradouro__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."tab_faixa_logradouro__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."tab_faixa_logradouro__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."tab_faixa_logradouro__dbt_tmp_temp_view" as
    
WITH 

LOC AS (SELECT *,CASE WHEN LOCA_SUBURB IS NULL OR LOCA_SUBURB = ''.'' THEN ''NOT DEFINED SUBURB'' ELSE LOCA_SUBURB 
END AS LOCA_SUBURB_ADJ,
CASE WHEN UPPER(full_road_name2) IS NULL THEN ''STREET NOT DEFINED'' ELSE UPPER(full_road_name2) END AS LOCA_STREET_ADJ,
CASE WHEN LOCA_HOUSE IS NULL THEN '''' ELSE LOCA_HOUSE END AS LOCA_HOUSE_ADJ
FROM "papakura_20221223"."dbo_mig"."stage_loc_adj2"

)

,interm as(SELECT
1 AS CH_ATIVO,
coalesce(INTERB.CH_BAIRRO,2) AS CH_BAIRRO,
coalesce(INTERL.CH_LOGRADOURO,99999) AS CH_LOGRADOURO,
null AS ID_AGRUPAMENTO_LOCALIZACAO,
null AS NR_LATITUDE,
null AS NR_LONGITUDE,
coalesce(cast(left(LOC.LOCA_POSTCODE,10) as varchar),''2582'') AS CD_CEP,
''Faixa Única'' AS NM_FAIXA_LOGRADOURO,
LOC.SEQNO AS ACTID,
LOC.SEQNO AS MIG_PK_TEMP

FROM 
LOC
left JOIN "papakura_20221223"."dbo_mig"."tab_logradouro"INTERL ON INTERL.FULL_ROAD = LOC.LOCA_STREET_ADJ
left JOIN "papakura_20221223"."dbo_mig"."tab_bairro" INTERB ON INTERB.NM_BAIRRO = LOC.LOCA_SUBURB_ADJ
where LOC.LOCA_POBOX IS NULL

UNION ALL 

SELECT
1 AS CH_ATIVO,
coalesce(INTERB.CH_BAIRRO,2) AS CH_BAIRRO,
coalesce(INTERL.CH_LOGRADOURO,99999) AS CH_LOGRADOURO,
null AS ID_AGRUPAMENTO_LOCALIZACAO,
null AS NR_LATITUDE,
null AS NR_LONGITUDE,
coalesce(cast(left(LOC.LOCA_POSTCODE,10) as varchar),''2582'') AS CD_CEP,
''Faixa Única'' AS NM_FAIXA_LOGRADOURO,
LOC.SEQNO AS ACTID,
LOC.SEQNO AS MIG_PK_TEMP
FROM 
LOC
left JOIN "papakura_20221223"."dbo_mig"."tab_logradouro"INTERL ON INTERL.FULL_ROAD = UPPER(LOC.LOCA_POBOX)
left JOIN "papakura_20221223"."dbo_mig"."tab_bairro" INTERB ON INTERB.NM_BAIRRO = LOC.LOCA_SUBURB_ADJ
where LOC.LOCA_POBOX IS NOT NULL

)

,final as (select distinct * from interm)

select *,ROW_NUMBER() over(order by CH_LOGRADOURO) +1 as ID_FAIXA_LOGRADOURO
 from final
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."tab_faixa_logradouro__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."tab_faixa_logradouro__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."tab_faixa_logradouro__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."tab_faixa_logradouro__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_tab_faixa_logradouro__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_tab_faixa_logradouro__dbt_tmp')
    )
  DROP index "dbo_mig"."tab_faixa_logradouro__dbt_tmp".dbo_mig_tab_faixa_logradouro__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_tab_faixa_logradouro__dbt_tmp_cci
    ON "dbo_mig"."tab_faixa_logradouro__dbt_tmp"

   

