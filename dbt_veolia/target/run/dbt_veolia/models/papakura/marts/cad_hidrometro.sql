
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."cad_hidrometro__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."cad_hidrometro__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."cad_hidrometro__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."cad_hidrometro__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."cad_hidrometro__dbt_tmp_temp_view" as
    


with METERS AS( SELECT *,

 CASE 
    WHEN MSIZE NOT IN (''100MM'',''150MM'',''15MM'',''20MM'',''25MM'',''30MM'',''32MM'',''40MM'',''50MM'',''75MM'',''BULK'',''BYP'',''FIRE'',''GRDN'',''ND'',''RWM'',''WM'') THEN ''WM''
    ELSE MSIZE
 END AS MSIZE2
 
 FROM "papakura_20221223"."dbo"."METERS")
,INTERM AS (SELECT
row_number() over(order by ASSET.ASM$ASSET)  as ID_HIDROMETRO,
ASSET.ASM$DATEMANUF as  DT_ANO_FABRIC,
CAST(asset.ASM$SERIAL AS VARCHAR) as NU_HIDROMETRO,
ASSET.ASM$ASSET as NR_LACRE_HIDROMETRO,
1 as NR_MEDIDOR_RADIO,
null as NR_NOTA_FISCAL,
null as ID_HIDROMETRO_ANTERIOR,
1 as CH_ATIVO,
MODEL.CH_MODELO_HIDROMETRO as CH_MODELO_HIDROMETRO,
coalesce(1, 0) as CH_SITUACAO_HIDROMETRO,
null as ID_MEDIDOR_TELEMETRIA,
ASSET.ASM$LOC$INSTALL AS ID_UNIDADE_INSTALACAO,
ASSET.ASM$SERIAL AS MIG_PK_TEMP
FROM "papakura_20221223"."dbo"."ASSETMASTER" ASSET 
LEFT JOIN METERS ON ASSET.ASM$ASSET = METERS.MMETERNO
LEFT JOIN "papakura_20221223"."dbo_mig"."tab_modelo_hidrometro" MODEL ON MODEL.DIAMETRO = METERS.MSIZE2)
,FINAL AS (SELECT INTERM.*, ROW_NUMBER() OVER(PARTITION BY NU_HIDROMETRO ORDER BY NR_LACRE_HIDROMETRO DESC) RNF FROM INTERM )

SELECT * FROM FINAL WHERE RNF = 1
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."cad_hidrometro__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."cad_hidrometro__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."cad_hidrometro__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."cad_hidrometro__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_cad_hidrometro__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_cad_hidrometro__dbt_tmp')
    )
  DROP index "dbo_mig"."cad_hidrometro__dbt_tmp".dbo_mig_cad_hidrometro__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_cad_hidrometro__dbt_tmp_cci
    ON "dbo_mig"."cad_hidrometro__dbt_tmp"

   

