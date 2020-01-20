create or replace function meta.pro_office_repo_merge() returns void
	language plpgsql
as $$
  ------------------------------------------------------------------------------------
-- Procedure    : pro_office_repo_merge                                           --
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
  FROM stg.office_dim AS stg;

  RAISE INFO 'STEP %: create temporary table.', l_step_num;

----------------------------------------------------------------------------
-- STEP020 Validate office_business_key variable                        --
----------------------------------------------------------------------------

  l_step_num := 20;

  INSERT INTO err.office_dim
  (
    status, office_business_key, old_office_key, office_hier_key, office_name, address_street_name, address_street_number, address_local_number, location_latitude, location_longitude
  )
  SELECT
	'INCORRECT office_business_key', office_business_key, old_office_key, office_hier_key, office_name, address_street_name, address_street_number, address_local_number, location_latitude, location_longitude
  FROM tmp
  WHERE office_business_key IS NULL OR LENGTH(office_business_key) <> 10;

  RAISE INFO 'STEP %: CORRECT office_business_key value.', l_step_num;

----------------------------------------------------------------------------
-- STEP030 Validate old_office_key variable                               --
----------------------------------------------------------------------------

  l_step_num := 30;

  INSERT INTO err.office_dim
  (
    status, office_business_key, old_office_key, office_hier_key, office_name, address_street_name, address_street_number, address_local_number, location_latitude, location_longitude
  )
  SELECT
	'INCORRECT old_office_key', office_business_key, old_office_key, office_hier_key, office_name, address_street_name, address_street_number, address_local_number, location_latitude, location_longitude
  FROM tmp
  WHERE old_office_key IS NOT NULL AND CAST(old_office_key AS INT) NOT IN (SELECT office_key FROM pro.office_dim);

  RAISE INFO 'STEP %: CORRECT old_office_key value.', l_step_num;

----------------------------------------------------------------------------
-- STEP040 Validate office_hier_key variable                              --
----------------------------------------------------------------------------

  l_step_num := 40;

  INSERT INTO err.office_dim
  (
    status, office_business_key, old_office_key, office_hier_key, office_name, address_street_name, address_street_number, address_local_number, location_latitude, location_longitude
  )
  SELECT
    'INCORRECT office_hier_key value', office_business_key, old_office_key, office_hier_key, office_name, address_street_name, address_street_number, address_local_number, location_latitude, location_longitude
  FROM tmp
  WHERE office_hier_key  IS NOT NULL AND CAST(office_hier_key AS INT) NOT IN (SELECT office_key FROM pro.office_dim);

  RAISE INFO 'STEP %: CORRECT office_hier_key value.', l_step_num;

----------------------------------------------------------------------------
-- STEP050 Validate office_name variable                                  --
----------------------------------------------------------------------------

  l_step_num := 50;

  INSERT INTO err.office_dim
  (
    status, office_business_key, old_office_key, office_hier_key, office_name, address_street_name, address_street_number, address_local_number, location_latitude, location_longitude
  )
  SELECT
    'INCORRECT office_name value', office_business_key, old_office_key, office_hier_key, office_name, address_street_name, address_street_number, address_local_number, location_latitude, location_longitude
  FROM tmp
  WHERE office_name IS NULL;

  RAISE INFO 'STEP %: CORRECT office_name value.', l_step_num;

----------------------------------------------------------------------------
-- STEP060 Validate address_street_name variable                          --
----------------------------------------------------------------------------

  l_step_num := 60;

  INSERT INTO err.office_dim
  (
    status, office_business_key, old_office_key, office_hier_key, office_name, address_street_name, address_street_number, address_local_number, location_latitude, location_longitude
  )
  SELECT
    'INCORRECT address_street_name value', office_business_key, old_office_key, office_hier_key, office_name, address_street_name, address_street_number, address_local_number, location_latitude, location_longitude
  FROM tmp
  WHERE address_street_name IS NULL;

  RAISE INFO 'STEP %: CORRECT address_street_name value.', l_step_num;

----------------------------------------------------------------------------
-- STEP070 Validate address_street_number variable                        --
----------------------------------------------------------------------------

  l_step_num := 70;

  INSERT INTO err.office_dim
  (
    status, office_business_key, old_office_key, office_hier_key, office_name, address_street_name, address_street_number, address_local_number, location_latitude, location_longitude
  )
  SELECT
    'INCORRECT address_street_number value', office_business_key, old_office_key, office_hier_key, office_name, address_street_name, address_street_number, address_local_number, location_latitude, location_longitude
  FROM tmp
  WHERE address_street_number IS NULL OR CAST(address_street_number AS INT) < 1;

  RAISE INFO 'STEP %: CORRECT address_street_number value.', l_step_num;

