create or replace function meta.pro_service_repo_merge() returns void
	language plpgsql
as $$
  ------------------------------------------------------------------------------------
-- Procedure    : pro_service_repo_merge                                           --
-- Author       : Szymon Bocian (szymon.bocian@student.wat.edu.pl)                --
-- Date         : 15-OCT-2019                                                     --
-- Purpose      : Loading data from stage to repo warehouse stage area            --
-- Version      : 1.0.0                                                           --
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
-- Change History                                                                 --
-- Date        Programmer        Description                                      --
-- ----------- ----------------- ------------------------------------------------ --
-- 11-OCT-2019 Szymon Bocian     Initial Version                                  --
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
-- Parameters                                                                     --
------------------------------------------------------------------------------------
-- No Name                    Description / Example                      Default  --
-- -- ----------------------- ------------------------------------------ -------- --
--                                                                                --
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
DECLARE

  l_step_num          INT  := 0;

BEGIN

----------------------------------------------------------------------------
-- STEP010 Transfer stage to temporary table                              --
----------------------------------------------------------------------------

  l_step_num := 10;

  DROP TABLE IF EXISTS tmp;
  CREATE TEMPORARY TABLE tmp AS
  SELECT stg.*
  FROM stg.service_dim AS stg;

  RAISE INFO 'STEP %: create temporary table.', l_step_num;

----------------------------------------------------------------------------
-- STEP020 Validate service_business_key variable                        --
----------------------------------------------------------------------------

  l_step_num := 20;

  INSERT INTO err.service_dim
  (
    status, service_business_key, service_full_name_eng, service_full_name_pl, service_short_name_eng, service_short_name_pl, service_code, service_short_code
  )
  SELECT
	'INCORRECT service_business_key', service_business_key, service_full_name_eng, service_full_name_pl, service_short_name_eng, service_short_name_pl, service_code, service_short_code
  FROM tmp
  WHERE service_business_key IS NULL OR LENGTH(service_business_key) <> 10;

  RAISE INFO 'STEP %: CORRECT service_business_key value.', l_step_num;

----------------------------------------------------------------------------
-- STEP030 Validate service_full_name_eng variable                        --
----------------------------------------------------------------------------

  l_step_num := 30;

  INSERT INTO err.service_dim
  (
    status, service_business_key, service_full_name_eng, service_full_name_pl, service_short_name_eng, service_short_name_pl, service_code, service_short_code
  )
  SELECT
	'INCORRECT service_full_name_eng', service_business_key, service_full_name_eng, service_full_name_pl, service_short_name_eng, service_short_name_pl, service_code, service_short_code
  FROM tmp
  WHERE service_full_name_eng IS NULL;

  RAISE INFO 'STEP %: CORRECT service_full_name_eng value.', l_step_num;

----------------------------------------------------------------------------
-- STEP040 Validate service_full_name_pl variable                         --
----------------------------------------------------------------------------

  l_step_num := 40;

  INSERT INTO err.service_dim
  (
    status, service_business_key, service_full_name_eng, service_full_name_pl, service_short_name_eng, service_short_name_pl, service_code, service_short_code
  )
  SELECT
	'INCORRECT service_full_name_eng', service_business_key, service_full_name_eng, service_full_name_pl, service_short_name_eng, service_short_name_pl, service_code, service_short_code
  FROM tmp
  WHERE service_full_name_pl IS NULL;

  RAISE INFO 'STEP %: CORRECT service_full_name_pl value.', l_step_num;

----------------------------------------------------------------------------
-- STEP050 Validate service_short_name_eng variable                       --
----------------------------------------------------------------------------

  l_step_num := 50;

  INSERT INTO err.service_dim
  (
    status, service_business_key, service_full_name_eng, service_full_name_pl, service_short_name_eng, service_short_name_pl, service_code, service_short_code
  )
  SELECT
	'INCORRECT service_full_name_eng', service_business_key, service_full_name_eng, service_full_name_pl, service_short_name_eng, service_short_name_pl, service_code, service_short_code
  FROM tmp
  WHERE service_short_name_eng IS NULL;

  RAISE INFO 'STEP %: CORRECT service_short_name_eng value.', l_step_num;

