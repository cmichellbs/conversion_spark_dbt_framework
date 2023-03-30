
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."cad_endereco_cliente__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."cad_endereco_cliente__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."cad_endereco_cliente__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."cad_endereco_cliente__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."cad_endereco_cliente__dbt_tmp_temp_view" as
    


WITH LOCADDRESS_ADJ_INTERM AS (SELECT *,ROW_NUMBER() OVER(PARTITION BY LOCA_ITEMID ORDER BY SEQNO DESC) AS RN FROM "papakura_20221223"."dbo_mig"."LOCADDRESS_ADJ")

,LOCADDRESS_ADJ_ADJ as (SELECT * FROM LOCADDRESS_ADJ_INTERM WHERE RN = 1)


SELECT
ROW_NUMBER() over(order by CC.CH_CLIENTE) AS ID_ENDERECO_CLIENTE,
CE.ID_ENDERECO  AS ID_ENDERECO,
CC.CH_CLIENTE AS CH_CLIENTE,
1 AS CH_TIPO_ENDERECO,
case 
when L.LOCA_HOUSEPREFIX is not null then CONCAT(L.LOCA_HOUSEPREFIX,
                                                case when L.LOCA_UNIT IS NOT NULL THEN CONCAT(''/'',L.LOCA_UNIT) ELSE NULL END
,case when L.LOCA_HOUSE IS NOT NULL THEN CONCAT(''/'',L.LOCA_HOUSE) ELSE NULL END
,case when L.LOCA_HOUSETO IS NOT NULL THEN CONCAT(''-'',L.LOCA_HOUSETO) ELSE NULL END
,case when L.LOCA_HOUSESUFFIX IS NOT NULL THEN CONCAT(''/'',L.LOCA_HOUSESUFFIX) ELSE NULL END
) 
when L.LOCA_UNIT IS NOT NULL AND L.LOCA_HOUSEPREFIX  IS NULL THEN CONCAT(''/'',L.LOCA_HOUSE,case when L.LOCA_HOUSETO IS NOT NULL THEN CONCAT(''-'',L.LOCA_HOUSETO) ELSE NULL END,case when L.LOCA_HOUSESUFFIX IS NOT NULL THEN CONCAT(''/'',L.LOCA_HOUSESUFFIX) ELSE NULL END
)
else case when L.LOCA_HOUSESUFFIX IS NOT NULL THEN CONCAT(''/'',L.LOCA_HOUSESUFFIX) ELSE NULL END END  as  DS_COMPLEMENTO_ENDERECO,
L.SEQNO AS MIG_PK_TEMP
FROM "papakura_20221223"."dbo_mig"."cad_cliente" CC
INNER JOIN LOCADDRESS_ADJ_ADJ L ON L.LOCA_ITEMID = CC.CH_CLIENTE
LEFT JOIN "papakura_20221223"."dbo_mig"."cad_endereco" CE ON CE.ACTID = L.SEQNO
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."cad_endereco_cliente__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."cad_endereco_cliente__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."cad_endereco_cliente__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."cad_endereco_cliente__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_cad_endereco_cliente__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_cad_endereco_cliente__dbt_tmp')
    )
  DROP index "dbo_mig"."cad_endereco_cliente__dbt_tmp".dbo_mig_cad_endereco_cliente__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_cad_endereco_cliente__dbt_tmp_cci
    ON "dbo_mig"."cad_endereco_cliente__dbt_tmp"

   

