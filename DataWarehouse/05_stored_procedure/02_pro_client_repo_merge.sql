create or replace function meta.pro_client_repo_merge() returns void
	language plpgsql
as $$
  ------------------------------------------------------------------------------------
-- Procedure    : pro_client_repo_merge                                           --
-- Author       : Szymon Bocian (szymon.bocian@student.wat.edu.pl)                --
-- Date         : 09-OCT-2019                                                     --
-- Purpose      : Loading data from stage to repo warehouse stage area            --
-- Version      : 1.0.0                                                           --
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
-- Change History                                                                 --
-- Date        Programmer        Description                                      --
-- ----------- ----------------- ------------------------------------------------ --
-- 09-OCT-2019 Szymon Bocian     Initial Version                                  --
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

  -- transfer stage to temp table
  DROP TABLE IF EXISTS tmp;
  CREATE TEMPORARY TABLE tmp AS
  SELECT stg.*
  FROM stg.client_dim AS stg;

  RAISE INFO 'STEP %: create temporary table.', l_step_num;

----------------------------------------------------------------------------
-- STEP020 Validate client_first_name variable                            --
----------------------------------------------------------------------------

  l_step_num := 20;

  INSERT INTO err.client_dim
  (
    status, client_first_name, client_second_name, client_last_name, sex_pl, sex_eng, sex_shortcut_pl, sex_shortcut_eng, client_age, client_business_key
  )
  SELECT
    'INCORRECT client_first_name value', client_first_name, client_second_name, client_last_name, sex_pl, sex_eng, sex_shortcut_pl, sex_shortcut_eng, client_age, client_business_key
  FROM tmp
  WHERE client_first_name IS NULL;

  RAISE INFO 'STEP %: CORRECT client_first_name value.', l_step_num;

----------------------------------------------------------------------------
-- STEP030 Validate client_second_name variable                            --
----------------------------------------------------------------------------

  l_step_num := 30;

  -- TO DO

  RAISE INFO 'STEP %: CORRECT client_second_name value.', l_step_num;

----------------------------------------------------------------------------
-- STEP040 Validate client_last_name variable                            --
----------------------------------------------------------------------------

  l_step_num := 40;

  INSERT INTO err.client_dim
  (
    status, client_first_name, client_second_name, client_last_name, sex_pl, sex_eng, sex_shortcut_pl, sex_shortcut_eng, client_age, client_business_key
  )
  SELECT
    'INCORRECT client_last_name value', client_first_name, client_second_name, client_last_name, sex_pl, sex_eng, sex_shortcut_pl, sex_shortcut_eng, client_age, client_business_key
  FROM tmp
  WHERE client_last_name IS NULL;

  RAISE INFO 'STEP %: CORRECT client_last_name value.', l_step_num;

----------------------------------------------------------------------------
-- STEP050 Validate sex_pl variable                                       --
----------------------------------------------------------------------------

  l_step_num := 50;

  INSERT INTO err.client_dim
  (
    status, client_first_name, client_second_name, client_last_name, sex_pl, sex_eng, sex_shortcut_pl, sex_shortcut_eng, client_age, client_business_key
  )
  SELECT
    'INCORRECT sex_pl value', client_first_name, client_second_name, client_last_name, sex_pl, sex_eng, sex_shortcut_pl, sex_shortcut_eng, client_age, client_business_key
  FROM tmp
  WHERE sex_pl IS NULL OR INITCAP(sex_pl) NOT IN ('Mężczyzna','Kobieta');

  RAISE INFO 'STEP %: CORRECT sex_pl value.', l_step_num;

----------------------------------------------------------------------------
-- STEP060 Validate sex_eng variable                                      --
----------------------------------------------------------------------------

  l_step_num := 60;

  INSERT INTO err.client_dim
  (
    status, client_first_name, client_second_name, client_last_name, sex_pl, sex_eng, sex_shortcut_pl, sex_shortcut_eng, client_age, client_business_key
  )
  SELECT
    'INCORRECT sex_eng value', client_first_name, client_second_name, client_last_name, sex_pl, sex_eng, sex_shortcut_pl, sex_shortcut_eng, client_age, client_business_key
  FROM tmp
  WHERE sex_eng IS NULL OR INITCAP(sex_eng) NOT IN ('Male','Female');

  RAISE INFO 'STEP %: CORRECT sex_eng value.', l_step_num;

----------------------------------------------------------------------------
-- STEP070 Validate sex_shortcut_pl variable                              --
----------------------------------------------------------------------------

  l_step_num := 70;

  INSERT INTO err.client_dim
  (
    status, client_first_name, client_second_name, client_last_name, sex_pl, sex_eng, sex_shortcut_pl, sex_shortcut_eng, client_age, client_business_key
  )
  SELECT
    'INCORRECT sex_shortcut_pl value', client_first_name, client_second_name, client_last_name, sex_pl, sex_eng, sex_shortcut_pl, sex_shortcut_eng, client_age, client_business_key
  FROM tmp
  WHERE sex_shortcut_pl IS NULL OR UPPER(sex_shortcut_pl) NOT IN ('M','K');

  RAISE INFO 'STEP %: CORRECT sex_shortcut_pl value.', l_step_num;

