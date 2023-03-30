
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."fat_fatura_componente_tabela_tarifaria__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."fat_fatura_componente_tabela_tarifaria__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."fat_fatura_componente_tabela_tarifaria__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."fat_fatura_componente_tabela_tarifaria__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."fat_fatura_componente_tabela_tarifaria__dbt_tmp_temp_view" as
    SELECT
row_number() over(order by FFC2.ID_FATURA)  as ID_FATURA_COMPONENTE_TABELA_TARIFARIA,
CAST(CAST(FFC.VL_AGUA_CPTE_FATURA AS VARCHAR) AS DECIMAL(16,2)) as VL_AGUA,
CAST(CAST(FFC.VL_ESGOTO_CPTE_FATURA AS VARCHAR) AS DECIMAL(16,2)) as VL_ESGOTO,
CAST(CAST(FFC.GBICSTARTDATE AS VARCHAR) AS DATE) as DT_INICIO_CONSUMO,
CAST(CAST(FFC.GBICENDDATE AS VARCHAR) AS DATE) as DT_FIM_CONSUMO,
FFC.VL_CONSUMO_CPTE_FATURA as QT_CONSUMO,
CAST(CAST(TT.ID_TARIFA AS VARCHAR) AS INTEGER) as ID_TARIFA,
CAST(FFC2.ID_FATURA_COMPONENTE AS INTEGER) as ID_FATURA_COMPONENTE,
FFC.COD_FATURA,
FFC.COD_FATURA AS MIG_PK_TEMP
FROM "papakura_20221223"."dbo_mig"."stage_fat_fatura_componente" FFC
inner join "papakura_20221223"."dbo_mig"."fat_fatura_componente" FFC2 ON FFC2.ID_FATURA = FFC.ID_FATURA
-- inner JOIN "papakura_20221223"."dbo_mig"."fat_fatura" FF ON FF.ID_FATURA  = FFC2.ID_FATURA
inner JOIN "papakura_20221223"."dbo_mig"."tab_tarifa" TT ON FFC.ID_TABELA_TARIFARIA  = TT.ID_TABELA_TARIFARIA  AND TT.PLAN_CODE  = FFC.GBICPLANID
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."fat_fatura_componente_tabela_tarifaria__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."fat_fatura_componente_tabela_tarifaria__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."fat_fatura_componente_tabela_tarifaria__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."fat_fatura_componente_tabela_tarifaria__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_fat_fatura_componente_tabela_tarifaria__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_fat_fatura_componente_tabela_tarifaria__dbt_tmp')
    )
  DROP index "dbo_mig"."fat_fatura_componente_tabela_tarifaria__dbt_tmp".dbo_mig_fat_fatura_componente_tabela_tarifaria__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_fat_fatura_componente_tabela_tarifaria__dbt_tmp_cci
    ON "dbo_mig"."fat_fatura_componente_tabela_tarifaria__dbt_tmp"

   

