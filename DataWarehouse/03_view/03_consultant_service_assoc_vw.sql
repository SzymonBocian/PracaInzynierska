create or replace view snap.consultant_service_assoc_vw as
SELECT cd.consultant_key,
       cd.consultant_business_key,
       cd.consultant_first_name,
       cd.consultant_second_name,
       cd.consultant_last_name,
       cd.manager_key,
       sd.service_key,
       sd.service_business_key,
       sd.service_full_name_eng,
       sd.service_full_name_pl,
       sd.service_short_name_eng,
       sd.service_short_name_pl,
       sd.service_code
FROM ((pro.consultant_service_assoc csa
  JOIN pro.service_dim sd ON ((csa.service_key = sd.service_key)))
       JOIN pro.consultant_dim cd ON ((csa.consultant_key = cd.consultant_key)))
WHERE ((sd.active = true) AND (cd.active = true))
ORDER BY cd.consultant_key;
