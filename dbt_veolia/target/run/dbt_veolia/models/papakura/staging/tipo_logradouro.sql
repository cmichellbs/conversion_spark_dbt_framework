
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."tipo_logradouro__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."tipo_logradouro__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."tipo_logradouro__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."tipo_logradouro__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."tipo_logradouro__dbt_tmp_temp_view" as
    WITH SEL AS (select G.*, VALUE AS PARAMETROS  from GBIACCRUAL G CROSS APPLY STRING_SPLIT(G.GBILOCN_ADDR,'',''))

,base AS (SELECT SEL.*, VALUE AS TIPO_LOGRADOURO,
CASE 
	WHEN ISNUMERIC(VALUE) = 1 THEN ''NUMERO''
	WHEN ISNUMERIC(VALUE) = 0 AND value in (''AVE'',''BD'',''CL'',''CT'',''CR'',''DR'',''LN'',''PL'',''RD'',''ST'',''TCE'') THEN ''TIPO_LOGRADOURO'' 
	ELSE ''LOGRADOURO''
END AS TIPO




FROM SEL CROSS APPLY STRING_SPLIT(SEL.PARAMETROS,'' ''))



select GBIINSTALL,TIPO_LOGRADOURO from base
WHERE TIPO = ''TIPO_LOGRADOURO''
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."tipo_logradouro__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."tipo_logradouro__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."tipo_logradouro__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."tipo_logradouro__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_tipo_logradouro__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_tipo_logradouro__dbt_tmp')
    )
  DROP index "dbo_mig"."tipo_logradouro__dbt_tmp".dbo_mig_tipo_logradouro__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_tipo_logradouro__dbt_tmp_cci
    ON "dbo_mig"."tipo_logradouro__dbt_tmp"

   

