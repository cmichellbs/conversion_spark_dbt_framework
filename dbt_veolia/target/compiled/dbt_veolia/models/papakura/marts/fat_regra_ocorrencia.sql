SELECT
coalesce('N', 'STRING') as FL_EXISTE_LEITURA,
coalesce(1, 0) as CH_TIPO_LEITURA,
null as CH_TIPO_MEDIA,
coalesce(2, 0) as CH_TIPO_CONSUMO_FATURADO,
1 as CH_ATIVO,
coalesce(1, 0) as CH_TIPO_CONSUMO_LIDO,
coalesce(8, 8) as ID_OCORRENCIA_LEITURA