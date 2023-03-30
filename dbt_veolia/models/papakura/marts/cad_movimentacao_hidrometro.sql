
{{config({
        "materialized": 'table',
        "post-hook": ["{{ create_nonclustered_index(columns = ['ID_MOVIMENTACAO_HIDROMETRO',], ) }}", ]})}}

WITH GB AS (SELECT GB.*, row_number() over(order by GB.GBB$REGKEY) AS SERIALNUM FROM {{source('papakura','GBBILLREG')}} AS GB )







SELECT
SERIALNUM as ID_MOVIMENTACAO_HIDROMETRO,
GB.GBB$INSTALLREAD as NU_LEITURA_INSTALACAO,
cast(CASE WHEN DATEPART(HOUR,GB.GBB$INSTALLDATE ) = 23 THEN  DATEADD(HOUR,1,GB.GBB$INSTALLDATE ) 
     WHEN DATEPART(HOUR,GB.GBB$INSTALLDATE ) = 12 THEN  DATEADD(HOUR,12,GB.GBB$INSTALLDATE )
          WHEN DATEPART(HOUR,GB.GBB$INSTALLDATE ) = 13 THEN  DATEADD(HOUR,11,GB.GBB$INSTALLDATE )

     WHEN DATEPART(HOUR,GB.GBB$INSTALLDATE ) = 11 THEN  DATEADD(HOUR,13,GB.GBB$INSTALLDATE )
ELSE GB.GBB$INSTALLDATE  END as DATE) as DT_INSTALACAO_HIDROMETRO,
cast(coalesce(CASE WHEN DATEPART(HOUR,GB.GBB$RMVDATE ) = 23 THEN  DATEADD(HOUR,1,GB.GBB$RMVDATE ) 
     WHEN DATEPART(HOUR,GB.GBB$RMVDATE ) = 12 THEN  DATEADD(HOUR,12,GB.GBB$RMVDATE )
          WHEN DATEPART(HOUR,GB.GBB$RMVDATE ) = 13 THEN  DATEADD(HOUR,11,GB.GBB$RMVDATE )

     WHEN DATEPART(HOUR,GB.GBB$RMVDATE ) = 11 THEN  DATEADD(HOUR,13,GB.GBB$RMVDATE )
ELSE GB.GBB$RMVDATE  END,CASE WHEN DATEPART(HOUR,GB.GBB$DISCONNECTED ) = 23 THEN  DATEADD(HOUR,1,GB.GBB$DISCONNECTED ) 
     WHEN DATEPART(HOUR,GB.GBB$DISCONNECTED ) = 12 THEN  DATEADD(HOUR,12,GB.GBB$DISCONNECTED )
          WHEN DATEPART(HOUR,GB.GBB$DISCONNECTED ) = 13 THEN  DATEADD(HOUR,11,GB.GBB$DISCONNECTED )

     WHEN DATEPART(HOUR,GB.GBB$DISCONNECTED ) = 11 THEN  DATEADD(HOUR,13,GB.GBB$DISCONNECTED )
ELSE GB.GBB$DISCONNECTED  END) as DATE) as DT_RETIRADA_HIDROMETRO,
GB.GBB$RMVREAD as NU_LEITURA_RETIRADA,
null as FL_LACRE,
null as DS_OBSERVACAO,
coalesce(hidrometro.ID_HIDROMETRO, 1) as ID_HIDROMETRO,
CASE 
WHEN GBB$STATUS = -1 THEN 7
WHEN GBB$STATUS = 0 THEN 4 
WHEN GBB$STATUS = 1 THEN 3
WHEN GBB$STATUS = 5 THEN 1
WHEN GBB$STATUS = 7 THEN 2
WHEN GBB$STATUS = 10 THEN 1
WHEN GBB$STATUS = 99 THEN 8
END as CH_MOTIVO_MOVIMENTO_HIDROMETRO,
cula.ID_UNIDADE_LIGACAO_AGUA as ID_UNIDADE_LIGACAO_AGUA,
null as ID_UNIDADE_LIGACAO_PARTICULAR,
null as ID_SERVICO_INSTALACAO,
null as ID_SERVICO_REMOCAO
FROM  GB 
left join {{ref('cad_unidade_ligacao_agua')}} cula on cula.NR_LIGACAO = GB.GBB$INSTALL
left JOIN {{ref('cad_hidrometro')}} HIDROMETRO ON GB.GBB$METERSERIAL = HIDROMETRO.NU_HIDROMETRO
