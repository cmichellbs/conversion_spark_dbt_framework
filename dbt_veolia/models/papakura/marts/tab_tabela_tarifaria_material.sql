SELECT
99 as ID_TABELA_TARIFARIA_MATERIAL,
coalesce(null, 'STRING') as NM_TABELA_TARIFARIA_MATERIAL,
coalesce(null, getdate()) as DT_INICIO_VIGENCIA,
coalesce(null, getdate()) as DT_FINAL_VIGENCIA,
coalesce(null, 100002) as ID_ESTRUTURA_EMPRESA,
coalesce(null, 1) as CH_ATIVO
