SELECT GBIINVOICE,
(CASE WHEN GBIREV_TYPE IS NULL THEN
   (SELECT CASE
   WHEN SUM(DBAL) = 0 THEN 2
   WHEN SUM(DBAL) > 0 THEN 1
   ELSE 5
   END 
      FROM DEBT WHERE DINVOICEREF = GBINVOICE.gbiinvoice  
      )
      ELSE 3
         END) as status
         FROM GBINVOICE