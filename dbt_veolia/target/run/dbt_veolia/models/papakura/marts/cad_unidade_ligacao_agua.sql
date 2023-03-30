
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."cad_unidade_ligacao_agua__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."cad_unidade_ligacao_agua__dbt_tmp_temp_view"
      end


   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."cad_unidade_ligacao_agua__dbt_tmp"','U') is not null
      begin
      drop table "dbo_mig"."cad_unidade_ligacao_agua__dbt_tmp"
      end


   USE [papakura_20221223];
   EXEC('create view "dbo_mig"."cad_unidade_ligacao_agua__dbt_tmp_temp_view" as
    WITH BASE_REG AS (select g.*from GBBILLREG g
where GBB$STATUS <> 99)

,INTERM AS (SELECT *, ROW_NUMBER() OVER(PARTITION BY GBB$INSTALL ORDER BY GBB$REGKEY DESC) RN FROM BASE_REG )

,FIN AS (SELECT * FROM INTERM WHERE RN=1)

, HIDROMETRO AS (SELECT * FROM "papakura_20221223"."dbo_mig"."cad_hidrometro" WHERE ID_UNIDADE_INSTALACAO IS NOT NULL) 

,CONTRACTS_INTERM AS ( SELECT ECC.*, ROW_NUMBER() OVER(PARTITION BY ECC.CCON_CONSUMER ORDER BY ECC.CCON_SEQ DESC) RNC FROM EMS_CON_CONTRACT ECC)

,CONTRACTS AS ( SELECT * FROM CONTRACTS_INTERM WHERE RNC = 1)

,CONSUMER_INTERM AS (SELECT C.CONSUMERNO,C.CINSTALL, ROW_NUMBER() OVER(PARTITION BY C.CINSTALL ORDER BY C.CONSUMERNO DESC) RNCONS FROM CONSUMER C)


,CONSUMER_FINAL AS (SELECT * FROM CONSUMER_INTERM C 
WHERE RNCONS = 1)

,BASE AS (SELECT C.CINSTALL, CONTRACTS.*  FROM CONSUMER_FINAL C
LEFT JOIN CONTRACTS ON CONTRACTS.CCON_CONSUMER = C.CONSUMERNO)

,VALIDO AS (SELECT * FROM BASE WHERE CCON_PLANID1 NOT IN (''UWA'',''VWA01'',''RESSV100WV0'',''ICSV100ICWV0'',''IC-HIGHUSER-SEW'',''VWA'',''ICWSU0WSE0'',''RESST100SS100'',''RESST80SS80'',''ICWSU0WSE0IC0'',''DF02'',''DF03'',''RESSV80WV0'',''SEWERONLY'',''DF01''))


,final2 as (SELECT
ROW_NUMBER() OVER(ORDER BY INSTALL.INSTALL) as ID_UNIDADE_LIGACAO_AGUA,
coalesce(cast(coalesce(cast(INSTALL.IINST_STATUSDATE as date), cast(INSTALL.IINST_STATUSDATE as date)) as varchar),cast(getdate() as varchar)) as DT_LIGACAO_AGUA,
cast(cast(INSTALL.IINST_STATUSDATE as date) as varchar) as DT_SITUACAO_LIGACAO_AGUA,
INSTALL.INSTALL as NR_LIGACAO,
cast(cast(CASE 
    WHEN INSTALL.IINST_STATUS = ''DI'' THEN INSTALL.IINST_STATUSDATE 
    ELSE NULL 
END as date) as varchar) as DT_PRIMEIRO_CORTE,
NULL as NR_LACRE_MONTANTE_CAVALETE,
''N'' as FL_POSSUI_LACRE_CAVALETE,
NULL as NR_LACRE_AJUZANTE_CAVALETE,
NULL as NR_LATITUDE_CAVALETE,
NULL as NR_LONGITUDE_CAVALETE,
coalesce(NULL, cast(0 as BIT)) as FL_POSSUI_CAIXA_PADRAO,
RSEQ.RSD$KEYLOC as DS_OBSERVACAO,
NULL as NR_EXTENSAO_RAMAL,
NULL as VL_PRESSAO_AGUA,
NULL as VL_PROFUNDIDADE_RAMAL_AGUA,
0.0 as VL_TAMANHO_RAMAL_AGUA,
cast(1 as BIT)  as FL_POSSUI_CAVALETE,
null as CH_DIAMETRO_CAVALETE,
1 as CH_TIPO_INSTALACAO,
1 as CH_TIPO_CAVALETE,
1 as CH_TIPO_INSTALACAO_CAVALETE,
1 as CH_SITUACAO_CAVALETE,
1 as CH_DIAMETRO_RAMAL_LIGACAO_AGUA,
1 as CH_MATERIAL_CAVALETE,
case 
when INSTALL.IINST_STATUS = ''DI'' then 2
else 1 
end as CH_MOTIVO_SITUACAO_LIGACAO_AGUA,
1 as CH_PROTECAO_CAVALETE,
1 as CH_POSICAO_RAMAL_LIGACAO_AGUA,
cast(COALESCE(HIDROMETRO.ID_HIDROMETRO,CH.ID_HIDROMETRO) as varchar) as ID_HIDROMETRO,
case 
when INSTALL.IINST_STATUS = ''DI'' then 0
else 1 
end as CH_ATIVO,
TPC.CH_POSICAO_CAVALETE as CH_POSICAO_CAVALETE,
NULL as CH_DADOS_COMPLEMENTAR_LIGACAO_INDUSTRIAL,
case 
when INSTALL.IINST_STATUS = ''DI'' then 2
else 1 
end  as CH_SITUACAO_LIGACAO_AGUA,
cast(INSTALL.INSTALL as varchar) as CH_MATRICULA_UNIDADE,
1 as CH_DERIVACAO_RAMAL_LIGACAO_AGUA,
1 as CH_MATERIAL_RAMAL_LIGACAO_AGUA,
NULL as ID_REDE_AGUA_TRECHO,
NULL as ID_ORIGEM_AGUA_ESGOTO,
NULL as VL_GEOMETRIA_CAVALETE,
NULL as ID_LACRE_MONTANTE_CAVALETE,
NULL as ID_LACRE_JUSANTE_CAVALETE,
22220001 as CH_ORIGEM_INFORMACAO_ESPACIAL,
null as ID_HISTORICO_SITUACAO_LIGACAO_AGUA_ATUAL,
NULL as ID_ZONA_PRESSAO,
null as NR_LACRE_CAIXA_PADRAO,
null as QT_DISTANCIA_DIVISA,
null as NU_PROCESSO_EMPRESA,
INSTALL.INSTALL  AS MIG_PK_TEMP
FROM

"papakura_20221223"."dbo"."INSTALL" INSTALL
inner join "papakura_20221223"."dbo_mig"."cad_unidade_comercial" uc on uc.CH_MATRICULA_UNIDADE = INSTALL.INSTALL
-- INNER JOIN VALIDO ON VALIDO.CINSTALL = uc.CH_MATRICULA_UNIDADE
left JOIN  HIDROMETRO ON INSTALL.INSTALL = HIDROMETRO.ID_UNIDADE_INSTALACAO
left join "papakura_20221223"."dbo"."GBREADSEQ" RSEQ ON RSEQ.RSD$INSTALL = INSTALL.INSTALL
LEFT JOIN "papakura_20221223"."dbo_mig"."tab_posicao_cavalete" TPC ON TPC.position = RSEQ.RSD$LOC
LEFT JOIN FIN ON FIN.GBB$INSTALL = INSTALL.INSTALL
LEFT JOIN "papakura_20221223"."dbo_mig"."cad_hidrometro" CH on FIN.GBB$METERSERIAL = CH.MIG_PK_TEMP

-- WHERE  INSTALL.INSTALL NOT in (11015932,11015928,11015929,11015933,11015931,11015930)

)

,final as(select final2.*, row_number() over(partition by NR_LIGACAO order by DT_LIGACAO_AGUA asc) as rn from final2 
-- where ID_HIDROMETRO is not null
)

select * from final --where rn = 1
    ');

   SELECT * INTO "papakura_20221223"."dbo_mig"."cad_unidade_ligacao_agua__dbt_tmp" FROM
    "papakura_20221223"."dbo_mig"."cad_unidade_ligacao_agua__dbt_tmp_temp_view"

   
   
  USE [papakura_20221223];
  if object_id ('"dbo_mig"."cad_unidade_ligacao_agua__dbt_tmp_temp_view"','V') is not null
      begin
      drop view "dbo_mig"."cad_unidade_ligacao_agua__dbt_tmp_temp_view"
      end


   use [papakura_20221223];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'dbo_mig_cad_unidade_ligacao_agua__dbt_tmp_cci'
        AND object_id=object_id('dbo_mig_cad_unidade_ligacao_agua__dbt_tmp')
    )
  DROP index "dbo_mig"."cad_unidade_ligacao_agua__dbt_tmp".dbo_mig_cad_unidade_ligacao_agua__dbt_tmp_cci
  CREATE CLUSTERED COLUMNSTORE INDEX dbo_mig_cad_unidade_ligacao_agua__dbt_tmp_cci
    ON "dbo_mig"."cad_unidade_ligacao_agua__dbt_tmp"

   
