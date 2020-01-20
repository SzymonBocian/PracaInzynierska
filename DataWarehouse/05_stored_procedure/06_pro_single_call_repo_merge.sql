create or replace function meta.pro_single_call_repo_merge() returns void
	language plpgsql
as $$
  ----------------------------------------------------------------------------------
-- Procedure    : pro_single_call_repo_merge                                      --
-- Author       : Szymon Bocian (szymon.bocian@student.wat.edu.pl)                --
-- Date         : 15-OCT-2019                                                     --
-- Purpose      : Loading data from stage to repo warehouse stage area            --
-- Version      : 1.0.0                                                           --
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
-- Change History                                                                 --
-- Date        Programmer        Description                                      --
-- ----------- ----------------- ------------------------------------------------ --
-- 15-OCT-2019 Szymon Bocian     Initial Version                                  --
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
-- Parameters                                                                     --
------------------------------------------------------------------------------------
-- No Name                    Description / Example                      Default  --
-- -- ----------------------- ------------------------------------------ -------- --
--                                                                                --
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
-- Glossary                                                                       --
-- start_join - after press call button by the client                             --
-- start_conv - after consultant grab the phone                                   --
-- end_conn   - after client put down phone                                       --
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
DECLARE

  l_step_num          INT  := 0;

BEGIN

----------------------------------------------------------------------------
-- STEP010 Load correct data to fact table                                --
----------------------------------------------------------------------------

  l_step_num := 10;

  WITH dt AS
  (
    SELECT date_key, date_value
    FROM tech.date_dim
  ),
  tm AS
  (
    SELECT time_key, time_value
    FROM tech.time_dim
  )
  INSERT INTO fact.single_call_fact
  (
    call_single_key,
    call_business_key,
    client_key,
    consultant_key,
    office_key,
    service_key,
    start_join_date_key,
    start_conv_date_key,
    end_conn_date_key,
    start_join_time_key,
    start_conv_time_key,
    end_conn_time_key,
    conn_time_in_sec,
    conn_time_in_min,
    call_duration_in_sec,
    call_duration_in_min,
    wait_time_in_sec,
    wait_time_in_min,
    period_num_15,
    period_num_30
  )
  SELECT
    NEXTVAL('fact.single_call_fact_call_single_key_seq'),
    CONCAT(LEFT(cl.client_key::VARCHAR,1),LEFT(co.consultant_key::VARCHAR,1),LEFT(ff.office_key::VARCHAR,1),LEFT(se.service_key::VARCHAR,1),RIGHT(sc.date_key::VARCHAR,2),RIGHT(tc.time_key::VARCHAR,2)),
    cl.client_key,
    co.consultant_key,
    ff.office_key,
    se.service_key,
    sj.date_key, sc.date_key, ec.date_key,
    tj.time_key, tc.time_key, tn.time_key,
    CASE
      WHEN sc.date_key = ec.date_key THEN tn.time_key - tc.time_key
      ELSE 235959 - tc.time_key + tn.time_key
    END AS conn_time_in_sec,
    CASE
      WHEN sc.date_key = ec.date_key THEN ( tn.time_key - tc.time_key ) / 60
      ELSE ( 235959 - tc.time_key + tn.time_key ) / 60
    END AS conn_time_in_min,
    CASE
      WHEN sj.date_key = ec.date_key THEN tn.time_key - tj.time_key
      ELSE 235959 - tj.time_key + tn.time_key
    END AS call_duration_in_sec,
    CASE
      WHEN sj.date_key = ec.date_key THEN ( tn.time_key - tj.time_key ) / 60
      ELSE ( 235959 - tj.time_key + tn.time_key ) / 60
    END AS call_duration_in_min,
    CASE
      WHEN sj.date_key = sc.date_key THEN tc.time_key - tj.time_key
      ELSE 235959 - tj.time_key + tc.time_key
    END AS wait_time_in_sec,
    CASE
      WHEN sj.date_key = sc.date_key THEN ( tc.time_key - tj.time_key ) / 60
      ELSE ( 235959 - tj.time_key + tc.time_key ) / 60
    END AS wait_time_in_min,
    CASE
      WHEN sj.date_key = sc.date_key THEN ( tc.time_key - tj.time_key ) / 15
      ELSE ( 235959 - tj.time_key + tc.time_key ) / 15
    END AS period_num_15,
    CASE
      WHEN sj.date_key = sc.date_key THEN ( tc.time_key - tj.time_key ) / 30
      ELSE ( 235959 - tj.time_key + tc.time_key ) / 30
    END AS period_num_30
  FROM stg.single_call_fact stg
  INNER JOIN pro.client_dim     cl ON stg.client_business_key     = cl.client_business_key
  INNER JOIN pro.consultant_dim co ON stg.consultant_business_key = co.consultant_business_key
  INNER JOIN pro.office_dim     ff ON stg.office_business_key     = ff.office_business_key
  INNER JOIN pro.service_dim    se ON stg.service_business_key    = se.service_business_key
  INNER JOIN dt                 sj ON TO_DATE(stg.start_join_date_key,'YYYY-MM-DD')      = sj.date_value
  INNER JOIN dt                 sc ON TO_DATE(stg.start_conv_date_key,'YYYY-MM-DD')      = sc.date_value
  INNER JOIN dt                 ec ON TO_DATE(stg.end_conn_date_key,'YYYY-MM-DD')        = ec.date_value
  INNER JOIN tm                 tj ON TO_TIMESTAMP(SUBSTRING(stg.start_join_time_key,7,9),'HH24:MI:SS')::TIME = tj.time_value
  INNER JOIN tm                 tc ON TO_TIMESTAMP(SUBSTRING(stg.start_conv_time_key,7,9),'HH24:MI:SS')::TIME = tc.time_value
  INNER JOIN tm                 tn ON TO_TIMESTAMP(SUBSTRING(stg.end_conn_time_key,7,9),'HH24:MI:SS')::TIME   = tn.time_value
