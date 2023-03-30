
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."cad_fechamentos__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."cad_fechamentos__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."cad_fechamentos__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."cad_fechamentos__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."cad_fechamentos__dbt_tmp_temp_view" as
    


WITH REFERENCIAS AS (SELECT DISTINCT DT_MESANO_REF FROM "papakura_20221223"."dbo_mig"."stage_fat_fatura" fat)

,final as(
SELECT
DT_MESANO_REF as MES_REFERENCIA,
DATEADD(MONTH,1,DT_MESANO_REF) as DT_REAL_FECHAMENTO,
CASE WHEN DATEDIFF(month,DT_MESANO_REF,cast(concat(year(GETDATE()),concat(''-'',concat(month(GETDATE()),concat(''-'',01)))) as date)) = 0
THEN ''N'' ELSE ''S'' end as FL_FECHAMENTO_REALIZADO,
NULL as NR_ESTAGIO,
3 as CH_PROCESSO,
''S'' as MIG_PK_TEMP,
''S'' as ORIGEM_MIG

FROM
REFERENCIAS

union ALL

SELECT
DT_MESANO_REF as MES_REFERENCIA,
DATEADD(MONTH,1,DT_MESANO_REF) as DT_REAL_FECHAMENTO,
CASE WHEN DATEDIFF(month,DT_MESANO_REF,cast(concat(year(GETDATE()),concat(''-'',concat(month(GETDATE()),concat(''-'',01)))) as date)) = 0
THEN ''N'' ELSE ''S'' end as FL_FECHAMENTO_REALIZADO,
NULL as NR_ESTAGIO,
4 as CH_PROCESSO,
''S'' as MIG_PK_TEMP,
''S'' as ORIGEM_MIG

FROM
REFERENCIAS



union ALL

SELECT

DT_MESANO_REF as MES_REFERENCIA,
DATEADD(MONTH,1,DT_MESANO_REF) as DT_REAL_FECHAMENTO,
CASE WHEN DATEDIFF(month,DT_MESANO_REF,cast(concat(year(GETDATE()),concat(''-'',concat(month(GETDATE()),concat(''-'',01)))) as date)) = 0
THEN ''N'' ELSE ''S'' end as FL_FECHAMENTO_REALIZADO,
NULL as NR_ESTAGIO,
30 as CH_PROCESSO,
''S'' as MIG_PK_TEMP,
''S'' as ORIGEM_MIG

FROM
REFERENCIAS
)

select *,ROW_NUMBER() OVER(ORDER BY MES_REFERENCIA asc, CH_PROCESSO ASC) as ID_FECHAMENTOS from final
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."cad_fechamentos__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."cad_fechamentos__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."cad_fechamentos__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."cad_fechamentos__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_cad_fechamentos__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_cad_fechamentos__dbt_tmp')
    )
  DROP index "dbo_mig"."cad_fechamentos__dbt_tmp".dbo_mig_cad_fechamentos__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_cad_fechamentos__dbt_tmp_cci
    ON "dbo_mig"."cad_fechamentos__dbt_tmp"

   

