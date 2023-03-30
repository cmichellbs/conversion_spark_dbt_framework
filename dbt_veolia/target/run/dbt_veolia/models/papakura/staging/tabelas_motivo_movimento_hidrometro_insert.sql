
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."tabelas_motivo_movimento_hidrometro_insert__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."tabelas_motivo_movimento_hidrometro_insert__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."tabelas_motivo_movimento_hidrometro_insert__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."tabelas_motivo_movimento_hidrometro_insert__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."tabelas_motivo_movimento_hidrometro_insert__dbt_tmp_temp_view" as
    SELECT
row_number() over(ORDER BY MR.PKEY) + 10 as CH_MOTIVO_MOVIMENTO_HIDROMETRO,
PDESC as NM_MOTIVO_MOVIMENTO_HIDROMETRO,
1 as CH_ATIVO,
CASE 
    WHEN MR.PKEY = ''BACKW'' THEN 1
    WHEN MR.PKEY = ''BAD'' THEN 3
    WHEN MR.PKEY = ''CANT'' THEN 4
    WHEN MR.PKEY = ''CRACKHEAD'' THEN 3
    WHEN MR.PKEY = ''DAMAGED'' THEN 3
    WHEN MR.PKEY = ''DATA'' THEN 3
    WHEN MR.PKEY = ''HARD'' THEN 3
    WHEN MR.PKEY = ''INC'' THEN 1
    WHEN MR.PKEY = ''LEAK'' THEN 1
    WHEN MR.PKEY = ''MAINT'' THEN 3
    WHEN MR.PKEY = ''MAINT.OPS'' THEN 3
    WHEN MR.PKEY = ''MET'' THEN 3
    WHEN MR.PKEY = ''OLD'' THEN 4
    WHEN MR.PKEY = ''PERMREMOVAL'' THEN 4
    WHEN MR.PKEY = ''REPPRGM'' THEN 3
    WHEN MR.PKEY = ''STOL'' THEN 6
    WHEN MR.PKEY = ''STOP'' THEN 3
    WHEN MR.PKEY = ''TEST'' THEN 3
    WHEN MR.PKEY = ''UNREAD'' THEN 3
    WHEN MR.PKEY = ''WRONG''   THEN 3
    ELSE 3
END as CH_SITUACAO_HIDROMETRO,
2 as CH_TIPO_MOVIMENTACAO_HIDROMETRO FROM

"papakura_20221223"."dbo"."METER_REMOVE" MR
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."tabelas_motivo_movimento_hidrometro_insert__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."tabelas_motivo_movimento_hidrometro_insert__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."tabelas_motivo_movimento_hidrometro_insert__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."tabelas_motivo_movimento_hidrometro_insert__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_tabelas_motivo_movimento_hidrometro_insert__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_tabelas_motivo_movimento_hidrometro_insert__dbt_tmp')
    )
  DROP index "dbo_mig"."tabelas_motivo_movimento_hidrometro_insert__dbt_tmp".dbo_mig_tabelas_motivo_movimento_hidrometro_insert__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_tabelas_motivo_movimento_hidrometro_insert__dbt_tmp_cci
    ON "dbo_mig"."tabelas_motivo_movimento_hidrometro_insert__dbt_tmp"

   

