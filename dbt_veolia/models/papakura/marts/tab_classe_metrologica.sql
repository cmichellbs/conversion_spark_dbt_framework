SELECT
TOP 1
coalesce(ASM$PRODUCT, 'STRING') as CD_CLASSE_METROLOGICA,
coalesce('default', 'STRING') as DS_CLASSE_METROLOGICA
FROM
{{source('papakura','ASSETMASTER')}}