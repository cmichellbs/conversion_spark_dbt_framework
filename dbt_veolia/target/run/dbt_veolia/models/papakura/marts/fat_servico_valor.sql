
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."fat_servico_valor__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."fat_servico_valor__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."fat_servico_valor__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."fat_servico_valor__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."fat_servico_valor__dbt_tmp_temp_view" as
    SELECT
row_number() over(order by TSD.ID_SERVICO_DEFINICAO) as ID_SERVICO_VALOR,
COALESCE(ETC.GL_DEFAULTAMT,0)/100 as VL_SERVICO,
GETDATE() as DT_VALOR_SERVICO,
cast(0 as BIT) as FL_TARIFA_DIFERENCIADA,
100 as CH_TABELA_TARIFARIA_SERVICO,
TSD.ID_SERVICO_DEFINICAO as ID_SERVICO_DEFINICAO,
0.0 as VL_SERVICO_A_VISTA,

''S'' as MIG_FL_TEMP
FROM
"papakura_20221223"."dbo_mig"."tab_servico_definicao" TSD 
INNER JOIN "papakura_20221223"."dbo"."EMS_TRANS_CODES" ETC ON ETC.GL_ID = TSD.MIG_GL_ID_TEMP
inner join "papakura_20221223"."dbo_mig"."tab_tabela_tarifaria_servico" TTTS on TTTS.CH_TABELA_TARIFARIA_SERVICO = 100
WHERE TSD.MIG_SERVICO_TABELADO_TEMP = ''S''
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."fat_servico_valor__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."fat_servico_valor__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."fat_servico_valor__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."fat_servico_valor__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_fat_servico_valor__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_fat_servico_valor__dbt_tmp')
    )
  DROP index "dbo_mig"."fat_servico_valor__dbt_tmp".dbo_mig_fat_servico_valor__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_fat_servico_valor__dbt_tmp_cci
    ON "dbo_mig"."fat_servico_valor__dbt_tmp"

   

