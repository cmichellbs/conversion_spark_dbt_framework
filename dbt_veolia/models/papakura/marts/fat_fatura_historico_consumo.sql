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

{{ref('fat_fatura')}} FF
INNER join {{ref('fat_consumo_agua')}} FCA on FCA.idseq = FF.NR_FATURA