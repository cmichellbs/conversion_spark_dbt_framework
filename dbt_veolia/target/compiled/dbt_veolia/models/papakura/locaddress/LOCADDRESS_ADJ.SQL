SELECT L.*,
       LBM.LOC_BEST_MATCH3,
       NFA.full_road_name,
       NFA.road_name,
       NFA.road_name_type_value,
       NFA.road_name_type_abbrev,
       concat(NFA.road_name,' ',NFA.road_name_type_abbrev) road_name_label,
       NFA.full_road_name AS full_road_name2,
       NFA.suburb,
       NFA.town
FROM "papakura_20221223"."dbo"."LOCADDRESS" L
LEFT JOIN "papakura_20221223"."dbo"."loc_best_match" LBM ON LBM.SEQNO = L.SEQNO
left JOIN "papakura_20221223"."dbo"."nz_full_address" NFA ON NFA.full_road_name = LBM.LOC_BEST_MATCH3