----------------------------------------------------------------------------
-- STEP080 Validate sex_shortcut_eng variable                             --
----------------------------------------------------------------------------

  l_step_num := 80;

  INSERT INTO err.client_dim
  (
    status, client_first_name, client_second_name, client_last_name, sex_pl, sex_eng, sex_shortcut_pl, sex_shortcut_eng, client_age, client_business_key
  )
  SELECT
    'INCORRECT sex_shortcut_eng value', client_first_name, client_second_name, client_last_name, sex_pl, sex_eng, sex_shortcut_pl, sex_shortcut_eng, client_age, client_business_key
  FROM tmp
  WHERE sex_shortcut_eng IS NULL OR UPPER(sex_shortcut_eng) NOT IN ('M','F');

  RAISE INFO 'STEP %: CORRECT sex_shortcut_eng value.', l_step_num;

----------------------------------------------------------------------------
-- STEP090 Validate client_age variable                                   --
----------------------------------------------------------------------------

  l_step_num := 90;

  INSERT INTO err.client_dim
  (
    status, client_first_name, client_second_name, client_last_name, sex_pl, sex_eng, sex_shortcut_pl, sex_shortcut_eng, client_age, client_business_key
  )
  SELECT
    'Wrong client_age value', client_first_name, client_second_name, client_last_name, sex_pl, sex_eng, sex_shortcut_pl, sex_shortcut_eng, client_age, client_business_key
  FROM tmp
  WHERE client_age IS NULL OR CAST(client_age AS INT) < 1;

  RAISE INFO 'STEP %: CORRECT client_age value.', l_step_num;

----------------------------------------------------------------------------
-- STEP100 Validate client_business_key variable                          --
----------------------------------------------------------------------------

  l_step_num := 100;

  INSERT INTO err.client_dim
  (
    status, client_first_name, client_second_name, client_last_name, sex_pl, sex_eng, sex_shortcut_pl, sex_shortcut_eng, client_age, client_business_key
  )
  SELECT
    'Wrong client_business_key format', client_first_name, client_second_name, client_last_name, sex_pl, sex_eng, sex_shortcut_pl, sex_shortcut_eng, client_age, client_business_key
  FROM tmp
  WHERE client_business_key IS NULL OR LENGTH(client_business_key) <> 12;

  RAISE INFO 'STEP %: CORRECT client_business_key value.', l_step_num;

----------------------------------------------------------------------------
-- STEP110 Remove wrong rows from tmp table                               --
----------------------------------------------------------------------------

  l_step_num := 110;

  DELETE FROM tmp USING err.client_dim err
  WHERE tmp.client_business_key = err.client_business_key;

  RAISE INFO 'STEP %: Remove wrong rows from tmp table.', l_step_num;

----------------------------------------------------------------------------
-- STEP120 Update existing rows in pro.client_dim to deprecated           --
----------------------------------------------------------------------------

  l_step_num := 120;

  UPDATE pro.client_dim
  SET active = FALSE, eff_end_dt = current_date, eff_end_tm = current_time
  FROM tmp
  INNER JOIN pro.client_dim repo
    ON tmp.client_business_key = repo.client_business_key;

  RAISE INFO 'STEP %: Update existing rows in pro.client_dim to deprecated.', l_step_num;

----------------------------------------------------------------------------
-- STEP130 Insert correct rows to pro.client_dim                          --
----------------------------------------------------------------------------

  l_step_num := 130;

  INSERT INTO pro.client_dim
  (
    client_key,
    client_business_key,
    client_first_name,
    client_second_name,
    client_last_name,
    sex_pl,
    sex_eng,
    sex_shortcut_pl,
    sex_shortcut_eng,
    client_age
  )
  SELECT
    NEXTVAL('pro.client_dim_client_key_seq'),
    UPPER(client_business_key),
    INITCAP(client_first_name),
    COALESCE(INITCAP(client_second_name),'None'),
    INITCAP(client_last_name),
    INITCAP(sex_pl),
    INITCAP(sex_eng),
    UPPER(sex_shortcut_pl),
    UPPER(sex_shortcut_eng),
    CAST(client_age AS INT)
  FROM tmp;

  RAISE INFO 'STEP %: Insert correct rows to pro.client_dim.', l_step_num;

EXCEPTION
  WHEN OTHERS THEN RAISE NOTICE '%%%', SQLSTATE || ' - ' || SQLERRM;

END
$$;

alter function meta.pro_client_repo_merge() owner to szymonbocian;
