

WITH reg2 as(select temp.*, CASE WHEN temp.GBIMCURR_TYPE IS NULL THEN 'AB' ELSE temp.GBIMCURR_TYPE END  as GBIMCURR_TYPE_ADJ from "papakura_20221223"."dbo"."GBINVOICE#REGISTERS" temp) 


,base as(select GBIINVOICE as INVOICE from GBINVOICE#REGISTERS gr 
group by GBIINVOICE
having count(GBIINVOICE) > 1

UNION  

SELECT GBIINVOICE FROM  GBINVOICE#REGISTERS
WHERE GBIMCURR_TYPE ='IM' or (GBIMPREV_TYPE ='RM' AND GBIMCURR_TYPE ='RM') OR GBIMCURR_TYPE ='RM' OR ( GBIMPREV_TYPE ='IM' AND VMC >1)
OR GBIMMETERNOCHANGE = 'RMV')

,leitura as (select 
row_number() over(partition by reg2.GBIBREGKEY order by reg2.GBIMCURR_DATE asc ) as NR_SEQUENCIAL,
reg2.GBIMCURR_READ as NR_LEITURA_REAL,
reg2.GBIMCURR_READ as NR_LIDO,
cast(CASE WHEN DATEPART(HOUR,reg2.GBIMCURR_DATE) = 23 THEN  DATEADD(HOUR,1,reg2.GBIMCURR_DATE) 
     WHEN DATEPART(HOUR,reg2.GBIMCURR_DATE) = 13 THEN  DATEADD(HOUR,11,reg2.GBIMCURR_DATE)

     WHEN DATEPART(HOUR,reg2.GBIMCURR_DATE) = 12 THEN  DATEADD(HOUR,12,reg2.GBIMCURR_DATE)
     WHEN DATEPART(HOUR,reg2.GBIMCURR_DATE) = 11 THEN  DATEADD(HOUR,13,reg2.GBIMCURR_DATE)
ELSE reg2.GBIMCURR_DATE END as date) as DT_LEITURA_UNIDADE,
-- cast(concat(year(CASE WHEN DATEPART(HOUR,reg2.GBIMCURR_DATE) = 23 THEN  DATEADD(HOUR,1,reg2.GBIMCURR_DATE) ELSE reg2.GBIMCURR_DATE END),concat('-',concat(month(CASE WHEN DATEPART(HOUR,reg2.GBIMCURR_DATE) = 23 THEN  DATEADD(HOUR,1,reg2.GBIMCURR_DATE) ELSE reg2.GBIMCURR_DATE END),concat('-',01)))) as date) 
ff.DT_MESANO_REF as DT_MES_REF_LEITURA,
CASE 
when reg2.GBIMCURR_TYPE_ADJ = 'AB' then 6
when reg2.GBIMCURR_TYPE_ADJ = 'AE' then 6
when reg2.GBIMCURR_TYPE_ADJ = 'BR' then 6
when reg2.GBIMCURR_TYPE_ADJ = 'CR' then 3
when reg2.GBIMCURR_TYPE_ADJ = 'E1' then 6
when reg2.GBIMCURR_TYPE_ADJ = 'E2' then 6
when reg2.GBIMCURR_TYPE_ADJ = 'E3' then 6
when reg2.GBIMCURR_TYPE_ADJ = 'EM' then 6
when reg2.GBIMCURR_TYPE_ADJ = 'GE' then 6
when reg2.GBIMCURR_TYPE_ADJ = 'GR' then 3
when reg2.GBIMCURR_TYPE_ADJ = 'IM' then 3
when reg2.GBIMCURR_TYPE_ADJ = 'ME' then 6
when reg2.GBIMCURR_TYPE_ADJ = 'MR' then 3
when reg2.GBIMCURR_TYPE_ADJ = 'NM' then 6
when reg2.GBIMCURR_TYPE_ADJ = 'OR' then 3
when reg2.GBIMCURR_TYPE_ADJ = 'RD' then 3
when reg2.GBIMCURR_TYPE_ADJ = 'RM' then 3
ELSE 6
END as CH_TIPO_LEITURA,
cula.ID_UNIDADE_LIGACAO_AGUA,
hid.ID_HIDROMETRO,
reg2.GBIINVOICE as idseq,
reg2.GBIMCURR_TYPE_ADJ AS cod

from reg2
INNER JOIN "papakura_20221223"."dbo_mig"."cad_unidade_ligacao_agua" cula on cula.CH_MATRICULA_UNIDADE  = reg2.GBIMINSTALL
inner join "papakura_20221223"."dbo_mig"."tab_tipo_leitura" tipo_leitura on tipo_leitura.CD_TIPO_LEITURA = reg2.GBIMCURR_TYPE_ADJ
left join "papakura_20221223"."dbo_mig"."fat_fatura" ff on ff.NR_FATURA = reg2.GBIINVOICE
left join "papakura_20221223"."dbo_mig"."cad_hidrometro" hid on hid.NU_HIDROMETRO = reg2.GBIMSERIAL

where cula.ID_UNIDADE_LIGACAO_AGUA is not null and reg2.GBIINVOICE NOT IN (SELECT INVOICE FROM base))

