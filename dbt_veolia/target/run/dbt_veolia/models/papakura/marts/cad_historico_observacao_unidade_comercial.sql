
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."cad_historico_observacao_unidade_comercial__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."cad_historico_observacao_unidade_comercial__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."cad_historico_observacao_unidade_comercial__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."cad_historico_observacao_unidade_comercial__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."cad_historico_observacao_unidade_comercial__dbt_tmp_temp_view" as
    

WITH FIN  AS (SELECT
-- row_number() over( order by MEMO_DATE) as ID_HISTORICO_OBSERVACAO_UNIDADE_COMERCIAL,
CAST(MEMO.MEMO_DATE AS VARCHAR) as DT_GRAVACAO,
cast(CONCAT(MEMO.MEMO_MESSAGE,'' '',GDF.FIELDLABEL,'' FROM: '',isnull(EAC.AUD_BEFORE,''EMPTY''), '' TO: '',ISNULL(EAC.AUD_AFTER,''EMPTY'')) as varchar(8000)) as DS_OBSERVACAO,
coalesce(USR.ID_USUARIO, 50) as ID_USUARIO,
c.CH_MATRICULA_UNIDADE as CH_MATRICULA_UNIDADE,
MEMO.MEMO_SEQNO AS MIG_PK_TEMP
FROM
"papakura_20221223"."dbo_mig"."cad_unidade_comercial" c
inner JOIN "papakura_20221223"."dbo_mig"."IDMEMOSEQ" AS id on id.id = c.CH_MATRICULA_UNIDADE
inner join "papakura_20221223"."dbo"."EMS_MEMO" MEMO on MEMO.MEMO_SEQNO = id.MEMO_SEQNO
left JOIN "papakura_20221223"."dbo_mig"."seg_usuario" USR ON USR.NM_LOGIN = MEMO.MEMO_USER
left join "papakura_20221223"."dbo"."EMS_AUDIT" EA ON EA.AUD_MEMO = MEMO.MEMO_SEQNO
LEFT JOIN "papakura_20221223"."dbo"."EMS_AUDIT#CHANGE" EAC ON EAC.AUD_ID = EA.AUD_ID
LEFT JOIN "papakura_20221223"."dbo"."GEN_DEF_FILE#FIELDS"GDF ON GDF.FILENAME = EA.AUD_FILE AND GDF.FIELDNAME = EAC.AUD_DESC
)

SELECT 
row_number() over( order by DT_GRAVACAO) as ID_HISTORICO_OBSERVACAO_UNIDADE_COMERCIAL,
* FROM FIN
GROUP BY CH_MATRICULA_UNIDADE,MIG_PK_TEMP,DT_GRAVACAO,ID_USUARIO,DS_OBSERVACAO
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."cad_historico_observacao_unidade_comercial__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."cad_historico_observacao_unidade_comercial__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."cad_historico_observacao_unidade_comercial__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."cad_historico_observacao_unidade_comercial__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_cad_historico_observacao_unidade_comercial__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_cad_historico_observacao_unidade_comercial__dbt_tmp')
    )
  DROP index "dbo_mig"."cad_historico_observacao_unidade_comercial__dbt_tmp".dbo_mig_cad_historico_observacao_unidade_comercial__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_cad_historico_observacao_unidade_comercial__dbt_tmp_cci
    ON "dbo_mig"."cad_historico_observacao_unidade_comercial__dbt_tmp"

   