WHERE cl.active is True AND co.active is True AND ff.active is True AND se.active is True;

  RAISE INFO 'STEP %: loading fact to single_call.', l_step_num;

----------------------------------------------------------------------------
-- STEP020 Load incorrect data to err_fact table                          --
----------------------------------------------------------------------------

  l_step_num := 20;

  WITH dt AS
  (
    SELECT date_key, date_value
    FROM tech.date_dim
  ),
  tm AS
  (
    SELECT time_key, time_value
    FROM tech.time_dim
  )
  INSERT INTO err.single_call_fact
  SELECT
    CASE
      WHEN cl.client_key      IS NULL THEN 'INCORRECT client_key'
      WHEN co.consultant_key  IS NULL THEN 'INCORRECT consultant_key'
      WHEN ff.office_key      IS NULL THEN 'INCORRECT office_key'
      WHEN se.service_key     IS NULL THEN 'INCORRECT service_key'
      WHEN sj.date_key        IS NULL THEN 'INCORRECT sj.date_key'
      WHEN sc.date_key        IS NULL THEN 'INCORRECT sc.date_key'
      WHEN ec.date_key        IS NULL THEN 'INCORRECT ec.date_key'
      WHEN tj.time_key        IS NULL THEN 'INCORRECT tj.time_key'
      WHEN tc.time_key        IS NULL THEN 'INCORRECT tc.time_key'
      WHEN tn.time_key        IS NULL THEN 'INCORRECT office_key'
      ELSE 'Other'
    END AS status,
    stg.*
  FROM stg.single_call_fact stg
  LEFT JOIN pro.client_dim     cl ON stg.client_business_key       = cl.client_business_key
  LEFT JOIN pro.consultant_dim co ON stg.consultant_business_key   = co.consultant_business_key
  LEFT JOIN pro.office_dim     ff ON stg.office_business_key       = ff.office_business_key
  LEFT JOIN pro.service_dim    se ON stg.service_business_key      = se.service_business_key
  LEFT JOIN dt                 sj ON TO_DATE(stg.start_join_date_key,'YYYY-MM-DD')       = sj.date_value
  LEFT JOIN dt                 sc ON TO_DATE(stg.start_conv_date_key,'YYYY-MM-DD')       = sc.date_value
  LEFT JOIN dt                 ec ON TO_DATE(stg.end_conn_date_key,'YYYY-MM-DD')         = ec.date_value
  LEFT JOIN tm                 tj ON TO_TIMESTAMP(SUBSTRING(stg.start_join_time_key,7,9),'HH24:MI:SS')::TIME = tj.time_value
  LEFT JOIN tm                 tc ON TO_TIMESTAMP(SUBSTRING(stg.start_conv_time_key,7,9),'HH24:MI:SS')::TIME = tc.time_value
  LEFT JOIN tm                 tn ON TO_TIMESTAMP(SUBSTRING(stg.end_conn_time_key,7,9),'HH24:MI:SS')::TIME   = tn.time_value
  WHERE cl.client_key     IS NULL
    OR co.consultant_key  IS NULL
    OR ff.office_key      IS NULL
    OR se.service_key     IS NULL
    OR sj.date_key        IS NULL
    OR sc.date_key        IS NULL
    OR ec.date_key        IS NULL
    OR tj.time_key        IS NULL
    OR tc.time_key        IS NULL
    OR tn.time_key        IS NULL
    OR (cl.active is False AND co.active is False AND ff.active is False AND se.active is False)
  ;

  RAISE INFO 'STEP %: loading incorrect fact to err_fact table.', l_step_num;

EXCEPTION
  WHEN OTHERS THEN RAISE NOTICE '%%%', SQLSTATE || ' - ' || SQLERRM;

END
$$;

alter function meta.pro_single_call_repo_merge() owner to szymonbocian;