,final2 as(
SELECT
-- row_number() over(order by l.DT_LEITURA_UNIDADE) as ID_LEITURA_UNIDADE_LIGACAO_AGUA,
l.NR_LEITURA_REAL as NR_LEITURA_REAL,
l.NR_LIDO as NR_LIDO,
cast(l.DT_LEITURA_UNIDADE as date) as DT_LEITURA_UNIDADE,
cast(coalesce(l.DT_MES_REF_LEITURA, '2022-06-01') as date) as DT_MES_REF_LEITURA,
'N' as FL_CONSUMO_PREVIO,
0 as CD_OCORRENCIA_LIDA,
'N' as FL_FORA_DE_FAIXA,
0 as NR_OCORRENCIA_CONSECUTIVA,
null as DT_LEITURA_ATRASADA,
null as NR_LEITURA_ATRASADA,
coalesce(l.CH_TIPO_LEITURA, 1) as CH_TIPO_LEITURA,
1 as ID_USUARIO,
CASE
when l.cod = 'AB' then 3
when l.cod = 'AE' then 3
when l.cod = 'BR' then 13
when l.cod = 'CR' then 8
when l.cod = 'E1' then 3
when l.cod = 'E2' then 3
when l.cod = 'E3' then 3
when l.cod = 'EM' then 3
when l.cod = 'GE' then 3
when l.cod = 'GR' then 3
when l.cod = 'IM' then 1
when l.cod = 'ME' then 8
when l.cod = 'MR' then 8
when l.cod = 'NM' then 3
when l.cod = 'OR' then 8
when l.cod = 'RD' then 3
when l.cod = 'RM' then 2
END as CH_ORIGEM_LEITURA,
l.ID_UNIDADE_LIGACAO_AGUA as ID_UNIDADE_LIGACAO_AGUA,
null as ID_OCORRENCIA_LEITURA,
1 as ID_LEITURISTA,
CASE
when l.cod = 'AB' then null
when l.cod = 'AE' then null
when l.cod = 'BR' then null
when l.cod = 'CR' then null
when l.cod = 'E1' then 20870001
when l.cod = 'E2' then 20870001
when l.cod = 'E3' then 20870001
when l.cod = 'EM' then 20870001
when l.cod = 'GE' then 20870001
when l.cod = 'GR' then null
when l.cod = 'IM' then null
when l.cod = 'ME' then 20870001
when l.cod = 'MR' then null
when l.cod = 'NM' then null
when l.cod = 'OR' then null
when l.cod = 'RD' then null
when l.cod = 'RM' then null
END as CH_TIPO_MEDIA,
l.ID_HIDROMETRO as ID_HIDROMETRO,
idseq as idseq,
idseq as MIG_PK_TEMP,
'N' MIG_ADJ_MODELO_TEMP

FROM leitura l

union


SELECT
-- row_number() over(order by l.DT_LEITURA_UNIDADE) as ID_LEITURA_UNIDADE_LIGACAO_AGUA,
cast(GBB$INSTALLREAD as integer)  as NR_LEITURA_REAL,
cast(GBB$INSTALLREAD as integer) as NR_LIDO,

cast(CASE WHEN DATEPART(HOUR,GBB$INSTALLDATE) = 23 THEN  DATEADD(HOUR,1,GBB$INSTALLDATE) 
     WHEN DATEPART(HOUR,GBB$INSTALLDATE) = 13 THEN  DATEADD(HOUR,11,GBB$INSTALLDATE)

     WHEN DATEPART(HOUR,GBB$INSTALLDATE) = 12 THEN  DATEADD(HOUR,12,GBB$INSTALLDATE)
     WHEN DATEPART(HOUR,GBB$INSTALLDATE) = 11 THEN  DATEADD(HOUR,13,GBB$INSTALLDATE)
ELSE GBB$INSTALLDATE END as date) as DT_LEITURA_UNIDADE,
cast(concat(year(CASE WHEN DATEPART(HOUR,GBB$INSTALLDATE) = 23 THEN  DATEADD(HOUR,1,GBB$INSTALLDATE) 
	WHEN DATEPART(HOUR,GBB$INSTALLDATE) = 12 THEN  DATEADD(HOUR,12,GBB$INSTALLDATE)
	WHEN DATEPART(HOUR,GBB$INSTALLDATE) = 13 THEN  DATEADD(HOUR,11,GBB$INSTALLDATE)

	 WHEN DATEPART(HOUR,GBB$INSTALLDATE) = 11 THEN  DATEADD(HOUR,13,GBB$INSTALLDATE)
	 ELSE GBB$INSTALLDATE END),concat('-',concat(month(CASE WHEN DATEPART(HOUR,GBB$INSTALLDATE) = 23 THEN  DATEADD(HOUR,1,GBB$INSTALLDATE) 
WHEN DATEPART(HOUR,GBB$INSTALLDATE) = 12 THEN  DATEADD(HOUR,12,GBB$INSTALLDATE)
WHEN DATEPART(HOUR,GBB$INSTALLDATE) = 13 THEN  DATEADD(HOUR,11,GBB$INSTALLDATE)

	 WHEN DATEPART(HOUR,GBB$INSTALLDATE) = 11 THEN  DATEADD(HOUR,13,GBB$INSTALLDATE)
	 ELSE GBB$INSTALLDATE END),concat('-',01)))) as date) as DT_MES_REF_LEITURA,
'N' as FL_CONSUMO_PREVIO,
0 as CD_OCORRENCIA_LIDA,
'N' as FL_FORA_DE_FAIXA,
0 as NR_OCORRENCIA_CONSECUTIVA,
null as DT_LEITURA_ATRASADA,
null as NR_LEITURA_ATRASADA,
3 as CH_TIPO_LEITURA,
1 as ID_USUARIO,
1 as CH_ORIGEM_LEITURA,
cula.ID_UNIDADE_LIGACAO_AGUA as ID_UNIDADE_LIGACAO_AGUA,
null as ID_OCORRENCIA_LEITURA,
1 as ID_LEITURISTA,
null as CH_TIPO_MEDIA,
hid.ID_HIDROMETRO as ID_HIDROMETRO,
ROW_NUMBER() OVER(ORDER BY GR.GBB$INSTALL) as idseq,
ROW_NUMBER() OVER(ORDER BY GR.GBB$INSTALL) as MIG_PK_TEMP,
'S' MIG_ADJ_MODELO_TEMP


from "papakura_20221223"."dbo"."GBBILLREG" GR 
INNER JOIN "papakura_20221223"."dbo_mig"."cad_unidade_ligacao_agua" cula on cula.CH_MATRICULA_UNIDADE  = GR.GBB$INSTALL
left join "papakura_20221223"."dbo_mig"."cad_hidrometro" hid on hid.NU_HIDROMETRO = GR.GBB$METERSERIAL
where GBB$INSTALL NOT in(SELECT GBIINSTALL FROM GBINVOICE) AND GBB$ADJUSTTYPE IS NULL

)

,final as (select final2.*,  
row_number() over(partition by concat(cast(DT_MES_REF_LEITURA as varchar), cast(ID_UNIDADE_LIGACAO_AGUA as varchar)) order by  DT_LEITURA_UNIDADE desc, idseq desc)  as rn
from final2)

,flula as(select row_number() over(order by DT_LEITURA_UNIDADE) as ID_LEITURA_UNIDADE_LIGACAO_AGUA, final.* from final where rn = 1)

select *,row_number() over(partition by ID_UNIDADE_LIGACAO_AGUA order by flula.DT_MES_REF_LEITURA asc) as NR_SEQUENCIAL  from flula