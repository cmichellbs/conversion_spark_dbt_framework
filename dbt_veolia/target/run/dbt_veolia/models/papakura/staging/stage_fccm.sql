
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."stage_fccm__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."stage_fccm__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."stage_fccm__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."stage_fccm__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."stage_fccm__dbt_tmp_temp_view" as
    WITH
FCCM_TEMP AS (SELECT * FROM "papakura_20221223"."dbo_mig"."fin_conta_corrente_movimentacao" fccm WHERE CH_TIPO_MOVIMENTACAO_CONTA_CORRENTE in  (40970003,40970008)  )
,FCCM AS (select t.*,
       coalesce(max(case when immediate_prev_cost_center <> MIG_STATEMENT_TEMP then immediate_prev_cost_center
           end) over (partition by MIG_LEDGERID_TEMP, MIG_STATEMENT_TEMP, (seqnum - seqnum_2)
                     ),immediate_prev_cost_center) as MIG_STATEMENT_TEMP_ADJ
  from (select t.*,
               row_number() over (partition by MIG_LEDGERID_TEMP order by NR_SEQUENCIAL_REGISTRO ) as seqnum,
               row_number() over (partition by MIG_LEDGERID_TEMP, MIG_STATEMENT_TEMP order by NR_SEQUENCIAL_REGISTRO ) as seqnum_2,
               lag(MIG_STATEMENT_TEMP) over (partition by MIG_LEDGERID_TEMP order by NR_SEQUENCIAL_REGISTRO ) as immediate_prev_cost_center
        from FCCM_TEMP t
        
       ) t 
)

select * from FCCM
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."stage_fccm__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."stage_fccm__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."stage_fccm__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."stage_fccm__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_stage_fccm__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_stage_fccm__dbt_tmp')
    )
  DROP index "dbo_mig"."stage_fccm__dbt_tmp".dbo_mig_stage_fccm__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_stage_fccm__dbt_tmp_cci
    ON "dbo_mig"."stage_fccm__dbt_tmp"

   

