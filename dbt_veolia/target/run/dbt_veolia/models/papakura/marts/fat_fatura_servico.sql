
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."fat_fatura_servico__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."fat_fatura_servico__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."fat_fatura_servico__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."fat_fatura_servico__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."fat_fatura_servico__dbt_tmp_temp_view" as
    

SELECT
row_number() over(order by FPSU.ID_PARCELA_SERVICO_UNIDADE) as ID_FATURA_SERVICO,
FPSU.DT_SITUACAO_PARCELA as DT_GRAVACAO_SERVICO_FATURA,
''N'' as FL_SERVICO_DOACAO,
''N'' as FL_SERVICO_INSUMO,
FF.ID_FATURA as ID_FATURA,
FPSU.ID_PARCELA_SERVICO_UNIDADE as ID_PARCELA_SERVICO_UNIDADE,
FF.NR_FATURA AS MIG_PK_TEMP
FROM 
"papakura_20221223"."dbo_mig"."fat_fatura" FF
inner join "papakura_20221223"."dbo_mig"."fat_parcela_servico_unidade"FPSU ON FPSU.MIG_ID_FATURA_TEMP = FF.NR_FATURA
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."fat_fatura_servico__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."fat_fatura_servico__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."fat_fatura_servico__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."fat_fatura_servico__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_fat_fatura_servico__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_fat_fatura_servico__dbt_tmp')
    )
  DROP index "dbo_mig"."fat_fatura_servico__dbt_tmp".dbo_mig_fat_fatura_servico__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_fat_fatura_servico__dbt_tmp_cci
    ON "dbo_mig"."fat_fatura_servico__dbt_tmp"

   

