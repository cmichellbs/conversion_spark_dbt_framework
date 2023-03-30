with BASE_STTM AS (
 select d.DSTATEMENT AS FATURA, sum(DAMT) as DAMT , sum(DPAID) as DPAID,SUM(DBAL) AS DBAL , SUM(DSTATUS)/(3*COUNT(DKEY)) AS PT from {{source('papakura','DEBT')}} d 
where d.DSTATEMENT IS NOT NULL
GROUP BY DSTATEMENT 
)

, BASE_INV AS ( select d.DINVOICEREF AS FATURA, sum(DAMT) as DAMT , sum(DPAID) as DPAID,SUM(DBAL) AS DBAL, SUM(DSTATUS)/(3*COUNT(DKEY)) AS PT from {{source('papakura','DEBT')}} d 
where DINVOICEREF is not null and DSTATEMENT is null and left(DREF,3) <> 'Rev' and left(DREF,3) <> 'REV' and left(DREF,3) <> 'rev'
GROUP BY DINVOICEREF)

,STATUS_PAGO AS (
SELECT * FROM BASE_STTM

UNION ALL

SELECT * FROM BASE_INV
)

select * from STATUS_PAGO