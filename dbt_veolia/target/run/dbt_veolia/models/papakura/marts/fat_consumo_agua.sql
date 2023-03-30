
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."fat_consumo_agua__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."fat_consumo_agua__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."fat_consumo_agua__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."fat_consumo_agua__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."fat_consumo_agua__dbt_tmp_temp_view" as
    


WITH relation as (select distinct GBE$INSTALL, GBE$REGISTER from "papakura_20221223"."dbo"."GBECONSUMP" cons

)
,base as(select GBIINVOICE as INVOICE from GBINVOICE#REGISTERS gr 
group by GBIINVOICE
having count(GBIINVOICE) > 1

UNION  

SELECT GBIINVOICE FROM  GBINVOICE#REGISTERS
WHERE GBIMCURR_TYPE =''IM'' or (GBIMPREV_TYPE =''RM'' AND GBIMCURR_TYPE =''RM'') OR GBIMCURR_TYPE =''RM'' OR ( GBIMPREV_TYPE =''IM'' AND VMC >1)
OR GBIMMETERNOCHANGE = ''RMV'')



,reg2 as( select temp.*, CASE WHEN temp.GBIMCURR_TYPE IS NULL THEN ''AB'' ELSE temp.GBIMCURR_TYPE END  as GBIMCURR_TYPE_ADJ from "papakura_20221223"."dbo"."GBINVOICE#REGISTERS" temp) 
,leitura as (
    select 
row_number() over(order by reg.GBIINVOICE ) as ID_CONSUMO_AGUA,
cast(reg.GBIMCONSUMP as integer) as QT_VOLUME_FATURADO,
reg.GBIMCONSUMP as QT_VOLUME_AFATURAR,
reg.GBIMCONSUMP as QT_VOLUME_LIDO,

concat(year(reg.GBIMCURR_DATE),''-'',cast(case when month(reg.GBIMCURR_DATE) < 10 then cast(concat(''0'',month(reg.GBIMCURR_DATE)) as varchar) else month(reg.GBIMCURR_DATE) end as varchar) ,''-'',''01'') 
 as DT_MES_REF_CONSUMO,
tipo_leitura.CH_TIPO_LEITURA as CH_TIPO_LEITURA,
cula.ID_UNIDADE_LIGACAO_AGUA as ID_UNIDADE_LIGACAO_AGUA,
hid.ID_HIDROMETRO,
reg.GBIMCONSUMP as QT_VOLUME_REAL,
reg.GBIMCURR_DATE as DT_LEITURA_UNIDADE,
FAT.GBICUR_NO_DAYS as QT_DIAS_CONSUMO,
cula.CH_MATRICULA_UNIDADE as CH_MATRICULA_UNIDADE,
reg.GBIINVOICE as idseq,
reg.GBIMPREV_DATE as DATA_ANTERIOR,
reg.GBIMCURR_DATE AS DATA_ATUAL,
CASE
WHEN reg.GBIMCURR_TYPE_ADJ = ''AB'' then 8
WHEN reg.GBIMCURR_TYPE_ADJ = ''AE'' then 1
WHEN reg.GBIMCURR_TYPE_ADJ = ''BR'' then 7
WHEN reg.GBIMCURR_TYPE_ADJ = ''CR'' then 2
WHEN reg.GBIMCURR_TYPE_ADJ = ''E1'' then 1
WHEN reg.GBIMCURR_TYPE_ADJ = ''E2'' then 1
WHEN reg.GBIMCURR_TYPE_ADJ = ''E3'' then 1
WHEN reg.GBIMCURR_TYPE_ADJ = ''EM'' then 1
WHEN reg.GBIMCURR_TYPE_ADJ = ''GE'' then 1
WHEN reg.GBIMCURR_TYPE_ADJ = ''GR'' then 2
WHEN reg.GBIMCURR_TYPE_ADJ = ''IM'' then 2
WHEN reg.GBIMCURR_TYPE_ADJ = ''ME'' then 1
WHEN reg.GBIMCURR_TYPE_ADJ = ''MR'' then 4
WHEN reg.GBIMCURR_TYPE_ADJ = ''NM'' then 8
WHEN reg.GBIMCURR_TYPE_ADJ = ''OR'' then 2
WHEN reg.GBIMCURR_TYPE_ADJ = ''RD'' then 1
WHEN reg.GBIMCURR_TYPE_ADJ = ''RM'' then 2
ELSE 8

END as CH_TIPO_CONSUMO_FATURADO

from reg2 reg
inner join "papakura_20221223"."dbo_mig"."tab_tipo_leitura" tipo_leitura on cast(tipo_leitura.CD_TIPO_LEITURA as varchar) = cast(reg.GBIMCURR_TYPE_ADJ as varchar)
inner join "papakura_20221223"."dbo"."GBINVOICE" FAT ON cast(FAT.GBIINVOICE as varchar) = cast(reg.GBIINVOICE as varchar)

inner JOIN "papakura_20221223"."dbo_mig"."cad_unidade_ligacao_agua" cula on cast(cula.CH_MATRICULA_UNIDADE as varchar) = cast(reg.GBIMINSTALL as varchar)
left join "papakura_20221223"."dbo_mig"."cad_hidrometro" hid on hid.NU_HIDROMETRO = reg.GBIMSERIAL
where cula.ID_UNIDADE_LIGACAO_AGUA is not null and reg.GBIINVOICE NOT IN (SELECT INVOICE FROM base)
)



