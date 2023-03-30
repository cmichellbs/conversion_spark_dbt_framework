with setor as (select distinct concat('01.01.0', CASE 
	when cast(substring(i.RSD$READSEQ, 1,3) as varchar) = '000' then '001' 
	when cast(substring(i.RSD$READSEQ, 1,3) as varchar) = 'HOL' then '099'
	else cast(substring(i.RSD$READSEQ, 1,3) as varchar)
END) as setor_completo,

CAST(case 
	when cast(substring(i.RSD$READSEQ, 1,3) as varchar) = '000' then '001' 
	when cast(substring(i.RSD$READSEQ, 1,3) as varchar) = 'HOL' then '099' 
	else cast(substring(i.RSD$READSEQ, 1,3) as varchar) end AS INTEGER) as setor,
cast(i.RSD$READSEQ as varchar) as seqno
from {{source('papakura','GBREADSEQ')}} i 
)

,quadra as(select distinct concat(setor.setor_completo,

concat('.',CASE WHEN i.RSD$READSEQ = 'HOLD' THEN '0099'ELSE case 
	when cast(substring(i.RSD$READSEQ, 4,6) as varchar) = '000' then '0001' else concat('0',cast(substring(i.RSD$READSEQ, 4,6) as varchar))
end END)) as quadra_completo,
CASE WHEN i.RSD$READSEQ = 'HOLD' THEN 099 ELSE case when cast(substring(i.RSD$READSEQ, 4,6) as integer) = 0 then 1 else cast(substring(i.RSD$READSEQ, 4,6) as integer) end END as quadra,
cast(i.RSD$READSEQ as varchar) as seqno
from {{source('papakura','GBREADSEQ')}} i
left join setor on setor.seqno = cast(i.RSD$READSEQ as varchar)
)

,setor_quadra as (
select * from setor
union
select * from quadra

)

,setor_quadra_interm as (
select row_number() over(order by setor_completo) as id,
row_number() over(PARTITION by SUBSTRING(setor_completo,1,10) order by setor_completo)as id_temp1, 
row_number() over(PARTITION by setor_completo order by setor_completo ) as id_temp2,
setor_completo as localizacao_completa, 
setor as localizacao, len(setor_completo) as tamanho_string,
CAST(seqno AS VARCHAR) as seqno from setor_quadra
)

, setor_quadra_final as ( select a.id, a.id_temp1,a.id_temp2,a.localizacao_completa,a.localizacao, a.tamanho_string, seqno from setor_quadra_interm a
where a.id_temp2 = 1
)

,fin  as (
select a.id, a.localizacao, a.localizacao_completa,case when a.tamanho_string = 10 then null else b.id  end as loc_sup, a.seqno,
case when a.seqno = 'HOLD' then '026001' ELSE a.seqno

end as seqno_adj

from setor_quadra_final a
left join setor_quadra_final b on substring(a.localizacao_completa,1,10) = b.localizacao_completa
)



SELECT
fin.id AS ID_LOCALIZACAO,
fin.localizacao as NU_LOCALIZACAO,
fin.localizacao_completa as NU_LOCALIZACAO_COMPLETA,
null as NR_ORDEM,
100002 as ID_ESTRUTURA_EMPRESA,
1 as CH_ATIVO,
fin.loc_sup as ID_LOCALIZACAO_SUPERIOR,
NULL as CH_BAIRRO,
CASE
when fin.loc_sup is null then 1
else 2
END as ID_TIPO_LOCALIZACAO,
CASE WHEN LEN(fin.localizacao_completa) = 15 THEN 1 ELSE 0
END AS IS_QUADRA,
seqno as seqno,
seqno as MIG_SEQNO_TEMP

FROM fin
-- left join {{source('papakura','INSTALL')}} INSTALL ON cast(INSTALL.IBILLSEQ as VARCHAR) = cast(fin.seqno as varchar)


