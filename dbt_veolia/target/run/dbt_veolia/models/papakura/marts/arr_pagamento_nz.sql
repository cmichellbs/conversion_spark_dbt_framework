
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."arr_pagamento_nz__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."arr_pagamento_nz__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."arr_pagamento_nz__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."arr_pagamento_nz__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."arr_pagamento_nz__dbt_tmp_temp_view" as
    with base as (SELECT

EMREFLEDGER as NR_SERIAL,
coalesce(EMREF1, '''') as DS_INFORMACOES,
EMREF2 as CD_ANALISE,
EMREF3 as DS_REFERENCIA,
EMOTHERPARTY as NM_PARTE,
AP.ID_PAGAMENTO as ID_PAGAMENTO,
''S'' as MIG_FL_TEMP
FROM
"papakura_20221223"."dbo"."EMS_BANK_XREF" EBX
INNER JOIN "papakura_20221223"."dbo"."DEBT" DEBT ON CONCAT(EMREF1,'':'',EMREF2,'':'',EMREF3,'':'',EMOTHERPARTY) = DEXTDESC
INNER JOIN "papakura_20221223"."dbo_mig"."arr_pagamento" AP ON AP.MIG_DKEY_TEMP = DEBT.DKEY)

select * from base
-- order by ID_PAGAMENTO
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."arr_pagamento_nz__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."arr_pagamento_nz__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."arr_pagamento_nz__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."arr_pagamento_nz__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_arr_pagamento_nz__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_arr_pagamento_nz__dbt_tmp')
    )
  DROP index "dbo_mig"."arr_pagamento_nz__dbt_tmp".dbo_mig_arr_pagamento_nz__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_arr_pagamento_nz__dbt_tmp_cci
    ON "dbo_mig"."arr_pagamento_nz__dbt_tmp"

   

