
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."IDMEMOSEQ__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."IDMEMOSEQ__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."IDMEMOSEQ__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."IDMEMOSEQ__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."IDMEMOSEQ__dbt_tmp_temp_view" as
    WITH INTERM AS (SELECT C.*, ROW_NUMBER() OVER(PARTITION BY C.CINSTALL ORDER BY CONSUMERNO DESC)  AS RN FROM "papakura_20221223"."dbo"."CONSUMER" C)

,CONSUMER AS(SELECT * FROM INTERM  )

,INTERM_CUSTOMER AS(SELECT ROW_NUMBER() OVER(PARTITION BY CUSR_ACCTNO ORDER BY CUSR_CUSTOMER DESC ) AS RN,C.* FROM "papakura_20221223"."dbo"."CUSTOMERROLE" C)

,CUSTOMER AS(SELECT * FROM INTERM_CUSTOMER  )

,MEMO AS(
select MEMO_SEQNO, CONS.CINSTALL AS id, CONS.CONSUMERNO AS idcons from "papakura_20221223"."dbo"."EMS_MEMO" 
inner JOIN CONSUMER CONS ON CONS.CINSTALL = MEMO_INSTALL
where MEMO_TYPE in (051,028,026,082,023,007,008,009,000,077,021,022,037,027,044,046,040,045,042,041,035,039)
UNION ALL

select MEMO_SEQNO,  CONS.CINSTALL AS id, CONS.CONSUMERNO as idcons from "papakura_20221223"."dbo"."EMS_MEMO" 
inner JOIN CONSUMER CONS ON CONS.CACCT = MEMO_ACCOUNT
where MEMO_TYPE in (051,028,026,082,023,007,008,009,000,077,021,022,037,027,044,046,040,045,042,041,035,039)

union ALL

select MEMO_SEQNO, CONS.CINSTALL AS id, CONS.CONSUMERNO AS idcons from "papakura_20221223"."dbo"."EMS_MEMO" 
inner JOIN CUSTOMER CUS ON CUS.CUSR_CUSTOMER = MEMO_CUSTOMER
LEFT JOIN CONSUMER CONS ON CONS.CACCT = CUS.CUSR_ACCTNO

where MEMO_TYPE in (051,028,026,082,023,007,008,009,000,077,021,022,037,027,044,046,040,045,042,041,035,039)

UNION ALL

select MEMO_SEQNO, CONS.CINSTALL AS id, CONS.CONSUMERNO AS idcons from "papakura_20221223"."dbo"."EMS_MEMO" 
inner JOIN CONSUMER CONS ON CONS.CONSUMERNO = MEMO_CONSUMER
where MEMO_TYPE in (051,028,026,082,023,007,008,009,000,077,021,022,037,027,044,046,040,045,042,041,035,039)
)
, INTERM_MEMO AS (SELECT MEMO.*, ROW_NUMBER() OVER(PARTITION BY MEMO_SEQNO ORDER BY idcons DESC) AS RN FROM MEMO)

SELECT * FROM INTERM_MEMO
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."IDMEMOSEQ__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."IDMEMOSEQ__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."IDMEMOSEQ__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."IDMEMOSEQ__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_IDMEMOSEQ__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_IDMEMOSEQ__dbt_tmp')
    )
  DROP index "dbo_mig"."IDMEMOSEQ__dbt_tmp".dbo_mig_IDMEMOSEQ__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_IDMEMOSEQ__dbt_tmp_cci
    ON "dbo_mig"."IDMEMOSEQ__dbt_tmp"

   

