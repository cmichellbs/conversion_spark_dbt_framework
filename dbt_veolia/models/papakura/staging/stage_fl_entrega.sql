
select 

CUC.CH_MATRICULA_UNIDADE as CH_MATRICULA_UNIDADE

FROM

{{ref('cad_unidade_comercial')}} CUC 
INNER JOIN {{ref('stage_loc_adj_adj')}} L ON CUC.CH_MATRICULA_UNIDADE = L.LOCA_ITEMID
left join {{ref('cad_endereco')}} CE  on L.SEQNO = CE.ACTID
inner JOIN {{ref('stage_ceuc_consumer')}} CONS ON CONS.CINSTALL = CUC.CH_MATRICULA_UNIDADE
inner JOIN {{ref('stage_loc_adj_adj')}} L2 ON L2.LOCA_ITEMID = CONS.CACCT
inner join {{ref('cad_endereco')}} CE_ALT  on L2.SEQNO = CE_ALT.ACTID
LEFT JOIN {{ref('tab_faixa_logradouro')}} TFL2 ON L2.LOCA_ITEMID = TFL2.ACTID
LEFT JOIN {{ref('tab_faixa_logradouro')}} TFL ON L.LOCA_ITEMID = TFL.ACTID

WHERE  CUC.CH_MATRICULA_UNIDADE  in (SELECT CINSTALL FROM {{ref('stage_ceuc_consumer')}})