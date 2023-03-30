
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."cad_endereco__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."cad_endereco__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."cad_endereco__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."cad_endereco__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."cad_endereco__dbt_tmp_temp_view" as
    


WITH LOCADDRESS_ADJ_INTERM AS (SELECT *,ROW_NUMBER() OVER(PARTITION BY LOCA_ITEMID ORDER BY SEQNO DESC) AS RN2 FROM "papakura_20221223"."dbo_mig"."stage_loc_adj2")

,LOCADDRESS_ADJ_ADJ as (SELECT * FROM LOCADDRESS_ADJ_INTERM WHERE RN2 = 1)

,LOC AS (SELECT *,CASE WHEN LOCA_SUBURB IS NULL OR LOCA_SUBURB = ''.'' THEN ''NOT DEFINED SUBURB'' ELSE LOCA_SUBURB 
END AS LOCA_SUBURB_ADJ,
CASE WHEN UPPER(full_road_name2) IS NULL THEN ''STREET NOT DEFINED'' ELSE UPPER(full_road_name2) END AS LOCA_STREET_ADJ,
CASE WHEN LOCA_HOUSE IS NULL THEN '''' ELSE LOCA_HOUSE END AS LOCA_HOUSE_ADJ
FROM LOCADDRESS_ADJ_ADJ


)

,interm as (
SELECT
FAIXA_LOGRADOURO.ID_FAIXA_LOGRADOURO AS ID_FAIXA_LOGRADOURO,
1 AS CH_ATIVO,
coalesce(cast(CAST(CASE WHEN LOC.LOCA_HOUSEPREFIX IS NOT NULL THEN NULL
WHEN LOC.LOCA_HOUSEPREFIX IS NULL AND LOC.LOCA_UNIT IS NOT NULL THEN CAST(LOC.LOCA_UNIT AS VARCHAR) 
 
ELSE CAST(LOC.LOCA_HOUSE AS VARCHAR) END AS VARCHAR)  as varchar),''SN'') AS NU_IMOVEL,
''S'' AS FL_CORRIGIR_CEP,
null AS NR_LATITUDE,
null AS NR_LONGITUDE,
'''' AS DS_LINK_GOOGLE_MAP,
''S'' FL_VALIDO,
LOC.SEQNO as ACTID,
LOC.SEQNO AS MIG_PK_TEMP,
ROW_NUMBER() over(partition by LOC.SEQNO order by FAIXA_LOGRADOURO.ID_FAIXA_LOGRADOURO DESC) AS RN

FROM LOC
inner JOIN "papakura_20221223"."dbo_mig"."tab_faixa_logradouro" FAIXA_LOGRADOURO ON FAIXA_LOGRADOURO.ACTID = LOC.SEQNO
)

,final as (select distinct * from interm WHERE RN=1) 

select *,ROW_NUMBER() over(order by ID_FAIXA_LOGRADOURO ) +1 AS ID_ENDERECO
 from final
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."cad_endereco__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."cad_endereco__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."cad_endereco__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."cad_endereco__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_cad_endereco__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_cad_endereco__dbt_tmp')
    )
  DROP index "dbo_mig"."cad_endereco__dbt_tmp".dbo_mig_cad_endereco__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_cad_endereco__dbt_tmp_cci
    ON "dbo_mig"."cad_endereco__dbt_tmp"

   

