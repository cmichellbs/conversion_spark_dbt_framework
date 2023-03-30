
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."cad_dia_vencimento_alternativo__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."cad_dia_vencimento_alternativo__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."cad_dia_vencimento_alternativo__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."cad_dia_vencimento_alternativo__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."cad_dia_vencimento_alternativo__dbt_tmp_temp_view" as
    
SELECT
row_number() over(order by fgf.ID_GRUPO_FATURAMENTO) as ID_DIA_VENCIMENTO_ALTERNATIVO,
0 as DT_DIA,
1 as PRIORIDADE,
1 as CH_ATIVO,
fgf.ID_GRUPO_FATURAMENTO as ID_GRUPO_FATURAMENTO,

''S'' as MIG_FL_TEMP
FROM
"papakura_20221223"."dbo_mig"."fat_grupo_faturamento" fgf
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."cad_dia_vencimento_alternativo__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."cad_dia_vencimento_alternativo__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."cad_dia_vencimento_alternativo__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."cad_dia_vencimento_alternativo__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_cad_dia_vencimento_alternativo__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_cad_dia_vencimento_alternativo__dbt_tmp')
    )
  DROP index "dbo_mig"."cad_dia_vencimento_alternativo__dbt_tmp".dbo_mig_cad_dia_vencimento_alternativo__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_cad_dia_vencimento_alternativo__dbt_tmp_cci
    ON "dbo_mig"."cad_dia_vencimento_alternativo__dbt_tmp"

   

