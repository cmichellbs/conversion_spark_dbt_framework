
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."stage_fat_consumo_agua2__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."stage_fat_consumo_agua2__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."stage_fat_consumo_agua2__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."stage_fat_consumo_agua2__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."stage_fat_consumo_agua2__dbt_tmp_temp_view" as
    SELECT
-- ID_CONSUMO_AGUA as ID_CONSUMO_AGUA,
0 as QT_VOLUME_FATURADO,
0 as QT_VOLUME_AFATURAR,
0 as QT_VOLUME_LIDO,
concat(year(GR.GBB$INSTALLDATE),''-'',cast(case when month(GR.GBB$INSTALLDATE) < 10 then cast(concat(''0'',month(GR.GBB$INSTALLDATE)) as varchar) else month(GR.GBB$INSTALLDATE) end as varchar) ,''-'',''01'') DT_MES_REF_CONSUMO,
0 as QT_SALDO_CONSUMO,
''S'' as FL_CONSIDERA_CONSUMO_MEDIA,
null as QT_VOLUME_MEDIO,
null as FL_VERIFICACAO_LEITURA,
''S'' as FL_COMUNICADO,
0 as QT_VOLUME_REAL,
''N'' as FL_LIGACAO_CORTADA,
null as QT_VOLUME_ESGOTO_FATURADO,
null as QT_VOLUME_DEVOLVIDO,
cast(cast(GR.GBB$INSTALLDATE as date) as varchar) as DT_LEITURA_UNIDADE,
1 as QT_DIAS_CONSUMO,
2 as CH_TIPO_CONSUMO_FATURADO,
null as CH_TIPO_MEDIA,
cula.ID_UNIDADE_LIGACAO_AGUA as ID_UNIDADE_LIGACAO_AGUA,
GR.GBB$INSTALL as CH_MATRICULA_UNIDADE,
cule.ID_UNIDADE_LIGACAO_ESGOTO as ID_UNIDADE_LIGACAO_ESGOTO,
1 as CH_TIPO_FATURAMENTO_ESGOTO,
1 as ID_LEITURISTA,
row_number() over(order by GR.GBB$INSTALL) as idseq,
row_number() over(order by GR.GBB$INSTALL) as MIG_PK_TEMP,
null as MIG_DATA_ANTERIOR_TEMP,
GR.GBB$INSTALLDATE AS MIG_DATA_ATUAL_TEMP,
1 AS QT_MESES_CONSUMO


from "papakura_20221223"."dbo"."GBBILLREG" GR 
INNER JOIN "papakura_20221223"."dbo_mig"."cad_unidade_ligacao_agua" cula on cula.CH_MATRICULA_UNIDADE  = GR.GBB$INSTALL
LEFT JOIN "papakura_20221223"."dbo_mig"."cad_unidade_ligacao_esgoto" cule on cule.CH_MATRICULA_UNIDADE = GR.GBB$INSTALL
where GBB$INSTALL NOT in(SELECT GBIINSTALL FROM GBINVOICE) AND GBB$ADJUSTTYPE IS NULL
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."stage_fat_consumo_agua2__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."stage_fat_consumo_agua2__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."stage_fat_consumo_agua2__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."stage_fat_consumo_agua2__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_stage_fat_consumo_agua2__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_stage_fat_consumo_agua2__dbt_tmp')
    )
  DROP index "dbo_mig"."stage_fat_consumo_agua2__dbt_tmp".dbo_mig_stage_fat_consumo_agua2__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_stage_fat_consumo_agua2__dbt_tmp_cci
    ON "dbo_mig"."stage_fat_consumo_agua2__dbt_tmp"

   