----------------------------------------------------------------------------
-- STEP060 Validate service_short_name_pl variable                       --
----------------------------------------------------------------------------

  l_step_num := 60;

  INSERT INTO err.service_dim
  (
    status, service_business_key, service_full_name_eng, service_full_name_pl, service_short_name_eng, service_short_name_pl, service_code, service_short_code
  )
  SELECT
	'INCORRECT service_short_name_pl', service_business_key, service_full_name_eng, service_full_name_pl, service_short_name_eng, service_short_name_pl, service_code, service_short_code
  FROM tmp
  WHERE service_short_name_pl IS NULL;

  RAISE INFO 'STEP %: CORRECT service_short_name_pl value.', l_step_num;

----------------------------------------------------------------------------
-- STEP070 Validate service_code variable                                 --
----------------------------------------------------------------------------

  l_step_num := 70;

  INSERT INTO err.service_dim
  (
    status, service_business_key, service_full_name_eng, service_full_name_pl, service_short_name_eng, service_short_name_pl, service_code, service_short_code
  )
  SELECT
	'INCORRECT service_code', service_business_key, service_full_name_eng, service_full_name_pl, service_short_name_eng, service_short_name_pl, service_code, service_short_code
  FROM tmp
  WHERE service_code IS NULL OR LENGTH(service_code) <> 16;

  RAISE INFO 'STEP %: CORRECT service_code value.', l_step_num;

----------------------------------------------------------------------------
-- STEP080 Validate service_short_code variable                           --
----------------------------------------------------------------------------

  l_step_num := 80;

--   INSERT INTO err.service_dim
--   (
--     status, service_business_key, service_full_name_eng, service_full_name_pl, service_short_name_eng, service_short_name_pl, service_code, service_short_code
--   )
--   SELECT
-- 	'INCORRECT service_short_code', service_business_key, service_full_name_eng, service_full_name_pl, service_short_name_eng, service_short_name_pl, service_code, service_short_code
--   FROM tmp
--   WHERE service_short_code IS NULL OR LENGTH(service_short_code) <> 2;
--
--   RAISE INFO 'STEP %: CORRECT service_short_code value.', l_step_num;

----------------------------------------------------------------------------
-- STEP090 Remove wrong rows from tmp table                               --
----------------------------------------------------------------------------

  l_step_num := 90;

  DELETE FROM tmp USING err.service_dim err
  WHERE tmp.service_business_key = err.service_business_key;

  RAISE INFO 'STEP %: Remove wrong rows from tmp table.', l_step_num;

----------------------------------------------------------------------------
-- STEP100 Update existing rows in pro.service_dim to deprecated           --
----------------------------------------------------------------------------

  l_step_num := 100;

  UPDATE pro.service_dim
  SET active = FALSE, eff_end_dt = current_date, eff_end_tm = current_time
  FROM tmp
  INNER JOIN pro.service_dim repo
    ON tmp.service_business_key = repo.service_business_key;

  RAISE INFO 'STEP %: Update existing rows in pro.service_dim to deprecated.', l_step_num;

----------------------------------------------------------------------------
-- STEP110 Insert correct rows to pro.service_dim                          --
----------------------------------------------------------------------------

  l_step_num := 110;

  INSERT INTO pro.service_dim
  (
    service_key,
    service_business_key,
    service_full_name_eng,
    service_full_name_pl,
    service_short_name_eng,
    service_short_name_pl,
    service_code,
    service_short_code
  )
  SELECT
    NEXTVAL('pro.service_dim_service_key_seq'),
    UPPER(service_business_key),
    INITCAP(service_full_name_eng),
    INITCAP(service_full_name_pl),
    UPPER(service_short_name_eng),
    UPPER(service_short_name_pl),
    UPPER(service_code),
    UPPER(service_short_code)
  FROM tmp;

  RAISE INFO 'STEP %: Insert correct rows to pro.service_dim.', l_step_num;

EXCEPTION
  WHEN OTHERS THEN RAISE NOTICE '%%%', SQLSTATE || ' - ' || SQLERRM;

END
$$;

alter function meta.pro_service_repo_merge() owner to szymonbocian;
