create or replace view snap.service_date_hour_vw as
SELECT sd.service_short_name_eng                                                                                     AS service_name,
       scf.service_key,
       dd.date_value,
       scf.start_join_date_key                                                                                       AS date_key,
       td.hour_value                                                                                                 AS hour_key,
       concat(lpad((td.hour_value)::text, 2, '0'::text), ':00')                                                      AS start_hour,
       concat(lpad((td.hour_value)::text, 2, '0'::text), ':59')                                                      AS end_hour,
       concat(lpad((td.hour_value)::text, 2, '0'::text), ':00 - ', lpad((td.hour_value)::text, 2, '0'::text),
              ':59')                                                                                                 AS period_hour,
       (avg(scf.wait_time_in_sec))::integer                                                                          AS avg_handle_time_sec,
       (avg(scf.wait_time_in_min))::integer                                                                          AS avg_handle_time_min,
       count(*)                                                                                                      AS total_call
FROM (((fact.single_call_fact scf
  JOIN pro.service_dim sd ON ((scf.service_key = sd.service_key)))
  JOIN tech.date_dim dd ON ((scf.start_join_date_key = dd.date_key)))
       JOIN tech.time_dim td ON ((scf.start_join_time_key = td.time_key)))
WHERE (sd.active IS TRUE)
GROUP BY sd.service_short_name_eng, scf.service_key, dd.date_value, scf.start_join_date_key, td.hour_value
ORDER BY scf.start_join_date_key, td.hour_value, scf.service_key;