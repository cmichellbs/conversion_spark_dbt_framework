select DINVOICEREF AS GBIINVOICE,
sum(cast(DAMT as decimal(16,2)))/ 100 as DAMT,
sum(cast(DPAID as decimal(16,2)))/100 as DPAID, 
sum(cast(DBAL as decimal(16,2)))/100 as DBAL , 
case when ((sum(cast(DAMT as decimal(16,2)))/ 100)- (sum(cast(DPAID as decimal(16,2)))/ 100)) > 0 then 0 else 1 end as STATUS_PAGO
from DEBT d 
where DINVOICEREF is not NULL 
and left(DREF,3) <> 'Rev' and left(DREF,3) <> 'REV' and left(DREF,3) <> 'rev'
group by DINVOICEREF