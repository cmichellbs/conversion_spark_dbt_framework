
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."fat_parcela_servico_contrato__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."fat_parcela_servico_contrato__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."fat_parcela_servico_contrato__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."fat_parcela_servico_contrato__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."fat_parcela_servico_contrato__dbt_tmp_temp_view" as
    SELECT
ROW_NUMBER() OVER(ORDER BY FPSU.ID_PARCELA_SERVICO_UNIDADE ) as ID_PARCELA_SERVICO_CONTRATO,
FPSU.MIG_GBICSTARTDATE_TEMP as DT_INICIO_CONSUMO,
FPSU.MIG_GBICENDDATE_TEMP as DT_FIM_CONSUMO,
null as ID_CONTRATO_UNIDADE_COMERCIAL,
FPSU.ID_PARCELA_SERVICO_UNIDADE as ID_PARCELA_SERVICO_UNIDADE,
FCUC.VL_FATURAMENTO AS VL_BASE_DIARIO,
''S'' as MIG_FL_TEMP,
FPSU.MIG_GBICPLANID_TEMP,
FPSU.MIG_CH_MATRICULA_UNIDADE_TEMP,
cast(FPSU.MIG_GBICRATE_TEMP  as decimal(16,3))  as MIG_GBICRATE_TEMP,

FPSU.MIG_GBICCHARGE_TEMP

FROM
"papakura_20221223"."dbo_mig"."fat_parcela_servico_unidade" FPSU
inner join "papakura_20221223"."dbo_mig"."fat_servico_unidade" FSU ON FSU.ID_SERVICO_UNIDADE = FPSU.ID_SERVICO_UNIDADE
inner JOIN "papakura_20221223"."dbo"."GBINVOICE" GBI ON GBI.GBIINVOICE = FPSU.MIG_ID_FATURA_TEMP
inner JOIN "papakura_20221223"."dbo_mig"."stage_fat_contrato_unidade_comercial" FCUC ON cast(GBI.GBICONSUMER as varchar) = cast(FCUC.MIG_PK_TEMP as varchar)
        and cast(FCUC.CH_MATRICULA_UNIDADE  as integer)= cast(FPSU.MIG_CH_MATRICULA_UNIDADE_TEMP as integer)
        AND FPSU.MIG_GBICPLANID_TEMP = FCUC.CCON_PLANID1
        AND FPSU.MIG_GBICCHARGE_TEMP = FCUC.MIG_CODE_TEMP
--  and FPSU.MIG_GBICRATE_TEMP = FCUC.CRAT$RATE
 and ((dateadd(day,1,FPSU.MIG_GBICSTARTDATE_TEMP) >= FCUC.DT_INICIO_VIGENCIA AND 
        FPSU.MIG_GBICENDDATE_TEMP <= FCUC.DT_FIM_VIGENCIA )
-- OR FPSU.MIG_GBICRATE_TEMP = FCUC.CRAT$RATE 
 )
WHERE FPSU.MIG_TARIFA_FIXA_TEMP = ''S''
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."fat_parcela_servico_contrato__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."fat_parcela_servico_contrato__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."fat_parcela_servico_contrato__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."fat_parcela_servico_contrato__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_fat_parcela_servico_contrato__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_fat_parcela_servico_contrato__dbt_tmp')
    )
  DROP index "dbo_mig"."fat_parcela_servico_contrato__dbt_tmp".dbo_mig_fat_parcela_servico_contrato__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_fat_parcela_servico_contrato__dbt_tmp_cci
    ON "dbo_mig"."fat_parcela_servico_contrato__dbt_tmp"

   
