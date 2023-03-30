
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."tab_tabela_tarifaria_servico__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."tab_tabela_tarifaria_servico__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."tab_tabela_tarifaria_servico__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."tab_tabela_tarifaria_servico__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."tab_tabela_tarifaria_servico__dbt_tmp_temp_view" as
    SELECT
100 as CH_TABELA_TARIFARIA_SERVICO,
''2022/2099'' as NM_TABELA_TARIFARIA_SERVICO,
1 as CH_ATIVO,

''S'' as MIG_FL_TEMP
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."tab_tabela_tarifaria_servico__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."tab_tabela_tarifaria_servico__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."tab_tabela_tarifaria_servico__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."tab_tabela_tarifaria_servico__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_tab_tabela_tarifaria_servico__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_tab_tabela_tarifaria_servico__dbt_tmp')
    )
  DROP index "dbo_mig"."tab_tabela_tarifaria_servico__dbt_tmp".dbo_mig_tab_tabela_tarifaria_servico__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_tab_tabela_tarifaria_servico__dbt_tmp_cci
    ON "dbo_mig"."tab_tabela_tarifaria_servico__dbt_tmp"

   