,final2 as(
SELECT
-- ID_CONSUMO_AGUA as ID_CONSUMO_AGUA,
cast(QT_VOLUME_FATURADO as integer) as QT_VOLUME_FATURADO,
cast(QT_VOLUME_AFATURAR  as integer) as QT_VOLUME_AFATURAR,
cast(QT_VOLUME_LIDO as float) as QT_VOLUME_LIDO,
-- cast(DT_MES_REF_CONSUMO as date)  as DT_MES_REF_CONSUMO,
-- coalesce(
    cast(ff.DT_MESANO_REF as date)
    -- ,cast(DT_MES_REF_CONSUMO as date))  
    as DT_MES_REF_CONSUMO,
0 as QT_SALDO_CONSUMO,
''S'' as FL_CONSIDERA_CONSUMO_MEDIA,
null as QT_VOLUME_MEDIO,
null as FL_VERIFICACAO_LEITURA,
''S'' as FL_COMUNICADO,
cast(QT_VOLUME_REAL as integer) as QT_VOLUME_REAL,
''N'' as FL_LIGACAO_CORTADA,
null as QT_VOLUME_ESGOTO_FATURADO,
null as QT_VOLUME_DEVOLVIDO,
cast(cast(DT_LEITURA_UNIDADE as date) as varchar) as DT_LEITURA_UNIDADE,
case when QT_DIAS_CONSUMO = 0
THEN
CASE WHEN DATEDIFF(MONTH,leitura.DATA_ANTERIOR,leitura.DATA_ATUAL) <0 THEN DATEDIFF(MONTH,leitura.DATA_ANTERIOR,leitura.DATA_ATUAL) * -1 ELSE DATEDIFF(MONTH,leitura.DATA_ANTERIOR,leitura.DATA_ATUAL) END
else QT_DIAS_CONSUMO end  as QT_DIAS_CONSUMO,
leitura.CH_TIPO_CONSUMO_FATURADO as CH_TIPO_CONSUMO_FATURADO,
null as CH_TIPO_MEDIA,
ID_UNIDADE_LIGACAO_AGUA as ID_UNIDADE_LIGACAO_AGUA,
leitura.CH_MATRICULA_UNIDADE as CH_MATRICULA_UNIDADE,
ID_UNIDADE_LIGACAO_ESGOTO as ID_UNIDADE_LIGACAO_ESGOTO,
1 as CH_TIPO_FATURAMENTO_ESGOTO,
1 as ID_LEITURISTA,
idseq as idseq,
idseq as MIG_PK_TEMP,
DATA_ANTERIOR as MIG_DATA_ANTERIOR_TEMP,
DATA_ATUAL AS MIG_DATA_ATUAL_TEMP,
coalesce(case 
    when CASE WHEN DATEDIFF(MONTH,leitura.DATA_ANTERIOR,leitura.DATA_ATUAL) <0 THEN DATEDIFF(MONTH,leitura.DATA_ANTERIOR,leitura.DATA_ATUAL) * -1 ELSE DATEDIFF(MONTH,leitura.DATA_ANTERIOR,leitura.DATA_ATUAL) END = 0 then 1 
    else CASE WHEN DATEDIFF(MONTH,leitura.DATA_ANTERIOR,leitura.DATA_ATUAL) <0 THEN DATEDIFF(MONTH,leitura.DATA_ANTERIOR,leitura.DATA_ATUAL) * -1 ELSE DATEDIFF(MONTH,leitura.DATA_ANTERIOR,leitura.DATA_ATUAL) END end,1) AS QT_MESES_CONSUMO

FROM leitura
LEFT JOIN "papakura_20221223"."dbo_mig"."cad_unidade_ligacao_esgoto" cule on cule.CH_MATRICULA_UNIDADE = leitura.CH_MATRICULA_UNIDADE
left join "papakura_20221223"."dbo_mig"."fat_fatura" ff on ff.NR_FATURA = leitura.idseq

union 

select * from "papakura_20221223"."dbo_mig"."stage_fat_consumo_agua2"

)

,final as (
select row_number() over(order by idseq ) ID_CONSUMO_AGUA ,final2.*, 
row_number() over(partition by concat(cast(DT_MES_REF_CONSUMO as varchar), cast(CH_MATRICULA_UNIDADE as varchar)) order by  DT_LEITURA_UNIDADE desc, idseq desc)  as rn


from final2 
)


select  * from final where rn = 1
-- and dt_mes_ref_consumo is not null
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."fat_consumo_agua__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."fat_consumo_agua__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."fat_consumo_agua__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."fat_consumo_agua__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_fat_consumo_agua__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_fat_consumo_agua__dbt_tmp')
    )
  DROP index "dbo_mig"."fat_consumo_agua__dbt_tmp".dbo_mig_fat_consumo_agua__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_fat_consumo_agua__dbt_tmp_cci
    ON "dbo_mig"."fat_consumo_agua__dbt_tmp"

   

