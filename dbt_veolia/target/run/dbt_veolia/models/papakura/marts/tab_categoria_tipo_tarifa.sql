
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."tab_categoria_tipo_tarifa__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."tab_categoria_tipo_tarifa__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."tab_categoria_tipo_tarifa__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."tab_categoria_tipo_tarifa__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."tab_categoria_tipo_tarifa__dbt_tmp_temp_view" as
    SELECT
row_number() over(order by ECP.ECPLAN_KEY asc) +10 as ID_CATEGORIA_TIPO_TARIFA,
concat(ECP.ECPLAN_KEY,'' - '',ECP.ECPLAN_DESC) as NM_CATEGORIA_TIPO_TARIFA,
cast(0 as BIT) as FL_COBRAR_OUTORGA,
1 as CH_ATIVO,
coalesce(1, 1) as CH_TIPO_TARIFA,
CASE WHEN ECP.ECPLAN_DESC LIKE ''%Residential%'' OR ECP.ECPLAN_DESC LIKE ''%Domestic%'' or ECP.ECPLAN_DESC LIKE ''%Domestic%''  THEN 1 ELSE 2 END as CH_CATEGORIA_TARIFA,
null as ID_RUBRICA_AGUA,
null as ID_RUBRICA_ESGOTO,
null as ID_RUBRICA_AGUA_DIVIDA_ATIVA,
null as ID_RUBRICA_ESGOTO_DIVIDA_ATIVA,
ECP.ECPLAN_KEY as PLAN_CODE,
ECP.ECPLAN_KEY as MIG_PLAN_CODE_TEMP


FROM
"papakura_20221223"."dbo"."EMS_CON_PLAN" ECP
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."tab_categoria_tipo_tarifa__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."tab_categoria_tipo_tarifa__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."tab_categoria_tipo_tarifa__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."tab_categoria_tipo_tarifa__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_tab_categoria_tipo_tarifa__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_tab_categoria_tipo_tarifa__dbt_tmp')
    )
  DROP index "dbo_mig"."tab_categoria_tipo_tarifa__dbt_tmp".dbo_mig_tab_categoria_tipo_tarifa__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_tab_categoria_tipo_tarifa__dbt_tmp_cci
    ON "dbo_mig"."tab_categoria_tipo_tarifa__dbt_tmp"

   

