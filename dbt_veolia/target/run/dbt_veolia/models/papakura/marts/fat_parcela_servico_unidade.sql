
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."fat_parcela_servico_unidade__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."fat_parcela_servico_unidade__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."fat_parcela_servico_unidade__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."fat_parcela_servico_unidade__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."fat_parcela_servico_unidade__dbt_tmp_temp_view" as
    


SELECT row_number() over(order by ID_SERVICO_UNIDADE) AS ID_PARCELA_SERVICO_UNIDADE, 
ID_SERVICO_UNIDADE, 
VL_TOTAL_SERVICO AS VL_PARCELA_SERVICO,  
DT_GRAVACAO_SERVICO AS DT_GERACAO_PARCELA,
cast(cast(concat(year(fat.GBIDATE),concat(''-'',concat(month(fat.GBIDATE),concat(''-'',01)))) as date) as varchar) AS DT_MESANOREF_FATURADO,  
(CASE WHEN FSU.FL_POSSUI_PARCELA_FATURAR = ''S'' THEN DT_GRAVACAO_SERVICO ELSE fat.GBIDATE END) AS DT_SITUACAO_PARCELA,  
FL_POSSUI_PARCELA_FATURAR,  
FSU.MIG_ID_FATURA_TEMP ,
FSU.MIG_TARIFA_FIXA_TEMP,
FSU.MIG_GBICTRN_TYPE_TEMP,
CASE WHEN DATEPART(MONTH,FSU.MIG_GBICSTARTDATE_TEMP) = 06 AND  DATEPART(DAY,FSU.MIG_GBICSTARTDATE_TEMP) = 30 THEN DATEADD(DAY,1,FSU.MIG_GBICSTARTDATE_TEMP) ELSE FSU.MIG_GBICSTARTDATE_TEMP END as MIG_GBICSTARTDATE_TEMP,
FSU.MIG_GBICENDDATE_TEMP as MIG_GBICENDDATE_TEMP,
FSU.MIG_GBICUNITS_TEMP,
FSU.MIG_GBICPLANID_TEMP,
CAST(FSU.MIG_GBICRATE_TEMP AS DECIMAL(16,3))AS MIG_GBICRATE_TEMP,
FSU.MIG_GBICCHARGE_TEMP,
FSU.CH_MATRICULA_UNIDADE AS MIG_CH_MATRICULA_UNIDADE_TEMP,
fat.GBICONSUMER
FROM "papakura_20221223"."dbo_mig"."fat_servico_unidade" FSU  
inner JOIN "papakura_20221223"."dbo"."GBINVOICE" fat ON FSU.MIG_ID_FATURA_TEMP = fat.GBIINVOICE
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."fat_parcela_servico_unidade__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."fat_parcela_servico_unidade__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."fat_parcela_servico_unidade__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."fat_parcela_servico_unidade__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_fat_parcela_servico_unidade__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_fat_parcela_servico_unidade__dbt_tmp')
    )
  DROP index "dbo_mig"."fat_parcela_servico_unidade__dbt_tmp".dbo_mig_fat_parcela_servico_unidade__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_fat_parcela_servico_unidade__dbt_tmp_cci
    ON "dbo_mig"."fat_parcela_servico_unidade__dbt_tmp"

   

