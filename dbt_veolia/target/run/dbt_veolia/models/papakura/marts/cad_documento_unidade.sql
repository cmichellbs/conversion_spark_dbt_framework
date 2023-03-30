
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."cad_documento_unidade__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."cad_documento_unidade__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."cad_documento_unidade__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."cad_documento_unidade__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."cad_documento_unidade__dbt_tmp_temp_view" as
    

WITH INTERM AS (SELECT C.*, ROW_NUMBER() OVER(PARTITION BY C.CINSTALL ORDER BY CONSUMERNO DESC)  AS RN FROM dbo.CONSUMER C)

,CONSUMER AS(SELECT * FROM INTERM  )

,INTERM_CUSTOMER AS(SELECT ROW_NUMBER() OVER(PARTITION BY CUSR_ACCTNO ORDER BY CUSR_CUSTOMER DESC ) AS RN,C.* FROM dbo.CUSTOMERROLE C)

,CUSTOMER AS(SELECT * FROM INTERM_CUSTOMER  )

,MEMO AS(
select MEMO_SEQNO, CONS.CINSTALL AS id, CONS.CONSUMERNO AS idcons from dbo.EMS_MEMO
inner JOIN CONSUMER CONS ON CONS.CINSTALL = MEMO_INSTALL
where MEMO_TYPE = ''000''
UNION 

select MEMO_SEQNO,  CONS.CINSTALL AS id, CONS.CONSUMERNO as idcons from dbo.EMS_MEMO
inner JOIN CONSUMER CONS ON CONS.CACCT = MEMO_ACCOUNT
where MEMO_TYPE = ''000''

union

select MEMO_SEQNO, CONS.CINSTALL AS id, CONS.CONSUMERNO AS idcons from dbo.EMS_MEMO
inner JOIN CUSTOMER CUS ON CUS.CUSR_CUSTOMER = MEMO_CUSTOMER
LEFT JOIN CONSUMER CONS ON CONS.CACCT = CUS.CUSR_ACCTNO

where MEMO_TYPE = ''000'' and CONS.CINSTALL is not null

UNION

select MEMO_SEQNO, CONS.CINSTALL AS id, CONS.CONSUMERNO AS idcons from dbo.EMS_MEMO
inner JOIN CONSUMER CONS ON CONS.CONSUMERNO = MEMO_CONSUMER
where MEMO_TYPE = ''000''
)
, INTERM_MEMO AS (SELECT MEMO.*, ROW_NUMBER() OVER(PARTITION BY MEMO_SEQNO ORDER BY idcons DESC) AS RN FROM MEMO)

, IDMEMOSEQ as (SELECT * FROM INTERM_MEMO
WHERE RN = 1)

,final as(
SELECT DT.DOCBD$DATAID as id_documento_unidade, 

HEADER.DOCBH$FILENAME as nm_documento,
cast(EM.MEMO_MESSAGE as varchar(max)) as ds_documento,
EM.MEMO_DATE AS dt_gravacao,
IDMEMO.id as ch_matricula_unidade,
1 as id_usuario
FROM dbo.EMS_MEMO#IMAGE IMAGEM
INNER JOIN dbo.DOCBHEADER HEADER ON HEADER.DOCBH$SEQNO = IMAGEM.MEMO_IMGID
left join dbo.DOCBDATA DT  ON DT.DOCBD$DATAID = HEADER.DOCBH$DATAID
left join IDMEMOSEQ IDMEMO ON IDMEMO.MEMO_SEQNO = IMAGEM.MEMO_SEQNO
left join EMS_MEMO EM ON EM.MEMO_SEQNO = IMAGEM.MEMO_SEQNO 
inner join "papakura_20221223"."dbo_mig"."cad_unidade_comercial" cuc on cuc.CH_MATRICULA_UNIDADE=IDMEMO.id
WHERE IDMEMO.id  is not null)

select * from final
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."cad_documento_unidade__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."cad_documento_unidade__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."cad_documento_unidade__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."cad_documento_unidade__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_cad_documento_unidade__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_cad_documento_unidade__dbt_tmp')
    )
  DROP index "dbo_mig"."cad_documento_unidade__dbt_tmp".dbo_mig_cad_documento_unidade__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_cad_documento_unidade__dbt_tmp_cci
    ON "dbo_mig"."cad_documento_unidade__dbt_tmp"

   

