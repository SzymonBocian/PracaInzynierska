create or replace function meta.pro_file_to_stage_load(in_schema_name text, in_table_name text, in_path_to_folder text DEFAULT '/Users/szymonbocian/Documents/CallCenterStaffing/Input'::text) returns void
	language plpgsql
as $$
DECLARE

  l_step_num    INT := 0;
  l_column_list TEXT;

BEGIN

----------------------------------------------------------------------------
-- STEP010 Validate input parameters                                      --
----------------------------------------------------------------------------

  l_step_num := 10;

  IF(in_schema_name IS NULL OR in_table_name IS NULL OR in_path_to_folder IS NULL) THEN
    RAISE NOTICE '%%%', SQLSTATE || ' - ' || SQLERRM;
  ELSE
    RAISE INFO 'STEP %: parameters correct.', l_step_num;
  END IF;

----------------------------------------------------------------------------
-- STEP020 Clean stage target table                                       --
----------------------------------------------------------------------------

  l_step_num := 20;

  EXECUTE 'TRUNCATE TABLE ' || in_schema_name || '.' || in_table_name || ';';

  RAISE INFO 'STEP %: truncate target table %.%',l_step_num,in_schema_name,in_table_name;

----------------------------------------------------------------------------
-- STEP030 Copy data from file to stage                                   --
----------------------------------------------------------------------------

  l_step_num := 30;

  EXECUTE '
  SELECT STRING_AGG(c.column_name,'','')
  FROM INFORMATION_SCHEMA.tables t
  INNER JOIN INFORMATION_SCHEMA.columns c
  ON t.table_schema = c.table_schema
    AND t.table_name = c.table_name
  WHERE t.table_schema = ''' || $1 || '''
    AND t.table_name = ''' || $2 || ''';' INTO l_column_list USING in_schema_name,in_table_name;

  EXECUTE
  'COPY ' || in_schema_name || '.' || in_table_name || '(' || l_column_list || ') ' ||
  'FROM ''' || in_path_to_folder || '/' || in_table_name || '.csv'' DELIMITER '','' CSV HEADER;';

  RAISE INFO 'STEP %: load to target table %.%',l_step_num,in_schema_name,in_table_name;

END
$$;

alter function meta.pro_file_to_stage_load(text, text, text) owner to szymonbocian;
