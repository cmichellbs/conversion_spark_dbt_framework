
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."stage_fl_entrega__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."stage_fl_entrega__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."stage_fl_entrega__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."stage_fl_entrega__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."stage_fl_entrega__dbt_tmp_temp_view" as
    select 

CUC.CH_MATRICULA_UNIDADE as CH_MATRICULA_UNIDADE

FROM

"papakura_20221223"."dbo_mig"."cad_unidade_comercial" CUC 
INNER JOIN "papakura_20221223"."dbo_mig"."stage_loc_adj_adj" L ON CUC.CH_MATRICULA_UNIDADE = L.LOCA_ITEMID
left join "papakura_20221223"."dbo_mig"."cad_endereco" CE  on L.SEQNO = CE.ACTID
inner JOIN "papakura_20221223"."dbo_mig"."stage_ceuc_consumer" CONS ON CONS.CINSTALL = CUC.CH_MATRICULA_UNIDADE
inner JOIN "papakura_20221223"."dbo_mig"."stage_loc_adj_adj" L2 ON L2.LOCA_ITEMID = CONS.CACCT
inner join "papakura_20221223"."dbo_mig"."cad_endereco" CE_ALT  on L2.SEQNO = CE_ALT.ACTID
LEFT JOIN "papakura_20221223"."dbo_mig"."tab_faixa_logradouro" TFL2 ON L2.LOCA_ITEMID = TFL2.ACTID
LEFT JOIN "papakura_20221223"."dbo_mig"."tab_faixa_logradouro" TFL ON L.LOCA_ITEMID = TFL.ACTID

WHERE  CUC.CH_MATRICULA_UNIDADE  in (SELECT CINSTALL FROM "papakura_20221223"."dbo_mig"."stage_ceuc_consumer")
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."stage_fl_entrega__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."stage_fl_entrega__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."stage_fl_entrega__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."stage_fl_entrega__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_stage_fl_entrega__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_stage_fl_entrega__dbt_tmp')
    )
  DROP index "dbo_mig"."stage_fl_entrega__dbt_tmp".dbo_mig_stage_fl_entrega__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_stage_fl_entrega__dbt_tmp_cci
    ON "dbo_mig"."stage_fl_entrega__dbt_tmp"

   

