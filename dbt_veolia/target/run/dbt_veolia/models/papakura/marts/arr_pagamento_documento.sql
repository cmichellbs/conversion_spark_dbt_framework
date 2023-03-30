
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."arr_pagamento_documento__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."arr_pagamento_documento__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."arr_pagamento_documento__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."arr_pagamento_documento__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."arr_pagamento_documento__dbt_tmp_temp_view" as
    

SELECT
ROW_NUMBER() OVER(ORDER BY AP.ID_PAGAMENTO) as ID_PAGAMENTO_DOCUMENTO,
AP.VL_VALOR_DEBITO as VL_PAGAMENTO,
AP.DT_PAGAMENTO_DEBITO as DT_PAGAMENTO,
AP.MIG_ID_FATURA as ID_FATURA,
NULL as ID_COBRANCA_DIVERSA,
AP.ID_PAGAMENTO as ID_PAGAMENTO,
NULL as ID_VALOR_DEVOLVIDO,
MIG_ID_CONTA_CORRENTE_MOVIMENTACAO_TEMP as ID_CONTA_CORRENTE_MOVIMENTACAO,
AP.DT_INCLUSAO_SISTEMA as DT_INCLUSAO_SISTEMA
FROM
"papakura_20221223"."dbo_mig"."arr_pagamento" AP
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."arr_pagamento_documento__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."arr_pagamento_documento__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."arr_pagamento_documento__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."arr_pagamento_documento__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_arr_pagamento_documento__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_arr_pagamento_documento__dbt_tmp')
    )
  DROP index "dbo_mig"."arr_pagamento_documento__dbt_tmp".dbo_mig_arr_pagamento_documento__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_arr_pagamento_documento__dbt_tmp_cci
    ON "dbo_mig"."arr_pagamento_documento__dbt_tmp"

   

