
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."seg_usuario__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."seg_usuario__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."seg_usuario__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."seg_usuario__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."seg_usuario__dbt_tmp_temp_view" as
    SELECT
row_number() over(order by USREMAILADDR) + 100 as ID_USUARIO,
row_number() over(order by USREMAILADDR) + 100 as NU_MATRICULA,
USRNAME as NM_USUARIO,
CASE WHEN USERID = ''9999'' THEN ''GENTRACK'' ELSE USERID END as NM_LOGIN,
coalesce(USRSECURITY, ''STRING'') as NM_SENHA,
null as NM_CPF,
USREMAILADDR as NM_EMAIL,
null as FL_COLABORADOR,
USRSTATUS as FL_USUARIO_ATIVO,
null as FL_PERMITE_LOGIN,
null as NR_TENTATIVA_LOGIN,
''2022-01-01'' as DT_ULTIMA_ATUALIZACAO_SENHA,
null as FL_SINCRONIZADO_E_R_P,
null as FL_AUDITORIA_USUARIO_ATIVA,
100002 as ID_ESTRUTURA_EMPRESA,
CASE
    WHEN USRSTATUS = ''A'' THEN 1 
    ELSE 0
END as CH_ATIVO,
null as CH_CARGO,
null as ID_EMPREITEIRA,
null as ID_AGENCIA,
null as CH_FORMA_AUTENTICACAO_USUARIO,
null as ID_SERVIDOR_LDAP,
null as ID_EMPRESA_COBRANCA,
null as DS_CODIGO_BARRA,
null as DT_NASCIMENTO,
null as ID_USUARIO_BEMOBY,
null as FL_STATUS_BEMOBY,
null as ID_EQUIPE_BEMOBY,
null as ID_API_KEY,
4 as CH_IDIOMA_LOCALIZACAO
FROM
"papakura_20221223"."dbo"."EMSUSER"
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."seg_usuario__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."seg_usuario__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."seg_usuario__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."seg_usuario__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_seg_usuario__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_seg_usuario__dbt_tmp')
    )
  DROP index "dbo_mig"."seg_usuario__dbt_tmp".dbo_mig_seg_usuario__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_seg_usuario__dbt_tmp_cci
    ON "dbo_mig"."seg_usuario__dbt_tmp"

   

