WITH
FCCM_TEMP AS (SELECT * FROM {{ref('fin_conta_corrente_movimentacao')}} fccm WHERE CH_TIPO_MOVIMENTACAO_CONTA_CORRENTE in  (40970003,40970008)  )
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