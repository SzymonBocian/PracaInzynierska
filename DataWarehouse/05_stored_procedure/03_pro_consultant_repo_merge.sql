create or replace function meta.pro_consultant_repo_merge() returns void
	language plpgsql
as $$
------------------------------------------------------------------------------------
-- Procedure    : pro_consultant_repo_merge                                       --
-- Author       : Szymon Bocian (szymon.bocian@student.wat.edu.pl)                --
-- Date         : 11-OCT-2019                                                     --
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
  FROM stg.consultant_dim AS stg;

  RAISE INFO 'STEP %: create temporary table.', l_step_num;

----------------------------------------------------------------------------
-- STEP020 Validate consultant_first_name variable                        --
----------------------------------------------------------------------------

  l_step_num := 20;

  INSERT INTO err.consultant_dim
  (
    status, consultant_first_name, consultant_second_name, consultant_last_name, manager_key
  )
  SELECT
    'INCORRECT consultant_first_name value', consultant_first_name, consultant_second_name, consultant_last_name, manager_key
  FROM tmp
  WHERE consultant_first_name IS NULL;

  RAISE INFO 'STEP %: CORRECT consultant_first_name value.', l_step_num;

----------------------------------------------------------------------------
-- STEP030 Validate consultant_second_name variable                       --
----------------------------------------------------------------------------

  l_step_num := 30;

  -- TO DO

  RAISE INFO 'STEP %: CORRECT consultant_second_name value.', l_step_num;

----------------------------------------------------------------------------
-- STEP040 Validate consultant_last_name variable                         --
----------------------------------------------------------------------------

  l_step_num := 40;

  INSERT INTO err.consultant_dim
  (
    status, consultant_first_name, consultant_second_name, consultant_last_name, manager_key
  )
  SELECT
    'INCORRECT consultant_last_name value', consultant_first_name, consultant_second_name, consultant_last_name, manager_key
  FROM tmp
  WHERE consultant_last_name IS NULL;

  RAISE INFO 'STEP %: CORRECT consultant_last_name value.', l_step_num;

----------------------------------------------------------------------------
-- STEP050 Validate consultant_last_name variable                         --
----------------------------------------------------------------------------

  l_step_num := 50;

  INSERT INTO err.consultant_dim
  (
    status, consultant_first_name, consultant_second_name, consultant_last_name, manager_key
  )
  SELECT
    'INCORRECT manager_key value', consultant_first_name, consultant_second_name, consultant_last_name, manager_key
  FROM tmp
  WHERE CAST(manager_key AS INT) NOT IN (SELECT consultant_key FROM pro.consultant_dim);

  RAISE INFO 'STEP %: CORRECT manager_key value.', l_step_num;

----------------------------------------------------------------------------
-- STEP060 Remove wrong rows from tmp table                               --
----------------------------------------------------------------------------

  l_step_num := 60;

  DELETE FROM tmp USING err.consultant_dim err
  WHERE tmp.consultant_business_key = err.consultant_business_key;

  RAISE INFO 'STEP %: Remove wrong rows from tmp table.', l_step_num;

----------------------------------------------------------------------------
-- STEP070 Update existing rows in pro.consultant_dim to deprecated           --
----------------------------------------------------------------------------

  l_step_num := 70;

  UPDATE pro.consultant_dim
  SET active = FALSE, eff_end_dt = current_date, eff_end_tm = current_time
  FROM tmp
  INNER JOIN pro.consultant_dim repo
    ON tmp.consultant_business_key = repo.consultant_business_key;

  RAISE INFO 'STEP %: Update existing rows in pro.consultant_dim to deprecated.', l_step_num;

----------------------------------------------------------------------------
-- STEP080 Insert correct rows to pro.consultant_dim                          --
----------------------------------------------------------------------------

  l_step_num := 80;

  INSERT INTO pro.consultant_dim
  (
    consultant_key,
    consultant_business_key,
    consultant_first_name,
    consultant_second_name,
    consultant_last_name,
    manager_key
  )
  SELECT
    NEXTVAL('pro.consultant_dim_consultant_key_seq'),
    UPPER(consultant_business_key),
    INITCAP(consultant_first_name),
    COALESCE(INITCAP(consultant_second_name),'None'),
    INITCAP(consultant_last_name),
    CAST(manager_key AS INT)
  FROM tmp;

  RAISE INFO 'STEP %: Insert correct rows to pro.consultant_dim.', l_step_num;

EXCEPTION
  WHEN OTHERS THEN RAISE NOTICE '%%%', SQLSTATE || ' - ' || SQLERRM;

END
$$;

alter function meta.pro_consultant_repo_merge() owner to szymonbocian;