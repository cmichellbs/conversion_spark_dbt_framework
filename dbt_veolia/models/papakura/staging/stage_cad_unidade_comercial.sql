

with gpfat as (
    select  
cast(case 
	when cast(substring(cast(r.RSD$READSEQ as varchar), 1,3) as varchar) = '000' then '001' 
    when cast(substring(cast(r.RSD$READSEQ as varchar), 1,3) as varchar) = 'HOL' then '099'
    else cast(substring(cast(r.RSD$READSEQ as varchar), 1,3) as varchar)
end as integer ) as id_grupo_faturamento,  
i.INSTALL as INSTALL
from {{source('papakura','GBREADSEQ')}} r 
inner join {{source('papakura','INSTALL')}} i on cast(i.INSTALL as varchar) = cast(r.RSD$INSTALL as varchar)

)

,CORRENTE_INTERM AS(SELECT *, ROW_NUMBER() OVER(PARTITION BY CINSTALL ORDER BY CONSUMERNO DESC) RN FROM {{source('papakura','CONSUMER')}})
,CORRENTE AS (SELECT * FROM CORRENTE_INTERM WHERE RN =1)

,loc as (select *  from {{ref('tab_localizacao')}} where IS_QUADRA = 1)


,nr_loc2 as (select *, 
cast(case
    when cast(RSD$KEYNUM as varchar)  is null then CASE WHEN RSD$READSEQ = 'HOLD' THEN '9696' ELSE concat('0',SUBSTRING(cast(RSD$READSEQ as varchar),1,3)) END
    when cast(replace(replace(cast(RSD$KEYNUM as varchar),'o','0'),'O','0') as integer) = 0 then '0001'
    when cast(replace(replace(cast(RSD$KEYNUM as varchar),'o','0'),'O','0') as integer) >= 50000 then concat('99',substring(cast(replace(replace(cast(RSD$KEYNUM as varchar),'o','0'),'O','0') as varchar),4,5))
    else substring(cast(replace(replace(cast(RSD$KEYNUM as varchar),'o','0'),'O','0') as varchar),2,5)
end as varchar) as keynum_adj


 from {{source('papakura','GBREADSEQ')}} 
) 

,nr_loc as (select nr_loc2.*, concat(LOCALIZACAO.NU_LOCALIZACAO_COMPLETA,'.',RIGHT(keynum_adj,4),'.',
    cast(REPLICATE('0',4-LEN(RTRIM(row_number() over(partition by concat(LOCALIZACAO.NU_LOCALIZACAO_COMPLETA,'.',cast(keynum_adj as varchar)) order by RSD$INSTALL )))) + RTRIM(row_number() over(partition by concat(LOCALIZACAO.NU_LOCALIZACAO_COMPLETA,'.',cast(keynum_adj as varchar)) order by RSD$INSTALL ))as varchar) ) as NR_LOCALIZACAO_UNIDADE
, LOCALIZACAO.ID_LOCALIZACAO
from nr_loc2 
 left join loc LOCALIZACAO on cast(LOCALIZACAO.seqno as varchar) = cast(nr_loc2.RSD$READSEQ as varchar)
)
,CONSUMER_INTERM AS(SELECT *,ROW_NUMBER() OVER(PARTITION BY CINSTALL ORDER BY CONSUMERNO DESC) RN FROM {{source('papakura','CONSUMER')}} )

,CONSUMER_FINAL AS (SELECT * FROM CONSUMER_INTERM WHERE RN = 1)

,CCUC AS (SELECT * FROM {{ref('cad_cliente_unidade_comercial')}} where CH_ATIVO = 1 AND  CH_TIPO_CLIENTE =1   )

