
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."stage_final_neg_fat__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."stage_final_neg_fat__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."stage_final_neg_fat__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."stage_final_neg_fat__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."stage_final_neg_fat__dbt_tmp_temp_view" as
    with 
base as (select DINVOICEREF AS GBIINVOICE,
sum(cast(DAMT as decimal(16,2)))/ 100 as DAMT,
sum(cast(DPAID as decimal(16,2)))/100 as DPAID, 
sum(cast(DBAL as decimal(16,2)))/100 as DBAL , 
case when ((sum(cast(DAMT as decimal(16,2)))/ 100)- (sum(cast(DPAID as decimal(16,2)))/ 100)) > 0 then 0 else 1 end as STATUS_PAGO,
case when max(left(DREF,3)) = ''Rev'' or min(left(DREF,3)) = ''Rev'' then 1 else 0 end as cancelado

from "papakura_20221223"."dbo"."DEBT" d 
where DINVOICEREF is not NULL 
group by DINVOICEREF)

,NEG_FAT AS (SELECT GBI.GBIINVOICE,GBI.GBILEDGER , GBI.GBICUR_NO_DAYS, GBI.GBITOT_DOLLAR as TOT_DOLLAR, GBI.GBIREV_TYPE ,
LAG(GBI.GBITOT_DOLLAR) OVER(PARTITION BY GBI.GBILEDGER ORDER BY GBI.GBIINVOICE DESC) FAT_ANTERIOR,
GBI.GBITOT_DOLLAR + LAG(GBI.GBITOT_DOLLAR) OVER(PARTITION BY GBI.GBILEDGER ORDER BY GBI.GBIINVOICE DESC) AS DIF_FATURAS,
CASE 
	WHEN GBIREV_TYPE IS NOT NULL OR (GBI.GBICUR_NO_DAYS + LAG(GBI.GBICUR_NO_DAYS) OVER(PARTITION BY GBI.GBILEDGER ORDER BY GBI.GBIINVOICE ASC)) = 0 OR (GBI.GBICUR_NO_DAYS + LAG(GBI.GBICUR_NO_DAYS) OVER(PARTITION BY GBI.GBILEDGER ORDER BY GBI.GBIINVOICE DESC)) = 0 or (GBI.GBITOT_DOLLAR + LAG(GBI.GBITOT_DOLLAR) OVER(PARTITION BY GBI.GBILEDGER ORDER BY GBI.GBIINVOICE DESC)) IN (0,1) OR (GBI.GBICUR_NO_DAYS + LAG(GBI.GBICUR_NO_DAYS) OVER(PARTITION BY GBI.GBILEDGER ORDER BY GBI.GBIINVOICE ASC)) IN (0,1) OR GBI.GBITOT_DOLLAR < 0  or GBI.GBIREV_TYPE is not null THEN 
1 	ELSE 0 END AS REVERSED,

base.STATUS_PAGO,
base.DPAID,
base.DBAL,
base.cancelado



FROM GBINVOICE GBI
left join base on base.GBIINVOICE = GBI.GBIINVOICE
--WHERE GBILEDGER IN (100009107)
)


,FINAL_NEG_FAT AS (SELECT * FROM NEG_FAT 
-- WHERE REVERSED = 1
) 


select * from FINAL_NEG_FAT
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."stage_final_neg_fat__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."stage_final_neg_fat__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."stage_final_neg_fat__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."stage_final_neg_fat__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_stage_final_neg_fat__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_stage_final_neg_fat__dbt_tmp')
    )
  DROP index "dbo_mig"."stage_final_neg_fat__dbt_tmp".dbo_mig_stage_final_neg_fat__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_stage_final_neg_fat__dbt_tmp_cci
    ON "dbo_mig"."stage_final_neg_fat__dbt_tmp"

   

