
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."EMS_CON_PLAN_ADJ__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."EMS_CON_PLAN_ADJ__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."EMS_CON_PLAN_ADJ__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."EMS_CON_PLAN_ADJ__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."EMS_CON_PLAN_ADJ__dbt_tmp_temp_view" as
    select *,
case
when ECPLAN_DESC = ''Data Fixing, No Sewer Conn. (No Charge) - 1/7/14 to 30/6/25'' then 0
when ECPLAN_DESC = ''Data Fixing, Domestic (No Charge) - 1/7/14 to 30/6/25'' then 0
when ECPLAN_DESC = ''Data Fixing, Ind/Comm (No Charge) - 1/7/14 to 30/6/25'' then 0
when ECPLAN_DESC = ''Dump Station - 1/7/14 to 30/6/25 (100% Water + Fixed Wastewater Connection Charge)'' then 1
when ECPLAN_DESC = ''Industrial/Commercial (DO NOT USE)'' then 0
when ECPLAN_DESC = ''Industrial/Commercial - 1/7/14 to 30/6/25'' then 0
when ECPLAN_DESC = ''Ind/Comm- 80% Sewer,No IC fee (DO NOT USE)'' then 0.8
when ECPLAN_DESC = ''Ind/Comm- 80% Sewer,208% IC (DO NOT USE)'' then 0.8
when ECPLAN_DESC = ''Industrial/Commercial - Building/Under Construction (DO NOT USE)'' then 0
when ECPLAN_DESC = ''Industrial/Commercial - Full Regionalized Charge Structure (High User Plan) 50%'' then 0.5
when ECPLAN_DESC = ''Industrial/Commercial - Full Regionalized Charge Structure (High User Plan) 50%, Vol. Charges Only'' then 0.5
when ECPLAN_DESC = ''Industrial/Commercial - Full Regionalized Charge Structure (High User Plan) 66%'' then 0.66
when ECPLAN_DESC = ''Industrial/Commercial - Full Regionalized Charge Structure (High User Plan) 95%'' then 0.95
when ECPLAN_DESC = ''Industrial/Commercial - Full Regionalized Charge Structure (High User Plan) 95%, Vol. Charges Only'' then 0.95
when ECPLAN_DESC = ''Industrial/Commercial - Full Regionalized Charge Structure (High User Plan) Sewer Only'' then 0
when ECPLAN_DESC = ''Industrial/Commercial - No I/C Charge (DO NOT USE)'' then 0
when ECPLAN_DESC = ''Industrial/Commercial - 1/7/14 to 30/6/25 (No I/C Charge)'' then 0
when ECPLAN_DESC = ''Industrial/Commercial - No I/C Charge, No Minimum Charge (DO NOT USE)'' then 0
when ECPLAN_DESC = ''Industrial/Commercial - 1/7/14 to 30/6/25 (No I/C Charge + No Minimum Charge)'' then 0
when ECPLAN_DESC = ''Industrial/Commercial - Full Regionalized Charge Structure (Industry Plan) 50%'' then 0.5
when ECPLAN_DESC = ''Industrial/Commercial - Full Regionalized Charge Structure (Industry Plan) 50%, Vol. Charges Only'' then 0.5
when ECPLAN_DESC = ''Industrial/Commercial - Full Regionalized Charge Structure (Industry Plan) 66%'' then 0.66
when ECPLAN_DESC = ''Industrial/Commercial - Full Regionalized Charge Structure (Industry Plan) 66%, Vol. Charges Only'' then 0.66
when ECPLAN_DESC = ''Industrial/Commercial - Full Regionalized Charge Structure (Industry Plan) 85%'' then 0.85
when ECPLAN_DESC = ''Industrial/Commercial - Full Regionalized Charge Structure (Industry Plan) 85%, Vol. Charges Only'' then 0.85
when ECPLAN_DESC = ''Industrial/Commercial - Full Regionalized Charge Structure (Industry Plan) 95%'' then 0.95
when ECPLAN_DESC = ''Industrial/Commercial - Full Regionalized Charge Structure (Industry Plan) 95%, Vol. Charges Only'' then 0.95
when ECPLAN_DESC = ''Industrial/Commercial - Full Regionalized Charge Structure (Low User Plan) 5%'' then 0.05
when ECPLAN_DESC = ''Industrial/Commercial - Full Regionalized Charge Structure (Low User Plan) 5%, Vol. Charges Only'' then 0.05
when ECPLAN_DESC = ''Industrial/Commercial - Full Regionalized Charge Structure (Low User Plan) 95%'' then 0.95
when ECPLAN_DESC = ''Industrial/Commercial - Full Regionalized Charge Structure (Low User Plan) 95%, Vol. Charges Only'' then 0.95
when ECPLAN_DESC = ''Industrial/Commercial - No Minimum Charge (DO NOT USE)'' then 0
when ECPLAN_DESC = ''Industrial/Commercial - 1/7/14 to 30/6/25 (No Minimum Charge)'' then 0
when ECPLAN_DESC = ''Industrial/Commercial - Full Regionalized Charge Structure (Moderate User Plan) 5%'' then 0.05
when ECPLAN_DESC = ''Industrial/Commercial - Full Regionalized Charge Structure (Moderate User Plan) 5%, Vol.Charges Only'' then 0.05
when ECPLAN_DESC = ''Industrial/Commercial - Full Regionalized Charge Structure (Moderate User Plan) 50%'' then 0.5
when ECPLAN_DESC = ''Industrial/Commercial - Full Regionalized Charge Structure (Moderate User Plan) 95%'' then 0.95
when ECPLAN_DESC = ''Industrial/Commercial - Full Regionalized Charge Structure (Moderate User Plan)95%, Vol.Charges Only'' then 0.95
when ECPLAN_DESC = ''Residential (DO NOT USE)'' then 0
when ECPLAN_DESC = ''Ind/Comm - Water + I/C (No Sewer Cons. Charges) (DO NOT USE)'' then 0
when ECPLAN_DESC = ''Industrial/Commercial - No Sewer Service, No I/C Charge (DO NOT USE)'' then 0
when ECPLAN_DESC = ''Ind/Comm- 80% Sewer + IC (DO NOT USE)'' then 0.8
when ECPLAN_DESC = ''Industrial/Commercial - No Sewer Treatment (DO NOT USE)'' then 0
when ECPLAN_DESC = ''Industrial/Commercial - Sewer Treatment 1% (DO NOT USE)'' then 0.01
when ECPLAN_DESC = ''Industrial/Commercial - Sewer 1% (DO NOT USE)'' then 0.01
when ECPLAN_DESC = ''Industrial/Commercial - Sewer 4% (DO NOT USE)'' then 0.04
when ECPLAN_DESC = ''Industrial/Commercial - Sewer Treatment 5% (DO NOT USE)'' then 0.05
when ECPLAN_DESC = ''Industrial/Commercial - Sewer 5% (DO NOT USE)'' then 0.05
when ECPLAN_DESC = ''Industrial/Commercial - Sewer Treatment 6% (DO NOT USE)'' then 0.06
when ECPLAN_DESC = ''Industrial/Commercial - No Sewer Treatment, No I/C Charge (DO NOT USE)'' then 0
when ECPLAN_DESC = ''Industrial/Commercial - Water Only (DO NOT USE)'' then 0
when ECPLAN_DESC = ''Industrial/Commercial - No Sewer Treatment, Sewer Service 2% (DO NOT USE)'' then 0.02
when ECPLAN_DESC = ''Industrial/Commercial - Water + I/C (DO NOT USE)'' then 0
when ECPLAN_DESC = ''Industrial/Commercial - Water Only, No I/C Charge (DO NOT USE)'' then 0
when ECPLAN_DESC = ''Industrial/Commercial - 1/7/14 to 30/6/25 (Water Only + No I/C Charge)'' then 0
when ECPLAN_DESC = ''Industrial/Commercial - Water Only, No Minimum Charge (DO NOT USE)'' then 0
when ECPLAN_DESC = ''Industrial/Commercial - No Sewer Treatment, Sewer Service 100% (DO NOT USE)'' then 1
when ECPLAN_DESC = ''Industrial/Commercial - No Sewer Treatment, Sewer Service 100%, No I/C Charge (DO NOT USE)'' then 1
when ECPLAN_DESC = ''Industrial/Commercial - No Sewer Treatment, Sewer Service 50% (DO NOT USE)'' then 0.5
when ECPLAN_DESC = ''Industrial/Commercial - No Sewer Treatment, Sewer Service 50%, No I/C Charge (DO NOT USE)'' then 0.5
when ECPLAN_DESC = ''Industrial/Commercial - No Sewer Treatment, Sewer Service 80% (DO NOT USE)'' then 0.8
when ECPLAN_DESC = ''Industrial/Commercial - No Sewer Treatment, Sewer Service 80%, No I/C Charge (DO NOT USE)'' then 0.8
when ECPLAN_DESC = ''Industrial/Commercial - Sewer 10% (DO NOT USE)'' then 0.1
when ECPLAN_DESC = ''Industrial/Commercial - Sewer 10%, No I/C Charge (DO NOT USE)'' then 0.1
when ECPLAN_DESC = ''Industrial/Commercial - Sewer Treatment 18% (DO NOT USE)'' then 0.18
when ECPLAN_DESC = ''Industrial/Commercial - Sewer 18% (DO NOT USE)'' then 0.18
when ECPLAN_DESC = ''Industrial/Commercial - Sewer 19% (DO NOT USE)'' then 0.19
when ECPLAN_DESC = ''Industrial/Commercial - Sewer Treatment 20% (DO NOT USE)'' then 0.2
when ECPLAN_DESC = ''Industrial/Commercial - Sewer Treatment 25% (DO NOT USE)'' then 0.25
when ECPLAN_DESC = ''Industrial/Commercial - Sewer 25% (DO NOT USE)'' then 0.25
when ECPLAN_DESC = ''Industrial/Commercial - Sewer 80% No I/C Charge (DO NOT USE)'' then 0.8
when ECPLAN_DESC = ''Industrial/Commercial - Sewer 80% (DO NOT USE)'' then 0.8
when ECPLAN_DESC = ''Industrial/Commercial - Sewer 80% (DO NOT USE)'' then 0.8
when ECPLAN_DESC = ''Industrial/Commercial - Sewer 80% No I/C Charge (DO NOT USE)'' then 0.8
when ECPLAN_DESC = ''Industrial/Commercial - Sewer 80%, I/C Charge 208.3% (DO NOT USE)'' then 0.8
when ECPLAN_DESC = ''Industrial/Commercial - Sewer 80%, I/C Charge 208.3% (DO NOT USE)'' then 0.8
when ECPLAN_DESC = ''Industrial/Commercial - 1/7/14 to 30/6/25 (Sewer 1%)'' then 0.01
when ECPLAN_DESC = ''Industrial/Commercial - 1/7/14 to 30/6/25 (Sewer 4%)'' then 0.04
when ECPLAN_DESC = ''Industrial/Commercial - 1/7/14 to 30/6/25 (Sewer 5%)'' then 0.05
when ECPLAN_DESC = ''Ind/Comm - 1/7/14 to 30/6/25 (Water + I/C only, No Sewer Cons. Charges)'' then 0
when ECPLAN_DESC = ''Industrial/Commercial - 1/7/14 to 30/6/25 (Sewer Service 100% + IC + No Sewer Volumetric Charge)'' then 1
when ECPLAN_DESC = ''Industrial/Commercial - 1/7/14 to 30/6/25 (Sewer Service 100% + No Sewer Vol. + No I/C Charge)'' then 1
when ECPLAN_DESC = ''Industrial/Commercial - 1/7/14 to 30/6/25 (Sewer Service 50% + No I/C & Sewer Vol.Charge''''s)'' then 0.5
when ECPLAN_DESC = ''Industrial/Commercial - 1/7/14 to 30/6/25 (Sewer Service 50% + IC + No Sewer Vol.Charge)'' then 0.5
when ECPLAN_DESC = ''Industrial/Commercial - 1/7/14 to 30/6/25 (Sewer 10%)'' then 0.1
when ECPLAN_DESC = ''Industrial/Commercial - 1/7/14 to 30/6/25 (100% Sewer Only + I/C Charge, No Water Charges)'' then 1
when ECPLAN_DESC = ''Industrial/Commercial - 1/7/14 to 30/6/25 (Sewer 10% + No I/C Charge)'' then 0.1
when ECPLAN_DESC = ''Industrial/Commercial - 1/7/14 to 30/6/25 (Sewer 18%)'' then 0.18
when ECPLAN_DESC = ''Industrial/Commercial - 1/7/14 to 30/6/25 (Sewer 19%)'' then 0.19
when ECPLAN_DESC = ''Industrial/Commercial - 1/7/14 to 30/6/25 (Sewer 20%)'' then 0.2
when ECPLAN_DESC = ''Industrial/Commercial - 1/7/14 to 30/6/25 (Sewer 25%)'' then 0.25
when ECPLAN_DESC = ''Industrial/Commercial - 1/7/14 to 30/6/25 (Sewer 60%)'' then 0.6
when ECPLAN_DESC = ''Industrial/Commercial - 1/7/14 to 30/6/25 (Sewer 80%)'' then 0.8
when ECPLAN_DESC = ''Industrial/Commercial - 1/7/14 to 30/6/25 (Sewer Vol.80% + I/C $500 per year)'' then 0.8
when ECPLAN_DESC = ''Industrial/Commercial - 1/7/14 to 30/6/25 (Sewer 80% + No I/C Charge)'' then 0.8
when ECPLAN_DESC = ''Industrial/Commercial - 1/7/14 to 30/6/25 (Sewer Vol. 95% + I/C)'' then 0.95
when ECPLAN_DESC = ''Industrial/Commercial - Sewer Only (DO NOT USE)'' then 0
when ECPLAN_DESC = ''Industrial/Commercial - Sewer Only, No I/C Charge (DO NOT USE)'' then 0
when ECPLAN_DESC = ''Residential (DO NOT USE)'' then 0
when ECPLAN_DESC = ''Residential - 1/7/14 to 30/6/25'' then 0
when ECPLAN_DESC = ''Residential - 1/7/14 to 30/6/25 (No Minimum Charge)'' then 0
when ECPLAN_DESC = ''Residential - Building/Under Construction (DO NOT USE)'' then 0
when ECPLAN_DESC = ''Residential - 1/7/14 to 30/6/25 (Building/Under Construction)'' then 0
when ECPLAN_DESC = ''Residential - No Minimum Charge (DO NOT USE)'' then 0
when ECPLAN_DESC = ''Residential - Sewer 100% + Water 100% (DO NOT USE)'' then 1
when ECPLAN_DESC = ''Residential - (Showhome) Water+10% Sewer (DO NOT USE)'' then 0.1
when ECPLAN_DESC = ''Residential - 1/7/14 to 30/6/25 (Showhome) Water+10% Sewer'' then 0.1
when ECPLAN_DESC = ''Residential - Water Only (DO NOT USE)'' then 0
when ECPLAN_DESC = ''Residential - 1/7/14 to 30/6/25 (Water Only)'' then 0
when ECPLAN_DESC = ''Residential - No Sewer Treatment, Sewer Service 2% (DO NOT USE)'' then 0.02
when ECPLAN_DESC = ''Residential - Sewer Only 100% (DO NOT USE)'' then 1
when ECPLAN_DESC = ''Residential - Water 100% + Sewer 50% (DO NOT USE)'' then 1
when ECPLAN_DESC = ''Residential - Sewer Only 80% (DO NOT USE)'' then 0.8
when ECPLAN_DESC = ''Residential - 1/7/14 to 30/6/25 (100% Water + Sewer Service 2%, No Sewer Vol. Charge)'' then 1
when ECPLAN_DESC = ''Residential - 1/7/14 to 30/6/25 (Sewer 100% + Water 100%)'' then 1
when ECPLAN_DESC = ''Residential - 1/7/14 to 30/6/25 (100% Sewer Only, No Water Charges)'' then 1
when ECPLAN_DESC = ''Residential - 1/7/14 to 30/6/25 (Water 100% + Sewer 50%)'' then 1
when ECPLAN_DESC = ''Residential - 1/7/14 to 30/6/25 (80% Sewer Only, No Water Charges)'' then 0.8
when ECPLAN_DESC = ''Sewer Only (No meter) - 1/7/14 to 30/6/25 (Fixed Wastewater Connection Charge)'' then 0
when ECPLAN_DESC = ''No Sewer Connection - Water Only (DO NOT USE)'' then 0
when ECPLAN_DESC = ''No Sewer Connection - 1/7/14 to 30/6/25 (Water Only)'' then 0
when ECPLAN_DESC = ''Tradewaste (1) - 1/7/14 to 30/6/15 (High User Plan) Sewer 100% Old 95% New'' then 1
when ECPLAN_DESC = ''Tradewaste (1) - 1/7/14 to 30/6/15 (Low User Plan) Sewer 4% Old 95% New + Discharge Charge'' then 0.04
when ECPLAN_DESC = ''Tradewaste (1) - 1/7/14 to 30/6/15 (Low User Plan) Sewer 80% Old 95% New + I/C $500 (2/3rd) per year'' then 0.8
when ECPLAN_DESC = ''Tradewaste (1) - 1/7/14 to 30/6/15 (Low User Plan) Sewer 100% Old 95% New'' then 1
when ECPLAN_DESC = ''Tradewaste (1) - 1/7/14 to 30/6/15 (Low User Plan) Sewer 95% New, No Old Sewer Charges'' then 0.95
when ECPLAN_DESC = ''Tradewaste (1) - 1/7/14 to 30/6/15 (Moderate User Plan) Sewer Vol. 5% + Fixed/Discharge Charges'' then 0.05
when ECPLAN_DESC = ''Tradewaste (1) - 1/7/14 to 30/6/15 (Moderate User Plan) Sewer 4% Old 5% New + Fixed Charges'' then 0.04
when ECPLAN_DESC = ''Tradewaste (1)- 1/7/14 to 30/6/15 (Mod.User Plan) Sewer 80% Old/New + I/C $500(2/3rd) per year'' then 0.8
when ECPLAN_DESC = ''Tradewaste (1)- 1/7/14 to 30/6/15 (Mod.User Plan) Sewer 80% Old 95% New'' then 0.8
when ECPLAN_DESC = ''Tradewaste (1) - 1/7/14 to 30/6/15 (Moderate User Plan) Sewer 100% Old 95% New'' then 1
when ECPLAN_DESC = ''Tradewaste (1) - 1/7/14 to 30/6/15 (Moderate User Plan) Sewer 95% New, No Old Sewer Charges'' then 0.95
when ECPLAN_DESC = ''Tradewaste (3) - 1/7/14 to 30/6/15 (Pryors Ltd - High User Plan) Sewer 100% Old 95% New'' then 1
when ECPLAN_DESC = ''Tradewaste(6) - 1/7/14 to 30/6/15 (Industry Plan)Sewer 100% Old 95% New + Discharge Charge(No I/C)'' then 1
when ECPLAN_DESC = ''Tradewaste - 1/7/14 to 30/6/15 (High User Plan) Sewer 80% Old 95% New'' then 0.8
when ECPLAN_DESC = ''Tradewaste - 1/7/14 to 30/6/15 (Industry Plan) Sewer 100% Old 95% New (Vol. Charges Only)'' then 1
when ECPLAN_DESC = ''Tradewaste - 1/7/14 to 30/6/15 (Industry Plan) Sewer 100% Old 95% New (Vol.+ Fixed Charges + I/C)'' then 1
when ECPLAN_DESC = ''Tradewaste - 1/7/14 to 30/6/15 (Low User Plan) Sewer 100% Old 95% New + No Discharge Charge'' then 1
when ECPLAN_DESC = ''Tradewaste - 1/7/14 to 30/6/15 (Low User Plan) Sewer 100% Old 95% New (Vol. Charges Only)'' then 1
when ECPLAN_DESC = ''Tradewaste - 1/7/14 to 30/6/15 (Low User Plan) Sewer 100% Old 95% New + No Old I/C Fee'' then 1
when ECPLAN_DESC = ''Tradewaste - 1/7/14 to 30/6/15 (Moderate User Plan) Sewer Vol. 5% + No Fixed Charges'' then 0.05
when ECPLAN_DESC = ''Tradewaste - 1/7/14 to 30/6/15 (Mod.User Plan) Sewer 80% Old 95% New'' then 0.8
when ECPLAN_DESC = ''Tradewaste - 1/7/14 to 30/6/15 (Moderate User Plan) Sewer 80% Old 95% New (Vol. Charges only)'' then 0.8
when ECPLAN_DESC = ''Tradewaste - 1/7/14 to 30/6/15 (Moderate User Plan) Sewer 100% Old 95% New + No Discharge Charge'' then 1
when ECPLAN_DESC = ''Tradewaste - 1/7/14 to 30/6/15 (Moderate User Plan) Sewer 100% Old 95% New + No Fixed Charge''''s'' then 1
when ECPLAN_DESC = ''Tradewaste - 1/7/14 to 30/6/16 (Water Only)'' then 0
when ECPLAN_DESC = ''Tradewaste(1)Stage2- 1/7/15 to 30/6/16(High User Plan)Sewer 80% Old 95% New+I/C $500(1/3rd)per year'' then 0.8
when ECPLAN_DESC = ''Tradewaste (1) Stage 2 - 1/7/15 to 30/6/16 (High User Plan) Sewer 100% Old 95% New'' then 1
when ECPLAN_DESC = ''Tradewaste (1) Stage 2- 1/7/15 to 30/6/16 (Low User Plan) Sewer 95% New, No Old Sewer Charges'' then 0.95
when ECPLAN_DESC = ''Tradewaste (1) Stage 2 - 1/7/15 to 30/6/16 (Low User Plan) Sewer 100% Old 95% New'' then 1
when ECPLAN_DESC = ''Tradewaste (1) Stage 2 - 1/7/15 to 30/6/16 (Mod. User Plan) Sewer 4% Old 95% New + Discharge Charge'' then 0.04
when ECPLAN_DESC = ''Tradewaste (1) Stage 2 - 1/7/15 to 30/6/16 (Moderate User Plan) Sewer 4% Old 5% New + Fixed Charges'' then 0.04
when ECPLAN_DESC = ''Tradewaste (1) Stage 2- 1/7/15 to 30/6/16(Moderate User Plan)Sewer Vol. 5% + Fixed/Discharge Charges'' then 0.05
when ECPLAN_DESC = ''Tradewaste(1)Stage 2 - 1/7/15 to 30/6/16 (Mod.User Plan)Sewer 80% Old/New + I/C $500(1/3rd) per year'' then 0.8
when ECPLAN_DESC = ''Tradewaste (1) Stage 2- 1/7/15 to 30/6/16 (Mod.User Plan) Sewer 80% Old 95% New'' then 0.8
when ECPLAN_DESC = ''Tradewaste (1) Stage 2 - 1/7/15 to 30/6/16 (Moderate User Plan) Sewer 95% New, No Old Sewer Charges'' then 0.95
when ECPLAN_DESC = ''Tradewaste (1) Stage 2 - 1/7/15 to 30/6/16 (Moderate User Plan) Sewer 100% Old 95% New'' then 1
when ECPLAN_DESC = ''Tradewaste (3) Stage 2 - 1/7/15 to 30/6/16 (Pryors Ltd - High User Plan) Sewer 100% Old 95% New'' then 1
when ECPLAN_DESC = ''Tradewaste(6)Stage 2-1/7/15 to 30/6/16(Industry Plan)Sewer 100% Old 95% New+Discharge Charge(No I/C)'' then 1
when ECPLAN_DESC = ''Tradewaste Stage 2 - 1/7/15 to 30/6/16 (High User Plan) Sewer 80% Old 95% New (Vol. charges only)'' then 0.8
when ECPLAN_DESC = ''Tradewaste Stage 2 - 1/7/15 to 30/6/16 (High User Plan) Sewer 100% Old 95% New + No Fixed Charge''''s'' then 1
when ECPLAN_DESC = ''Tradewaste Stage 2 - 1/7/15 to 30/6/16(Industry Plan)Sewer 100% Old 95% New(Vol.+Fixed Charges+I/C)'' then 1
when ECPLAN_DESC = ''Tradewaste Stage 2 - 1/7/15 to 30/6/16 (Industry Plan) Sewer 100% Old 95% New (Vol. Charges Only)'' then 1
when ECPLAN_DESC = ''Tradewaste Stage 2 - 1/7/15 to 30/6/16 (Low User Plan) Sewer 100% Old 95% New (Vol. Charges Only)'' then 1
when ECPLAN_DESC = ''Tradewaste Stage 2 - 1/7/15 to 30/6/16 (Low User Plan) Sewer 100% Old 95% New + No Discharge Charge'' then 1
when ECPLAN_DESC = ''Tradewaste Stage 2 - 1/7/15 to 30/6/16 (Moderate User Plan) Sewer Vol. 5% + No Fixed Charges'' then 0.05
when ECPLAN_DESC = ''Tradewaste Stage 2 - 1/7/15 to 30/6/16(Moderate User Plan) Sewer 80% Old 95% New (Vol. Charges only)'' then 0.8
when ECPLAN_DESC = ''Tradewaste Stage 2 - 1/7/15 to 30/6/16 (Moderate User Plan) Sewer 80% Old 95% New'' then 0.8
when ECPLAN_DESC = ''Tradewaste Stage 2 - 1/7/15 to 30/6/16(Moderate User Plan)Sewer 100% Old 95% New (Vol. Charges Only)'' then 1
when ECPLAN_DESC = ''Tradewaste Stage 2 - 1/7/15 to 30/6/16(Moderate User Plan)Sewer 100% Old 95% New+No Discharge Charge'' then 1
when ECPLAN_DESC = ''United Water Accounts (DO NOT USE)'' then 0
when ECPLAN_DESC = ''Veolia Water Accounts (DO NOT USE)'' then 0
when ECPLAN_DESC = ''Veolia Accounts - 1/7/14 to 30/6/25'' then 0
else 0
end as "sewer_percentage"


 from "papakura_20221223"."dbo"."EMS_CON_PLAN"
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."EMS_CON_PLAN_ADJ__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."EMS_CON_PLAN_ADJ__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."EMS_CON_PLAN_ADJ__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."EMS_CON_PLAN_ADJ__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_EMS_CON_PLAN_ADJ__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_EMS_CON_PLAN_ADJ__dbt_tmp')
    )
  DROP index "dbo_mig"."EMS_CON_PLAN_ADJ__dbt_tmp".dbo_mig_EMS_CON_PLAN_ADJ__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_EMS_CON_PLAN_ADJ__dbt_tmp_cci
    ON "dbo_mig"."EMS_CON_PLAN_ADJ__dbt_tmp"

   

