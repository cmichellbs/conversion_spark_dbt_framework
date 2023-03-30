
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."stage_ceuc_1__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."stage_ceuc_1__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."stage_ceuc_1__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."stage_ceuc_1__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."stage_ceuc_1__dbt_tmp_temp_view" as
    SELECT

cast('''' as varchar) as NM_DESTINATARIO_ENDERECO_ALTERNATIVO,
case 
when L.LOCA_HOUSEPREFIX is not null then CONCAT(L.LOCA_HOUSEPREFIX,
                                                case when L.LOCA_UNIT IS NOT NULL THEN CONCAT(''/'',L.LOCA_UNIT) ELSE NULL END
,case when L.LOCA_HOUSE IS NOT NULL THEN CONCAT(''/'',L.LOCA_HOUSE) ELSE NULL END
,case when L.LOCA_HOUSETO IS NOT NULL THEN CONCAT(''-'',L.LOCA_HOUSETO) ELSE NULL END
,case when L.LOCA_HOUSESUFFIX IS NOT NULL THEN CONCAT(''/'',L.LOCA_HOUSESUFFIX) ELSE NULL END
) 
when L.LOCA_UNIT IS NOT NULL AND L.LOCA_HOUSEPREFIX  IS NULL THEN CONCAT(''/'',L.LOCA_HOUSE,case when L.LOCA_HOUSETO IS NOT NULL THEN CONCAT(''-'',L.LOCA_HOUSETO) ELSE NULL END,case when L.LOCA_HOUSESUFFIX IS NOT NULL THEN CONCAT(''/'',L.LOCA_HOUSESUFFIX) ELSE NULL END
)
else case when L.LOCA_HOUSESUFFIX IS NOT NULL THEN CONCAT(''/'',L.LOCA_HOUSESUFFIX) ELSE NULL END END as DE_COMPLEMENTO,
COALESCE(CAST(CASE WHEN L.LOCA_UNIT IS NOT NULL THEN CAST(L.LOCA_UNIT AS VARCHAR) ELSE CAST(L.LOCA_HOUSE AS VARCHAR) END AS VARCHAR),''SN'') as NR_LOCALIZACAO_ENTREGA,
CE.ID_ENDERECO as ID_ENDERECO,
1 as  CH_TIPO_ENDERECO_UNIDADE,
CUC.CH_MATRICULA_UNIDADE as CH_MATRICULA_UNIDADE,
null as ID_ROTA_LEITURA_AGUA_UNIDADE,
case when CUC.CH_MATRICULA_UNIDADE not in (select * from "papakura_20221223"."dbo_mig"."stage_fl_entrega") then cast(1 as BIT) else cast(0 as BIT) end as FL_ENTREGA,
null as CH_MATRICULA_UNIDADE_ENTREGA,
L.SEQNO AS MIG_PK_TEMP
FROM

"papakura_20221223"."dbo_mig"."cad_unidade_comercial" CUC 
INNER JOIN "papakura_20221223"."dbo_mig"."stage_loc_adj_adj" L ON CUC.CH_MATRICULA_UNIDADE = L.LOCA_ITEMID
LEFT join "papakura_20221223"."dbo_mig"."cad_endereco" CE  on L.SEQNO = CE.ACTID
WHERE  CUC.CH_MATRICULA_UNIDADE  in (SELECT CINSTALL FROM "papakura_20221223"."dbo"."CONSUMER")
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."stage_ceuc_1__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."stage_ceuc_1__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."stage_ceuc_1__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."stage_ceuc_1__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_stage_ceuc_1__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_stage_ceuc_1__dbt_tmp')
    )
  DROP index "dbo_mig"."stage_ceuc_1__dbt_tmp".dbo_mig_stage_ceuc_1__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_stage_ceuc_1__dbt_tmp_cci
    ON "dbo_mig"."stage_ceuc_1__dbt_tmp"

   