,final2 as (

SELECT
INSTALL.INSTALL as CH_MATRICULA_UNIDADE,
coalesce(dbo.Modulo11(INSTALL.INSTALL), 'default') as DIGITO_MATRICULA_UNIDADE,
null as FL_FILTRO_NUMERO,
null as QT_AREA,
null as QT_AREA_TERRENO,
null as NU_INSCRICAO_MOBILIARIA,
nr_loc.NR_LOCALIZACAO_UNIDADE as NR_LOCALIZACAO_UNIDADE,
1 as NU_TOMADAS,
'2022-01-01' as DT_MESANOREF_PRIMEIRO_FATURAMENTO_AGUA,
null as FL_FATURAR_ESGOTO,
cast(nr_loc.keynum_adj as integer) as NU_LOTE,
cast(right(NR_LOCALIZACAO_UNIDADE,4) as integer) as NU_UNIDADE,
null as FL_ESTORNO_ESGOTO,
coalesce(null,0) as DIA_VENCIMENTO_ALTERNATIVO,
cast(0.51 as decimal (16,2)) as QT_CONSUMO_MEDIO_UNIDADE,
'2022-01-01' as DT_MESANOREF_PRIMEIRO_FATURAMENTO_ESGOTO,
null as NU_MORADORES,
'N' as FL_COBRAR_SERVICO_ENTREGA_FATURA,
null as FL_POSSUI_CAIXA_AGUA,
null as FL_POSSUI_CISTERNA,
'S' as FL_GERA_COMUNICADO_DEBITO,
null as FL_GERA_OS_CORTE,
'N' as FL_POSSUI_FONTE_PROPRIA,
'2022-01-01' as DT_INATIVACAO,
null as CD_REGRA_VENCIMENTO_FATURA,
null as FL_PROCESSO_JUDICIAL,
null as CD_BLOCO,
null as CD_APARTAMENTO,
coalesce('2022-01-01', '2022-01-01') as DT_CADASTRO_UNIDADE,
null as NU_INSCRICAO_IMOBILIARIA_LIVRE,
null as FL_AREA_PRESERVACAO,
null as FL_POSSUI_CAIXA_CORREIO,
null as FL_POSSUI_PISCINA,
null as VL_VOLUME_CAIXA_AGUA,
null as VL_VOLUME_PISCINA,
null as VL_VOLUME_CISTERNA,
null as FL_UNIDADE_VIP,
null as FL_TARIFA_LIXO_PARCELA_UNICA,
'2022-01-01' as DT_REF_INICIO_COBRANCA_LIXO,
'2022-01-01' as DT_GERA_CORTE_COMUNICADO,
null as QT_CONSUMO_MINIMO,
null as ID_BLOCO_CONDOMINIO,
1 as CH_SITUACAO_PAVIMENTO_PASSEIO,
1 as CH_TIPO_SITUACAO_EDIFICACAO,
case when INSTALL.INSTALL in 
(select c.CINSTALL  from {{source('papakura','LEDGERPAY')}} l 
inner join {{source('papakura','CONSUMER')}} c on c.CACCT = l.LP$LEDGER ) then 1 else 2 end as CH_TIPO_COBRANCA,
CUOC.ID_ORGAO_CENTRALIZADOR as ID_ORGAO_CENTRALIZADOR,
1 as CH_ATIVO,
coalesce(gpfat.id_grupo_faturamento,99) as ID_GRUPO_FATURAMENTO,
1 as CH_TIPO_PAVIMENTO_LOGRADOURO,
nr_loc.ID_LOCALIZACAO as ID_LOCALIZACAO,
1 as CH_TIPO_PAVIMENTO_PASSEIO,
TCTT.CH_CATEGORIA_TARIFA as CH_CATEGORIA_TARIFA,
CASE WHEN INSTALL.ICHGCLASS = '100' THEN 1
ELSE 2 END as CH_TIPO_CATEGORIA_TARIFA,
1 as CH_CLASSE_CONSUMIDOR,
1 as CH_TIPO_DOMICILIO,
1 as CH_TIPO_UNIDADE,
null as ID_PADRAO_IMOVEL,
null as ID_ESTRUTURA_INSCRICAO_IMOBILIARIA,
null as CH_POSICAO_IMOVEL,
MRLAS.ID_ROTA_LEITURA_AGUA_SEQUENCIA as ID_ROTA_LEITURA_AGUA_UNIDADE_ATIVA,
null as CH_TIPO_PAVIMENTO_CALCADA_INTERNA,
null as CH_TIPO_MURO,
20900003 as CH_TIPO_ENTREGA_FATURA,
null as CH_REGRA_FATURAMENTO_ALTERNATIVA,
null as CH_ORIENTACAO_IMOVEL,
null as NR_LATITUDE,
null as NR_LONGITUDE,
null as VL_GEOMETRIA,
cast(0 as bit) as FL_CENTRALIZADO,
null as NR_LATITUDE_MEIO_RUA,
null as NR_LONGITUDE_MEIO_RUA,
null as FL_POSSUI_DECLARACAO_LIXO,
null as NR_REGISTRO_CARTORIO,
null as QT_AREA_JARDIM,
null as QT_LOTES,
null as CH_TIPO_EDIFICACAO,
null as ID_TIPO_FOSSA,
null as FL_PERMITE_INCLUSAO_SPC,
null as CH_TIPO_AREA,

null as CH_TIPO_CLIENTE_IMPRESSAO_DOCUMENTO,
null as QT_TESTADA_IMOVEL,
null as NR_QUADRA_IMOVEL,
null as NR_LOTE_IMOVEL,
CORRENTE.CACCT AS ID_CONTA_CORRENTE

from {{source('papakura','INSTALL')}} INSTALL
left JOIN {{ref('cad_endereco')}} ENDERECO on INSTALL.INSTALL = ENDERECO.ACTID
left join gpfat on cast(gpfat.INSTALL as varchar) = cast(INSTALL.INSTALL as varchar)
left join nr_loc on cast(nr_loc.RSD$INSTALL as varchar) =  cast(INSTALL.INSTALL as varchar)
LEFT JOIN CORRENTE ON INSTALL.INSTALL = CORRENTE.CINSTALL
LEFT JOIN CCUC CONS ON CONS.CH_MATRICULA_UNIDADE = INSTALL.INSTALL
LEFT JOIN {{ref('stage_contrato')}} AS SC ON CAST(SC.CCON_CONSUMER AS VARCHAR)= CAST(CONS.MIG_PK_TEMP AS VARCHAR)
LEFT JOIN {{ref('tab_categoria_tipo_tarifa')}} TCTT ON TCTT.PLAN_CODE = SC.CCON_PLANID1
left join {{ref('med_rota_leitura_agua_sequencia')}} MRLAS ON MRLAS.CH_MATRICULA_UNIDADE = INSTALL.INSTALL
left join {{ref('cad_unidade_orgao_centralizador')}} CUOC ON CUOC.CH_MATRICULA_UNIDADE = INSTALL.INSTALL
WHERE INSTALL.INSTALL NOT IN  (11015932,11015928,11015929,11015933,11015931,11015930)

)

,final as (
select final2.*, row_number() over(partition by CH_MATRICULA_UNIDADE order by CH_MATRICULA_UNIDADE asc) as rn from final2 where NR_LOCALIZACAO_UNIDADE is not null
)

select * from final2 --where rn = 1