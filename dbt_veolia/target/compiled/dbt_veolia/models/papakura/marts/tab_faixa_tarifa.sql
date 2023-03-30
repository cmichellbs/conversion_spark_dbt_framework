WITH 
TC AS (SELECT TC.*,

CASE 
	WHEN TC.TARC$CODE       NOT 
	IN (SELECT DISTINCT CRAT$CODE FROM TARRATE)
	THEN TC.TARC$TEMPLATE ELSE TC.TARC$CODE 
END AS TARC$CODE2



FROM "papakura_20221223"."dbo"."TARCHARGE" TC
)


SELECT
row_number() over(order by tt.ID_TARIFA) as ID_FAIXA_TARIFA,
coalesce(ttt.vl_referencial_agua, 0.0) as VL_FAIXA_TARIFA,
null as VL_FAIXA_TARIFA_OUTORGA,
tt.VL_PERCENTUAL_ESGOTO_TRATADO as VL_PERCENTUAL_ESGOTO_TRATADO,
tt.VL_PERCENTUAL_ESGOTO_COLETADO as VL_PERCENTUAL_ESGOTO_COLETADO,
null as VL_PERCENTUAL_ESGOTO_OUTORGA,
null as VL_DESCONTO,
null as VL_FATOR_MULTIPLICADOR_AGUA,
null as VL_FATOR_MULTIPLICADOR_ESGOTO_COLETADO,
null as VL_FATOR_MULTIPLICADOR_ESGOTO_TRATADO,
999999999 as NU_LIMITE_SUPERIOR,
coalesce(1, 0) as NU_LIMITE_INFERIOR,
coalesce(1, 0) as NU_FAIXA,
null as VL_SERVICO_BASICO,
1 as CH_ATIVO,
coalesce(tt.ID_TARIFA, 0) as ID_TARIFA,
null as VL_TARIFA_LIXO,
coalesce(sst.SEWER_TARIFF/1000000,0) AS VL_TARIFA_ESGOTO,
ttt.VL_TARIFA_MINIMA AS VL_TAXA_MINIMA,
tt.PLAN_CODE as MIG_PK_TEMP,
ttt.id_tabela_tarifaria as MIG_ID_TABELA_TARIFARIA_TEMP,
ecpfl.ECPLAN_FCHGCODE

FROM
"papakura_20221223"."dbo_mig"."tab_tarifa" tt
left join "papakura_20221223"."dbo_mig"."tab_tabela_tarifaria" ttt on ttt.id_tabela_tarifaria = tt.ID_TABELA_TARIFARIA
left join "papakura_20221223"."dbo_mig"."stage_sewer_tariff" sst on sst.ECPLAN_KEY =  tt.PLAN_CODE and ttt.DT_INICIO_VIGENCIA = sst.CRAT$DATE
-- LEFT JOIN FIXED as ecpfl on ecpfl.ECPLAN_KEY = tt.PLAN_CODE
left join "papakura_20221223"."dbo"."EMS_CON_PLAN#FIXED_LIST" ecpfl on ecpfl.ECPLAN_KEY = tt.PLAN_CODE
left join TC ON TC.TARC$CODE= ecpfl.ECPLAN_FCHGCODE