
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."fat_grupo_faturamento__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."fat_grupo_faturamento__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."fat_grupo_faturamento__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."fat_grupo_faturamento__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."fat_grupo_faturamento__dbt_tmp_temp_view" as
    with gpfat as (
    select distinct 
cast(case 
	when cast(substring(i.RSD$READSEQ, 1,3) as varchar) = ''000'' then ''001'' 
	when cast(substring(i.RSD$READSEQ, 1,3) as varchar) = ''HOL'' then ''099''
	else cast(substring(i.RSD$READSEQ, 1,3) as varchar)
end as integer) as id_grupo_faturamento,  
cast(case 
	when cast(substring(i.RSD$READSEQ, 1,3) as varchar) = ''000'' then ''001'' 
	when cast(substring(i.RSD$READSEQ, 1,3) as varchar) = ''HOL'' then ''099''
	else cast(substring(i.RSD$READSEQ, 1,3) as varchar)
end as integer) as dia_ronda,
substring(i.RSD$READSEQ,1,3) AS READSEQ
from "papakura_20221223"."dbo"."GBREADSEQ" i 
)



SELECT
id_grupo_faturamento as ID_GRUPO_FATURAMENTO,
coalesce(id_grupo_faturamento, 001) as NU_GRUPO_FATURAMENTO,
coalesce(1, 0) as DT_DIA_VECTO,
01 as DT_DIA_PREVISAO_MASSA_LEITURA,
02 as DT_DIA_PREVISAO_INICIO_LEITURA,
02 as DT_DIA_PREVISAO_FIM_LEITURA,
03 as DT_DIA_PREVISAO_PROCESSO_FATURAMENTO,
0 as QT_MESES_ATRASO,
dateadd( month,1,cast(concat(year(getdate()),concat(''-'',concat(month(getdate()),concat(''-'',01)))) as date)) as DT_REF_VIGENTE,
''S'' as FL_GERAR_COMUNICADO_DEBITO,
'''' as FL_GERAR_SEGUNDA_VIA_COLETOR,
''S'' as FL_COBRAR_AGUA,
''S'' as FL_COBRAR_ESGOTO,
''S'' as FL_PERMITE_GERAR_OS_MANUAL,
1 as CH_TIPO_GRUPO_FATURAMENTO,
1 as CH_ATIVO,
null as CH_TIPO_GRUPO_ESPECIAL,
2 as CH_PROCESSO,
21380001 as CH_PERIODICIDADE_FATURAMENTO,
gpfat.READSEQ,
gpfat.READSEQ as MIG_PK_TEMP
FROM gpfat
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."fat_grupo_faturamento__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."fat_grupo_faturamento__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."fat_grupo_faturamento__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."fat_grupo_faturamento__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_fat_grupo_faturamento__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_fat_grupo_faturamento__dbt_tmp')
    )
  DROP index "dbo_mig"."fat_grupo_faturamento__dbt_tmp".dbo_mig_fat_grupo_faturamento__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_fat_grupo_faturamento__dbt_tmp_cci
    ON "dbo_mig"."fat_grupo_faturamento__dbt_tmp"

   

