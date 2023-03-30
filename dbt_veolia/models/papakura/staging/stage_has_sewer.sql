--select * from EMS_CON_PLAN
WITH BASE AS (

SELECT ECPLAN_KEY,ECPLAN_FCHGCODE AS TARC$CODE FROM EMS_CON_PLAN#FIXED_LIST

UNION

SELECT ECPLAN_KEY,ECPLAN_TARCODE FROM EMS_CON_PLAN#REGISTER_LIST

UNION

SELECT ECPLAN_KEY, CASE WHEN ECPLAN_KEY = 'UWA' THEN 'NO_TARC_CODE' ELSE ECPLAN_KEY END AS TARC$CODE
FROM EMS_CON_PLAN ecp 
)
,BASE2 AS (
SELECT BASE.*, TC.TARC$INV$HEAD$GRP AS WS FROM BASE
LEFT JOIN TARCHARGE TC ON TC.TARC$CODE = BASE.TARC$CODE

UNION

SELECT BASE.*, CASE WHEN ECPLAN_KEY = 'UWA' THEN 'DO_NOT_USE' ELSE TC.TARC$INV$HEAD$GRP END AS WS FROM BASE
LEFT JOIN TARCHARGE TC ON TC.TARC$TEMPLATE = BASE.TARC$CODE
)
,FINAL AS (
SELECT BASE2.ECPLAN_KEY, MAX(CASE WHEN WS = 'SEWER' THEN 1 ELSE 0 END) AS HAS_SEWER, MAX(CASE WHEN  WS = 'SEWER' AND ((TARC$CODE <> 'STREA0' AND TARC$CODE LIKE '%STREA%') OR TARC$CODE = 'SVOL')  THEN 1 ELSE 0 END) AS HAS_SEWER_TREATED  FROM BASE2
WHERE WS IS NOT NULL
GROUP BY ECPLAN_KEY
)

SELECT *FROM FINAL 
--BASE2




