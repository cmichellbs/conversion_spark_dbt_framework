
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."fat_data_estagio__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."fat_data_estagio__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."fat_data_estagio__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."fat_data_estagio__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."fat_data_estagio__dbt_tmp_temp_view" as
    with CTE AS (SELECT
cast(concat(year(FCF.DT_CALENDARIO_MESANO_REF),concat(''-'',concat(month(FCF.DT_CALENDARIO_MESANO_REF),concat(''-'',01)))) as date)  as DATA_ESTAGIO,
1 as ID_ESTAGIO,
FCF.ID_CALENDARIO_FATURAMENTO as ID_CALENDARIO_FATURAMENTO

FROM
"papakura_20221223"."dbo_mig"."fat_calendario_faturamento" FCF

UNION

SELECT
cast(concat(year(FCF.DT_CALENDARIO_MESANO_REF),concat(''-'',concat(month(FCF.DT_CALENDARIO_MESANO_REF),concat(''-'',01)))) as date)  as DATA_ESTAGIO,
3 as ID_ESTAGIO,
FCF.ID_CALENDARIO_FATURAMENTO as ID_CALENDARIO_FATURAMENTO

FROM
"papakura_20221223"."dbo_mig"."fat_calendario_faturamento" FCF

UNION

SELECT
cast(concat(year(FCF.DT_CALENDARIO_MESANO_REF),concat(''-'',concat(month(FCF.DT_CALENDARIO_MESANO_REF),concat(''-'',02)))) as date)  as DATA_ESTAGIO,
4 as ID_ESTAGIO,
FCF.ID_CALENDARIO_FATURAMENTO as ID_CALENDARIO_FATURAMENTO

FROM
"papakura_20221223"."dbo_mig"."fat_calendario_faturamento" FCF

UNION

SELECT
cast(concat(year(FCF.DT_CALENDARIO_MESANO_REF),concat(''-'',concat(month(FCF.DT_CALENDARIO_MESANO_REF),concat(''-'',02)))) as date)  as DATA_ESTAGIO,
5 as ID_ESTAGIO,
FCF.ID_CALENDARIO_FATURAMENTO as ID_CALENDARIO_FATURAMENTO

FROM
"papakura_20221223"."dbo_mig"."fat_calendario_faturamento" FCF

UNION

SELECT
cast(concat(year(FCF.DT_CALENDARIO_MESANO_REF),concat(''-'',concat(month(FCF.DT_CALENDARIO_MESANO_REF),concat(''-'',03)))) as date)  as DATA_ESTAGIO,
6 as ID_ESTAGIO,
FCF.ID_CALENDARIO_FATURAMENTO as ID_CALENDARIO_FATURAMENTO

FROM
"papakura_20221223"."dbo_mig"."fat_calendario_faturamento" FCF)

SELECT *,ROW_NUMBER() OVER(ORDER BY DATA_ESTAGIO)  AS ID_DATA_ESTAGIO FROM CTE
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."fat_data_estagio__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."fat_data_estagio__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."fat_data_estagio__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."fat_data_estagio__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_fat_data_estagio__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_fat_data_estagio__dbt_tmp')
    )
  DROP index "dbo_mig"."fat_data_estagio__dbt_tmp".dbo_mig_fat_data_estagio__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_fat_data_estagio__dbt_tmp_cci
    ON "dbo_mig"."fat_data_estagio__dbt_tmp"

   

