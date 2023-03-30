
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."fin_conta_corrente_movimentacao_pagamento__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."fin_conta_corrente_movimentacao_pagamento__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."fin_conta_corrente_movimentacao_pagamento__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."fin_conta_corrente_movimentacao_pagamento__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."fin_conta_corrente_movimentacao_pagamento__dbt_tmp_temp_view" as
    SELECT
ap.ID_PAGAMENTO as ID_CONTA_CORRENTE_MOVIMENTACAO_PAGAMENTO,
fccm.ID_CONTA_CORRENTE_MOVIMENTACAO as ID_CONTA_CORRENTE_MOVIMENTACAO,
ap.ID_PAGAMENTO as ID_PAGAMENTO,
ap.VL_DOCUMENTO_ARRECADACAO as VL_BAIXADO,
cast(1 as BIT) as FL_CONCLUIDO
FROM
"papakura_20221223"."dbo_mig"."arr_pagamento" ap
inner join "papakura_20221223"."dbo_mig"."fin_conta_corrente_movimentacao"fccm on fccm.MIG_DKEY_TEMP = ap.MIG_DKEY_TEMP
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."fin_conta_corrente_movimentacao_pagamento__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."fin_conta_corrente_movimentacao_pagamento__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."fin_conta_corrente_movimentacao_pagamento__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."fin_conta_corrente_movimentacao_pagamento__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_fin_conta_corrente_movimentacao_pagamento__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_fin_conta_corrente_movimentacao_pagamento__dbt_tmp')
    )
  DROP index "dbo_mig"."fin_conta_corrente_movimentacao_pagamento__dbt_tmp".dbo_mig_fin_conta_corrente_movimentacao_pagamento__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_fin_conta_corrente_movimentacao_pagamento__dbt_tmp_cci
    ON "dbo_mig"."fin_conta_corrente_movimentacao_pagamento__dbt_tmp"

   

