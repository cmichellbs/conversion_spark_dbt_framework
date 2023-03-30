select FCCM.ID_CONTA_CORRENTE_MOVIMENTACAO, FCCM.INVOICE
FROM "papakura_20221223"."dbo_mig"."fin_conta_corrente_movimentacao" FCCM
WHERE FCCM.DTYPE = 'FATURA'