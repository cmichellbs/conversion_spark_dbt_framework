SELECT
ROW_NUMBER() OVER(ORDER BY FF.ID_FATURA ) as ID_CONTA_CORRENTE_MOVIMENTACAO_FATURA,
FCCM.ID_CONTA_CORRENTE_MOVIMENTACAO as ID_CONTA_CORRENTE_MOVIMENTACAO,
FF.ID_FATURA as ID_FATURA



FROM "papakura_20221223"."dbo_mig"."stage_fin_conta_corrente_movimentacao_adj" FCCM

inner JOIN "papakura_20221223"."dbo_mig"."fat_fatura" FF ON FF.NR_FATURA = FCCM.INVOICE