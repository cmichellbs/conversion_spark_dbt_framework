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
FROM {{source('papakura','LOCADDRESS')}} L
LEFT JOIN {{source('papakura','loc_best_match')}} LBM ON LBM.SEQNO = L.SEQNO
left JOIN {{source('papakura','nz_full_address')}} NFA ON NFA.full_road_name = LBM.LOC_BEST_MATCH3