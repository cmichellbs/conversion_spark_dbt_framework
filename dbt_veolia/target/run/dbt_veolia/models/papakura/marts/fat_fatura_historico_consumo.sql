
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."fat_fatura_historico_consumo__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."fat_fatura_historico_consumo__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."fat_fatura_historico_consumo__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."fat_fatura_historico_consumo__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."fat_fatura_historico_consumo__dbt_tmp_temp_view" as
    SELECT
row_number() over(order by FF.ID_FATURA) as ID_FATURA_HISTORICO_CONSUMO,
FCA.DT_MES_REF_CONSUMO as DT_MES_REF_HISTORICO_CONSUMO,
FCA.QT_VOLUME_FATURADO as QT_VOLUME_FATURADO_HISTORICO,
FCA.QT_VOLUME_REAL as QT_VOLUME_REAL_HISTORICO,
FCA.CH_TIPO_CONSUMO_FATURADO as CD_TIPO_CONSUMO_HISTORICO,
null as CD_OCORRENCIA_HISTORICO,
FCA.QT_DIAS_CONSUMO as QT_DIAS_CONSUMO,
FF.ID_FATURA as ID_FATURA,
FF.NR_FATURA AS MIG_PK_TEMP
from

"papakura_20221223"."dbo_mig"."fat_fatura" FF
INNER join "papakura_20221223"."dbo_mig"."fat_consumo_agua" FCA on FCA.idseq = FF.NR_FATURA
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."fat_fatura_historico_consumo__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."fat_fatura_historico_consumo__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."fat_fatura_historico_consumo__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."fat_fatura_historico_consumo__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_fat_fatura_historico_consumo__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_fat_fatura_historico_consumo__dbt_tmp')
    )
  DROP index "dbo_mig"."fat_fatura_historico_consumo__dbt_tmp".dbo_mig_fat_fatura_historico_consumo__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_fat_fatura_historico_consumo__dbt_tmp_cci
    ON "dbo_mig"."fat_fatura_historico_consumo__dbt_tmp"

   

