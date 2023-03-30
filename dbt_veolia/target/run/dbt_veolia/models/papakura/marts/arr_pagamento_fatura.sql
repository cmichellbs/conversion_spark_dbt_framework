
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."arr_pagamento_fatura__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."arr_pagamento_fatura__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."arr_pagamento_fatura__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."arr_pagamento_fatura__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."arr_pagamento_fatura__dbt_tmp_temp_view" as
    

SELECT
ROW_NUMBER() OVER(ORDER BY AP.ID_PAGAMENTO) as ID_PAGAMENTO_FATURA,
FF.CH_SITUACAO_FATURA as CH_SITUACAO_FATURA,
FF.ID_FATURA as ID_FATURA,
AP.ID_PAGAMENTO as ID_PAGAMENTO
FROM
"papakura_20221223"."dbo_mig"."arr_pagamento" AP
inner join "papakura_20221223"."dbo"."GBINVOICE" GBI on GBI.GBISTATEMENT_NO = AP.MIG_STATEMENT_TEMP
INNER join "papakura_20221223"."dbo_mig"."fat_fatura" FF on FF.NR_FATURA = GBI.GBIINVOICE
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."arr_pagamento_fatura__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."arr_pagamento_fatura__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."arr_pagamento_fatura__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."arr_pagamento_fatura__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_arr_pagamento_fatura__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_arr_pagamento_fatura__dbt_tmp')
    )
  DROP index "dbo_mig"."arr_pagamento_fatura__dbt_tmp".dbo_mig_arr_pagamento_fatura__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_arr_pagamento_fatura__dbt_tmp_cci
    ON "dbo_mig"."arr_pagamento_fatura__dbt_tmp"

   

