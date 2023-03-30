WITH TC AS (SELECT TC.*,
CASE 
	WHEN TC.TARC$CODE       NOT 
	IN (SELECT DISTINCT CRAT$CODE FROM TARRATE)
	THEN TC.TARC$TEMPLATE ELSE TC.TARC$CODE 
END AS TARC$CODE2
FROM TARCHARGE TC
WHERE TC.TARC$INV$HEAD$GRP = 'SEWER'
)

,VL_TARIFA AS (
SELECT TC.TARC$CODE, TR.CRAT$RATE,TR.CRAT$DATE,TC.TARC$TEMPLATE  FROM TC
INNER JOIN TARRATE TR ON TR.CRAT$CODE = TC.TARC$CODE2)
,ECP AS(SELECT ECP.ECPLAN_KEY,ECPR.ECPLAN_TARCODE FROM EMS_CON_PLAN ECP
INNER JOIN EMS_CON_PLAN#REGISTER_LIST ECPR ON ECPR.ECPLAN_KEY = ECP.ECPLAN_KEY)

,VL_TARIFA_FINAL AS(SELECT * FROM ECP 
INNER JOIN VL_TARIFA VT ON VT.TARC$CODE = ECP.ECPLAN_TARCODE
)
--
--SELECT 
--ECPLAN_KEY,
--CRAT$DATE, 
--SUM(CRAT$RATE) OVER(ORDER BY ECPLAN_KEY,CRAT$DATE) AS SEWER_TARIF
--FROM VL_TARIFA_FINAL
--GROUP BY ECPLAN_KEY,CRAT$DATE,CRAT$RATE

,CTE AS (
SELECT 
ECPLAN_KEY, 
CASE WHEN TARC$TEMPLATE = 'SSERV' THEN CRAT$RATE ELSE NULL END AS SSERV,
CASE WHEN TARC$TEMPLATE = 'STREA' THEN CRAT$RATE ELSE NULL END AS STREA,
CASE WHEN TARC$TEMPLATE = 'SVOL' THEN CRAT$RATE ELSE NULL END AS SVOL,
TARC$TEMPLATE,
CRAT$DATE
FROM VL_TARIFA_FINAL
GROUP BY ECPLAN_KEY,CRAT$DATE,TARC$TEMPLATE,CRAT$RATE
)

--SELECT * FROM CTE

--
, FIN AS (SELECT ECPLAN_KEY, 
CASE WHEN YEAR(CRAT$DATE) >= 2014  AND SUM(SVOL) IS NULL THEN SUM(COALESCE(SSERV,0) + COALESCE(STREA,0)) + 2030000.000000 ELSE 

SUM(COALESCE(SSERV,0) + COALESCE(STREA,0)) END AS SSERV_STREA, SUM(SVOL) AS SVOL,CRAT$DATE
FROM CTE
GROUP BY ECPLAN_KEY,CRAT$DATE)

SELECT ECPLAN_KEY, CRAT$DATE,
CASE WHEN SVOL IS NULL THEN SSERV_STREA ELSE SVOL END AS SEWER_TARIFF

FROM FIN