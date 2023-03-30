
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."stage_ceuc_2__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."stage_ceuc_2__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."stage_ceuc_2__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."stage_ceuc_2__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."stage_ceuc_2__dbt_tmp_temp_view" as
    select 
cast(L2.LOCA_FREEFORM as varchar) as NM_DESTINATARIO_ENDERECO_ALTERNATIVO,
case when L2.LOCA_POBOX is null then CONCAT(L2.LOCA_HOUSEPREFIX,
                                                case when L2.LOCA_UNIT IS NOT NULL THEN CONCAT(''/'',L2.LOCA_UNIT) ELSE NULL END
,case when L2.LOCA_HOUSE IS NOT NULL THEN CONCAT(''/'',L2.LOCA_HOUSE) ELSE NULL END
,case when L.LOCA_HOUSETO IS NOT NULL THEN CONCAT(''-'',L.LOCA_HOUSETO) ELSE NULL END
,case when L2.LOCA_HOUSESUFFIX IS NOT NULL THEN CONCAT(''/'',L2.LOCA_HOUSESUFFIX) ELSE NULL END
 ) else '''' end as DE_COMPLEMENTO,
''SN'' as NR_LOCALIZACAO_ENTREGA,
CE_ALT.ID_ENDERECO as ID_ENDERECO,
3 as  CH_TIPO_ENDERECO_UNIDADE,
CUC.CH_MATRICULA_UNIDADE as CH_MATRICULA_UNIDADE,
null as ID_ROTA_LEITURA_AGUA_UNIDADE,
cast(1 as BIT) as FL_ENTREGA,
null as CH_MATRICULA_UNIDADE_ENTREGA,
L2.SEQNO AS MIG_PK_TEMP

FROM

"papakura_20221223"."dbo_mig"."cad_unidade_comercial" CUC 
INNER JOIN "papakura_20221223"."dbo_mig"."stage_loc_adj_adj" L ON CUC.CH_MATRICULA_UNIDADE = L.LOCA_ITEMID
left join "papakura_20221223"."dbo_mig"."cad_endereco" CE  on L.SEQNO = CE.ACTID
inner JOIN "papakura_20221223"."dbo_mig"."stage_ceuc_consumer" CONS ON CONS.CINSTALL = CUC.CH_MATRICULA_UNIDADE
LEFT JOIN "papakura_20221223"."dbo_mig"."stage_loc_adj_adj" L2 ON L2.LOCA_ITEMID = CONS.CACCT
inner join "papakura_20221223"."dbo_mig"."cad_endereco" CE_ALT  on L2.SEQNO = CE_ALT.ACTID


WHERE  CUC.CH_MATRICULA_UNIDADE  in (SELECT CINSTALL FROM "papakura_20221223"."dbo_mig"."stage_ceuc_consumer")
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."stage_ceuc_2__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."stage_ceuc_2__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."stage_ceuc_2__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."stage_ceuc_2__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_stage_ceuc_2__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_stage_ceuc_2__dbt_tmp')
    )
  DROP index "dbo_mig"."stage_ceuc_2__dbt_tmp".dbo_mig_stage_ceuc_2__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_stage_ceuc_2__dbt_tmp_cci
    ON "dbo_mig"."stage_ceuc_2__dbt_tmp"

   

