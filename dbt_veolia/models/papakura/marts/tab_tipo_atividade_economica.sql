SELECT
row_number() over(order by nzed.DESCRIPTION) +20 as CH_TIPO_ATIVIDADE_ECONOMICA,
coalesce(nzed.DESCRIPTION, 'STRING') as NM_TIPO_ATIVIDADE_ECONOMICA,
null as FL_INDUSTRIA,
1 as CH_ATIVO,
null as CH_CATEGORIA_TARIFA,
null as QT_CONSUMO,
nzed.CODE as PLAN_CODE,
nzed.CODE as MIG_PLAN_CODE_TEMP

FROM

{{source('papakura','EMS_NZED')}} nzed