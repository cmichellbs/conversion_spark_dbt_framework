
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."fat_fatura_componente__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."fat_fatura_componente__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."fat_fatura_componente__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."fat_fatura_componente__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."fat_fatura_componente__dbt_tmp_temp_view" as
    

SELECT
row_number() over(order by ID_FATURA) as ID_FATURA_COMPONENTE,
coalesce(sum(VL_AGUA_CPTE_FATURA),0) as VL_AGUA_CPTE_FATURA,
coalesce(sum(VL_ESGOTO_CPTE_FATURA),0) as VL_ESGOTO_CPTE_FATURA,
coalesce(sum(VL_OUTORGA_CPTE_FATURA),0) as VL_OUTORGA_CPTE_FATURA,
coalesce(sum(VL_REPASSE_ESGOTO_CPTE_FATURA),0) as VL_REPASSE_ESGOTO_CPTE_FATURA,
coalesce(sum(VL_ESGOTO_OUTORGA_CPTE_FATURA),0) as VL_ESGOTO_OUTORGA_CPTE_FATURA,
coalesce(sum(VL_SERVICO_BASICO),0) as VL_SERVICO_BASICO,
coalesce(sum(VL_CONSUMO_CPTE_FATURA),0) as VL_CONSUMO_CPTE_FATURA,
coalesce(sum(VL_CONSUMO_ESGOTO_CPTE_FATURA),0) as VL_CONSUMO_ESGOTO_CPTE_FATURA,
coalesce(max(HIST_NR_ECONOMIA),0) as HIST_NR_ECONOMIA,
coalesce(max(HIST_CONSUMO_REAL_CATEGORIA),0) as HIST_CONSUMO_REAL_CATEGORIA,
max(FL_COBRAR_CATEGORIA_SECUNDARIA) as FL_COBRAR_CATEGORIA_SECUNDARIA,
null as FL_PERDA_BENEFICIO_CONSUMO,
null as FL_TARIFA_SOCIAL,
max(ID_ECONOMIA) as ID_ECONOMIA,
max(ID_FATURA) as ID_FATURA,
max(CH_TIPO_FATURAMENTO_ESGOTO) as CH_TIPO_FATURAMENTO_ESGOTO,
null as VL_CONSUMO_CATEGORIA_SECUNDARIA_CPTE_FATURA,
null as VL_CONSUMO_ESGOTO_CATEGORIA_SECUNDARIA_CPTE_FATURA,
null as VL_AGUA_CATEGORIA_SECUNDARIA_CPTE_FATURA,
null as VL_ESGOTO_CATEGORIA_SECUNDARIA_CPTE_FATURA,
null as QT_CONSUMO_ESGOTO_PARTICULAR,
null as VL_ESGOTO_PARTICULAR,
''S'' as MIG_FL_TEMP
FROM
"papakura_20221223"."dbo_mig"."stage_fat_fatura_componente"
group by ID_FATURA
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."fat_fatura_componente__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."fat_fatura_componente__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."fat_fatura_componente__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."fat_fatura_componente__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_fat_fatura_componente__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_fat_fatura_componente__dbt_tmp')
    )
  DROP index "dbo_mig"."fat_fatura_componente__dbt_tmp".dbo_mig_fat_fatura_componente__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_fat_fatura_componente__dbt_tmp_cci
    ON "dbo_mig"."fat_fatura_componente__dbt_tmp"

   

