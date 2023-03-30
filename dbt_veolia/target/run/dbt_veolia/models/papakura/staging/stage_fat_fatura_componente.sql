
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."stage_fat_fatura_componente__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."stage_fat_fatura_componente__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."stage_fat_fatura_componente__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."stage_fat_fatura_componente__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."stage_fat_fatura_componente__dbt_tmp_temp_view" as
    WITH 

COMP_INTERM AS(
SELECT CF.*,

CASE WHEN TARCHARGE.TARC$INV$HEAD$GRP = ''WATER'' THEN cast(coalesce(CASE WHEN GBICDOLLAR < 0 THEN GBICDOLLAR * 1 ELSE GBICDOLLAR END ,0)as double precision) ELSE 0 END + 
CASE WHEN TARCHARGE.TARC$INV$HEAD$GRP = ''WATER'' THEN cast(coalesce(CASE WHEN GBICTAX < 0 THEN GBICTAX * 1 ELSE GBICTAX END,0)as double precision) ELSE 0 END AS VL_AGUA_CPTE_FATURA_INTERM,
CASE WHEN TARCHARGE.TARC$INV$HEAD$GRP = ''SEWER'' THEN cast(coalesce(CASE WHEN GBICDOLLAR < 0 THEN GBICDOLLAR * 1 ELSE GBICDOLLAR END ,0)as double precision)ELSE 0 END + 
CASE WHEN TARCHARGE.TARC$INV$HEAD$GRP = ''SEWER'' THEN cast(coalesce(CASE WHEN GBICTAX < 0 THEN GBICTAX * 1 ELSE GBICTAX END,0)as double precision) ELSE 0 END AS VL_ESGOTO_CPTE_FATURA_INTERM,
CASE WHEN TARCHARGE.TARC$INV$HEAD$GRP NOT IN (''WATER'', ''SEWER'') THEN coalesce(CASE WHEN GBICDOLLAR < 0 THEN GBICDOLLAR * 1 ELSE GBICDOLLAR END,0) ELSE 0 END AS VL_SERVICO_BASICO_CPTE_FATURA_INTERM,
CASE WHEN TARCHARGE.TARC$INV$HEAD$GRP = ''WATER'' THEN cast(coalesce(CASE WHEN GBICUNITS < 0 THEN GBICUNITS * 1 ELSE GBICUNITS END,0)as double precision) ELSE 0 END AS VL_CONSUMO_CPTE_FATURA_INTERM,
CASE WHEN TARCHARGE.TARC$INV$HEAD$GRP = ''SEWER'' THEN cast(coalesce(CASE WHEN GBICUNITS < 0 THEN GBICUNITS * 1 ELSE GBICUNITS END,0)as double precision) ELSE 0 END AS VL_CONSUMO_ESGOTO_CPTE_FATURA_INTERM


 FROM

"papakura_20221223"."dbo"."GBINVOICE#CHARGES" CF

inner join "papakura_20221223"."dbo"."TARCHARGE" TARCHARGE on TARCHARGE.TARC$CODE =  CF.GBICCHARGE

WHERE CF.GBICCHARGE IS NOT NULL AND TARCHARGE.TARC$CODE IN (SELECT TARC$CODE  FROM TARCHARGE
WHERE TARC$CODE  IN(select DISTINCT T.TARC$CODE from EMS_CON_PLAN#REGISTER_LIST ECPRL
INNER JOIN TARCHARGE T ON T.TARC$CODE = ECPRL.ECPLAN_TARCODE)

)
)