----------------------------------------------------------------------------
-- STEP080 Validate address_local_number variable                         --
----------------------------------------------------------------------------

  l_step_num := 80;

  INSERT INTO err.office_dim
  (
    status, office_business_key, old_office_key, office_hier_key, office_name, address_street_name, address_street_number, address_local_number, location_latitude, location_longitude
  )
  SELECT
    'INCORRECT address_local_number value', office_business_key, old_office_key, office_hier_key, office_name, address_street_name, address_street_number, address_local_number, location_latitude, location_longitude
  FROM tmp
  WHERE address_local_number IS NULL OR CAST(address_local_number AS INT) < 1;

  RAISE INFO 'STEP %: CORRECT address_local_number value.', l_step_num;

----------------------------------------------------------------------------
-- STEP090 Validate location_latitude variable                            --
----------------------------------------------------------------------------

  l_step_num := 90;

  INSERT INTO err.office_dim
  (
    status, office_business_key, old_office_key, office_hier_key, office_name, address_street_name, address_street_number, address_local_number, location_latitude, location_longitude
  )
  SELECT
    'INCORRECT location_latitude value', office_business_key, old_office_key, office_hier_key, office_name, address_street_name, address_street_number, address_local_number, location_latitude, location_longitude
  FROM tmp
  WHERE location_latitude IS NULL
     OR CAST(location_latitude AS NUMERIC(6,4)) <= -90.0000
     OR CAST(location_latitude AS NUMERIC(6,4)) >= 90.0000;

  RAISE INFO 'STEP %: CORRECT location_latitude value.', l_step_num;

----------------------------------------------------------------------------
-- STEP100 Validate location_longitude variable                           --
----------------------------------------------------------------------------

  l_step_num := 100;

  INSERT INTO err.office_dim
  (
    status, office_business_key, old_office_key, office_hier_key, office_name, address_street_name, address_street_number, address_local_number, location_latitude, location_longitude
  )
  SELECT
    'INCORRECT location_longitude value', office_business_key, old_office_key, office_hier_key, office_name, address_street_name, address_street_number, address_local_number, location_latitude, location_longitude
  FROM tmp
  WHERE location_longitude IS NULL
     OR CAST(location_longitude AS NUMERIC(7,4)) <= -180.0000
     OR CAST(location_longitude AS NUMERIC(7,4)) >= 180.0000;

  RAISE INFO 'STEP %: CORRECT location_longitude value.', l_step_num;

----------------------------------------------------------------------------
-- STEP110 Remove wrong rows from tmp table                               --
----------------------------------------------------------------------------

  l_step_num := 110;

  DELETE FROM tmp USING err.office_dim err
  WHERE tmp.office_business_key = err.office_business_key;

  RAISE INFO 'STEP %: Remove wrong rows from tmp table.', l_step_num;

----------------------------------------------------------------------------
-- STEP120 Update existing rows in pro.office_dim to deprecated           --
----------------------------------------------------------------------------

  l_step_num := 120;

  UPDATE pro.office_dim
  SET active = FALSE, eff_end_dt = current_date, eff_end_tm = current_time
  FROM tmp
  INNER JOIN pro.office_dim repo
    ON tmp.office_business_key = repo.office_business_key;

  RAISE INFO 'STEP %: Update existing rows in pro.office_dim to deprecated.', l_step_num;

----------------------------------------------------------------------------
-- STEP130 Insert correct rows to pro.office_dim                          --
----------------------------------------------------------------------------

  l_step_num := 130;

  INSERT INTO pro.office_dim
  (
    office_key,
    office_business_key,
    old_office_key,
    office_hier_key,
    office_name,
    adress_street_name,
    adress_street_number,
    adress_local_number,
    location_latitude,
    location_longitude
  )
  SELECT
    NEXTVAL('pro.office_dim_office_key_seq'),
    UPPER(office_business_key),
    CAST(old_office_key AS INT),
    CAST(office_hier_key AS INT),
    INITCAP(office_name),
    INITCAP(address_street_name),
    CAST(address_street_number AS INT),
    COALESCE(CAST(address_local_number AS INT),0),
    CAST(location_latitude AS NUMERIC(6,4)),
    CAST(location_longitude AS NUMERIC(7,4))
  FROM tmp;

  RAISE INFO 'STEP %: Insert correct rows to pro.office_dim.', l_step_num;

EXCEPTION
  WHEN OTHERS THEN RAISE NOTICE '%%%', SQLSTATE || ' - ' || SQLERRM;

END
$$;

alter function meta.pro_office_repo_merge() owner to szymonbocian;