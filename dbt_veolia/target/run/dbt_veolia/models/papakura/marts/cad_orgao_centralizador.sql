
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."cad_orgao_centralizador__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."cad_orgao_centralizador__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."cad_orgao_centralizador__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."cad_orgao_centralizador__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."cad_orgao_centralizador__dbt_tmp_temp_view" as
    SELECT
row_number() over(order by act.ACCTNO) as ID_ORGAO_CENTRALIZADOR,
coalesce(cliente.NM_CLIENTE, ''default'') as NM_ORGAO_CENTRALIZADOR,
row_number() over(order by act.ACCTNO) as CD_ORGAO_CENTRALIZADOR,
21 as DIA_VENCIMENTO_ALTERNATIVO,
null as FL_GERA_COMUNICADO_DEBITO,
null as FL_GERA_OS_CORTE,
null as DS_COMPLEMENTO_ENDERECO,
1 as ID_ENDERECO,
2 as CH_TIPO_ENTREGA_FATURA_CENTRALIZADA,
null as ID_ORGAO_CENTRALIZADOR_SUPERIOR,
1 as CH_TIPO_EMISSAO_FATURA_ORGAO_CENTRALIZADOR,
1 as CH_ATIVO,
null as ID_GRUPO_FATURAMENTO,
1 as CH_TIPO_ORGAO,
cliente.CH_CLIENTE as CH_CLIENTE,
null as CH_TIPO_CATEGORIA_TARIFA,
null as ID_MODELO_FATURA_EXPORTACAO,
null as FL_VENCIMENTO_UNIDADE,
null as FL_IMPRIME_CODIGO_BARRAS_FATURA_UNIDADE
FROM
"papakura_20221223"."dbo"."ACCOUNTS" act
left join "papakura_20221223"."dbo_mig"."cad_endereco" endereco on endereco.ACTID = act.ACCTNO
left join "papakura_20221223"."dbo_mig"."cad_cliente" cliente on cliente.CH_CLIENTE = act.ACCTNO
where act.ACCTNO = 100000000
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."cad_orgao_centralizador__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."cad_orgao_centralizador__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."cad_orgao_centralizador__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."cad_orgao_centralizador__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_cad_orgao_centralizador__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_cad_orgao_centralizador__dbt_tmp')
    )
  DROP index "dbo_mig"."cad_orgao_centralizador__dbt_tmp".dbo_mig_cad_orgao_centralizador__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_cad_orgao_centralizador__dbt_tmp_cci
    ON "dbo_mig"."cad_orgao_centralizador__dbt_tmp"

   
