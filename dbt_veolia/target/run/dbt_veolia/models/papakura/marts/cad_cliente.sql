
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."cad_cliente__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."cad_cliente__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."cad_cliente__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."cad_cliente__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."cad_cliente__dbt_tmp_temp_view" as
    
SELECT
cast(ACC.ACCTNO as varchar) AS CH_CLIENTE,
1 AS CH_ATIVO,
1 AS CH_NACIONALIDADE,
1 AS CH_ESTADO_CIVIL,
13 AS CH_CARGO,
1 AS CH_TIPO_DOCUMENTO,
NULL as ID_ENDERECO_CLIENTE_RESIDENCIAL,
null AS NU_RG,
NULL as ID_ENDERECO_CLIENTE_COMERCIAL,
1 AS CH_MUNICIPIO,
28 as  ID_UF,
NULL AS DT_NASCIMENTO,
null AS NM_PAI,
null AS NM_MAE,
cast(ACC.ACMSG as varchar(max)) AS DS_OBSERVACAO,
null AS NR_INSCRICAO_ESTADUAL,
cast(coalesce(concat('''','''',cast(ACC.ACNAME as varchar) ),cast(ACC.ACCTNO as varchar)) as varchar) AS NM_CLIENTE,
null AS NU_DOCUMENTO,
null AS NU_CPF_CNPJ,
null AS NU_TELEFONE_CLIENTE,
null AS NU_TELEFONE_CLIENTE_COM,
null AS NU_TELEFONE_CLIENTE_CEL,
1 AS FL_CPF_CNPJ,
NULL AS EMAIL,
NULL AS DS_ORGAO_EXPEDIDOR_RG,
NULL AS DT_EXPEDICAO_RG,
null AS NU_TELEFONE_CLIENTE_CEL2,
21450001 AS CH_SEXO,
ACC.ACCTNO AS MIG_PK_TEMP
from "papakura_20221223"."dbo"."ACCOUNTS" ACC
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."cad_cliente__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."cad_cliente__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."cad_cliente__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."cad_cliente__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_cad_cliente__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_cad_cliente__dbt_tmp')
    )
  DROP index "dbo_mig"."cad_cliente__dbt_tmp".dbo_mig_cad_cliente__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_cad_cliente__dbt_tmp_cci
    ON "dbo_mig"."cad_cliente__dbt_tmp"

   

