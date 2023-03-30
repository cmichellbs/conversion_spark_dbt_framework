SELECT
row_number() over(order by ECP.ECPLAN_KEY asc) +10 as ID_CATEGORIA_TIPO_TARIFA,
concat(ECP.ECPLAN_KEY,' - ',ECP.ECPLAN_DESC) as NM_CATEGORIA_TIPO_TARIFA,
cast(0 as BIT) as FL_COBRAR_OUTORGA,
1 as CH_ATIVO,
coalesce(1, 1) as CH_TIPO_TARIFA,
CASE WHEN ECP.ECPLAN_DESC LIKE '%Residential%' OR ECP.ECPLAN_DESC LIKE '%Domestic%' or ECP.ECPLAN_DESC LIKE '%Domestic%'  THEN 1 ELSE 2 END as CH_CATEGORIA_TARIFA,
null as ID_RUBRICA_AGUA,
null as ID_RUBRICA_ESGOTO,
null as ID_RUBRICA_AGUA_DIVIDA_ATIVA,
null as ID_RUBRICA_ESGOTO_DIVIDA_ATIVA,
ECP.ECPLAN_KEY as PLAN_CODE,
ECP.ECPLAN_KEY as MIG_PLAN_CODE_TEMP


FROM
{{source('papakura','EMS_CON_PLAN')}} ECP
