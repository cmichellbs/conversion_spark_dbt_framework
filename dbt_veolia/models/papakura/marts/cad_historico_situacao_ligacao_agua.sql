SELECT
cula.CH_MOTIVO_SITUACAO_LIGACAO_AGUA as ID_SITUACAO_ANTERIOR_LIGACAO,
cula.CH_MOTIVO_SITUACAO_LIGACAO_AGUA  as ID_SITUACAO_ATUAL_LIGACAO,
cula.DT_SITUACAO_LIGACAO_AGUA as DT_SITUACAO_ANTERIOR_LIGACAO,
cula.DT_SITUACAO_LIGACAO_AGUA as DT_SITUACAO_ATUAL_LIGACAO,
null as NR_LEITURA_SITUACAO_LIGACAO,
cast(GETDATE() as varchar) as DT_GRAVACAO_HISTORICO,
cula.ID_UNIDADE_LIGACAO_AGUA as ID_UNIDADE_LIGACAO_AGUA,
null as ID_SERVICO,
cast(0 as BIT) as FL_RECORTE
from {{ref('cad_unidade_ligacao_agua')}} cula