,COMP AS ( SELECT 
MAX(CF.GBICENDDATE) GBICENDDATE,
MAX(CF.GBICPLANID) GBICPLANID,
MAX(CF.GBIINVOICE) GBIINVOICE,
MAX(CF.GBICSTARTDATE) GBICSTARTDATE,


SUM(VL_AGUA_CPTE_FATURA_INTERM) AS VL_AGUA_CPTE_FATURA,
SUM(VL_ESGOTO_CPTE_FATURA_INTERM) AS VL_ESGOTO_CPTE_FATURA,
SUM(VL_SERVICO_BASICO_CPTE_FATURA_INTERM) AS VL_SERVICO_BASICO_CPTE_FATURA,
SUM(VL_CONSUMO_CPTE_FATURA_INTERM) AS VL_CONSUMO_CPTE_FATURA,
SUM(VL_CONSUMO_ESGOTO_CPTE_FATURA_INTERM) AS VL_CONSUMO_ESGOTO_CPTE_FATURA
FROM  COMP_INTERM CF
GROUP BY CF.GBIINVOICE,CF.GBICSTARTDATE



)



SELECT
row_number() over(order by COMP.GBIINVOICE) as ID_FATURA_COMPONENTE,
cast(COMP. VL_AGUA_CPTE_FATURA as decimal(16,2)) / 100  as VL_AGUA_CPTE_FATURA,
cast(COMP.VL_ESGOTO_CPTE_FATURA as decimal(16,2)) / 100  as VL_ESGOTO_CPTE_FATURA,
0.0 as VL_OUTORGA_CPTE_FATURA,
0.0 as VL_REPASSE_ESGOTO_CPTE_FATURA,
0.0 as VL_ESGOTO_OUTORGA_CPTE_FATURA,
cast(VL_SERVICO_BASICO_CPTE_FATURA as decimal(16,2)) / 100  as VL_SERVICO_BASICO,
cast(COMP.VL_CONSUMO_CPTE_FATURA as integer)  as VL_CONSUMO_CPTE_FATURA,
cast(COMP.VL_CONSUMO_ESGOTO_CPTE_FATURA as integer)  as VL_CONSUMO_ESGOTO_CPTE_FATURA,
EC.NU_ECONOMIAS as HIST_NR_ECONOMIA,
0.0 as HIST_CONSUMO_REAL_CATEGORIA,
''N'' as FL_COBRAR_CATEGORIA_SECUNDARIA,
null as FL_PERDA_BENEFICIO_CONSUMO,
null as FL_TARIFA_SOCIAL,
EC.ID_ECONOMIA as ID_ECONOMIA,
FAT.ID_FATURA as ID_FATURA,
1 as CH_TIPO_FATURAMENTO_ESGOTO,
null as VL_CONSUMO_CATEGORIA_SECUNDARIA_CPTE_FATURA,
null as VL_CONSUMO_ESGOTO_CATEGORIA_SECUNDARIA_CPTE_FATURA,
null as VL_AGUA_CATEGORIA_SECUNDARIA_CPTE_FATURA,
null as VL_ESGOTO_CATEGORIA_SECUNDARIA_CPTE_FATURA,

null as QT_CONSUMO_ESGOTO_PARTICULAR,
null as VL_ESGOTO_PARTICULAR,
COMP.GBIINVOICE AS COD_FATURA,
COMP.GBICSTARTDATE,
COMP.GBICENDDATE,
COMP.GBICPLANID,

