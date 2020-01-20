create or replace view snap.consultant_skills_vw as
WITH map AS (
    SELECT cd.consultant_business_key,
           sd.service_key,
           cd.consultant_key,
           CASE
             WHEN (csa.consultant_key IS NULL) THEN 0
             ELSE 1
             END AS skill
    FROM ((pro.service_dim sd
      FULL JOIN pro.consultant_dim cd ON ((1 = 1)))
           LEFT JOIN pro.consultant_service_assoc csa
                     ON (((sd.service_key = csa.service_key) AND (cd.consultant_key = csa.consultant_key))))
    WHERE (sd.active IS TRUE)
  )
  SELECT map.consultant_business_key,
         map.consultant_key,
         sum(
             CASE
               WHEN ((map.service_key = 2) AND (map.skill = 1)) THEN 1
               ELSE 0
               END)     AS billing,
         sum(
             CASE
               WHEN ((map.service_key = 3) AND (map.skill = 1)) THEN 1
               ELSE 0
               END)     AS reclamation,
         sum(
             CASE
               WHEN ((map.service_key = 4) AND (map.skill = 1)) THEN 1
               ELSE 0
               END)     AS delivery,
         sum(
             CASE
               WHEN ((map.service_key = 5) AND (map.skill = 1)) THEN 1
               ELSE 0
               END)     AS reservation,
         sum(
             CASE
               WHEN ((map.service_key = 6) AND (map.skill = 1)) THEN 1
               ELSE 0
               END)     AS complaint,
         sum(
             CASE
               WHEN ((map.service_key = 7) AND (map.skill = 1)) THEN 1
               ELSE 0
               END)     AS order_handle,
         sum(
             CASE
               WHEN ((map.service_key = 8) AND (map.skill = 1)) THEN 1
               ELSE 0
               END)     AS reset_account_settings,
         sum(
             CASE
               WHEN ((map.service_key = 9) AND (map.skill = 1)) THEN 1
               ELSE 0
               END)     AS reset_password,
         sum(
             CASE
               WHEN ((map.service_key = 10) AND (map.skill = 1)) THEN 1
               ELSE 0
               END)     AS contract_extension,
         sum(
             CASE
               WHEN ((map.service_key = 11) AND (map.skill = 1)) THEN 1
               ELSE 0
               END)     AS tariff_change,
         sum(map.skill) AS all_skills
  FROM map
  GROUP BY map.consultant_key, map.consultant_business_key
  ORDER BY (sum(map.skill));
