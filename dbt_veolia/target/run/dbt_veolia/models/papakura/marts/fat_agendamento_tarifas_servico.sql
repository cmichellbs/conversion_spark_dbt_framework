
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."fat_agendamento_tarifas_servico__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."fat_agendamento_tarifas_servico__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."fat_agendamento_tarifas_servico__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."fat_agendamento_tarifas_servico__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."fat_agendamento_tarifas_servico__dbt_tmp_temp_view" as
    SELECT
100 as ID_AGENDAMENTO_TARIFAS_SERVICO,
''2022-07-01'' as DT_INICIO_VIGENCIA_TARIFA,
''2099-06-30'' as DT_FINAL_VIGENCIA_TARIFA,
100002 as ID_ESTRUTURA_EMPRESA,
100 as CH_TABELA_TARIFARIA_SERVICO,

''S'' as MIG_FL_TEMP
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."fat_agendamento_tarifas_servico__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."fat_agendamento_tarifas_servico__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."fat_agendamento_tarifas_servico__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."fat_agendamento_tarifas_servico__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_fat_agendamento_tarifas_servico__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_fat_agendamento_tarifas_servico__dbt_tmp')
    )
  DROP index "dbo_mig"."fat_agendamento_tarifas_servico__dbt_tmp".dbo_mig_fat_agendamento_tarifas_servico__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_fat_agendamento_tarifas_servico__dbt_tmp_cci
    ON "dbo_mig"."fat_agendamento_tarifas_servico__dbt_tmp"

   