case 
    when  DATEADD(DAY,1,COMP.GBICSTARTDATE) >= CAST(''1990-01-01 00:00:00.000'' AS DATE) AND COMP.GBICENDDATE <=  CAST(''1999-12-31 00:00:00.000'' AS DATE) then 1
    when  DATEADD(DAY,1,COMP.GBICSTARTDATE) >= CAST(''2000-01-01 00:00:00.000'' AS DATE) AND COMP.GBICENDDATE <=  CAST(''2010-09-30 00:00:00.000'' AS DATE) then 2
    when  DATEADD(DAY,1,COMP.GBICSTARTDATE) >= CAST(''2010-10-01 00:00:00.000'' AS DATE) AND COMP.GBICENDDATE <=  CAST(''2011-06-30 00:00:00.000'' AS DATE) then 3
    when  DATEADD(DAY,1,COMP.GBICSTARTDATE) >= CAST(''2011-07-01 00:00:00.000'' AS DATE) AND COMP.GBICENDDATE <=  CAST(''2012-06-30 00:00:00.000'' AS DATE) then 4
    when  DATEADD(DAY,1,COMP.GBICSTARTDATE) >= CAST(''2012-07-01 00:00:00.000'' AS DATE) AND COMP.GBICENDDATE <=  CAST(''2013-06-30 00:00:00.000'' AS DATE) then 5
    when  DATEADD(DAY,1,COMP.GBICSTARTDATE) >= CAST(''2013-07-01 00:00:00.000'' AS DATE) AND COMP.GBICENDDATE <=  CAST(''2014-06-30 00:00:00.000'' AS DATE) then 6
    when  DATEADD(DAY,1,COMP.GBICSTARTDATE) >= CAST(''2014-07-01 00:00:00.000'' AS DATE) AND COMP.GBICENDDATE <=  CAST(''2015-06-30 00:00:00.000'' AS DATE) then 7
    when  DATEADD(DAY,1,COMP.GBICSTARTDATE) >= CAST(''2015-07-01 00:00:00.000'' AS DATE) AND COMP.GBICENDDATE <=  CAST(''2016-06-30 00:00:00.000'' AS DATE) then 8
    when  DATEADD(DAY,1,COMP.GBICSTARTDATE) >= CAST(''2016-07-01 00:00:00.000'' AS DATE) AND COMP.GBICENDDATE <=  CAST(''2017-06-30 00:00:00.000'' AS DATE) then 9
    when  DATEADD(DAY,1,COMP.GBICSTARTDATE) >= CAST(''2017-07-01 00:00:00.000'' AS DATE) AND COMP.GBICENDDATE <=  CAST(''2018-06-30 00:00:00.000'' AS DATE) then 10
    when  DATEADD(DAY,1,COMP.GBICSTARTDATE) >= CAST(''2018-07-01 00:00:00.000'' AS DATE) AND COMP.GBICENDDATE <=  CAST(''2019-06-30 00:00:00.000'' AS DATE) then 11
    when  DATEADD(DAY,1,COMP.GBICSTARTDATE) >= CAST(''2019-07-01 00:00:00.000'' AS DATE) AND COMP.GBICENDDATE <=  CAST(''2020-06-30 00:00:00.000'' AS DATE) then 12
    when  DATEADD(DAY,1,COMP.GBICSTARTDATE) >= CAST(''2020-07-01 00:00:00.000'' AS DATE) AND COMP.GBICENDDATE <=  CAST(''2021-06-30 00:00:00.000'' AS DATE) then 13
    when  DATEADD(DAY,1,COMP.GBICSTARTDATE) >= CAST(''2021-07-01 00:00:00.000'' AS DATE) AND COMP.GBICENDDATE <=  CAST(''2022-06-30 00:00:00.000'' AS DATE) then 14
    when  DATEADD(DAY,1,COMP.GBICSTARTDATE) >= CAST(''2022-07-01 00:00:00.000'' AS DATE) AND COMP.GBICENDDATE <=  CAST(''2023-06-30 00:00:00.000'' AS DATE) then 15

end AS ID_TABELA_TARIFARIA
FROM COMP

left join "papakura_20221223"."dbo_mig"."stage_fat_fatura" FAT on FAT.NR_FATURA = COMP.GBIINVOICE
inner join "papakura_20221223"."dbo_mig"."cad_economia_adj" EC on EC.CH_MATRICULA_UNIDADE = FAT.CH_MATRICULA_UNIDADE
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."stage_fat_fatura_componente__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."stage_fat_fatura_componente__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."stage_fat_fatura_componente__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."stage_fat_fatura_componente__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_stage_fat_fatura_componente__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_stage_fat_fatura_componente__dbt_tmp')
    )
  DROP index "dbo_mig"."stage_fat_fatura_componente__dbt_tmp".dbo_mig_stage_fat_fatura_componente__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_stage_fat_fatura_componente__dbt_tmp_cci
    ON "dbo_mig"."stage_fat_fatura_componente__dbt_tmp"

   

