create function meta.pro_calendar_merge() returns void
	language plpgsql
as $$
DECLARE

    l_step_num INT := 0;

  BEGIN

----------------------------------------------------------------------------
-- STEP010 Validate input parameters                                      --
----------------------------------------------------------------------------

  l_step_num := 10;

  UPDATE pro.work_calendar SET active = FALSE WHERE active = TRUE;

--   CREATE TEMPORARY TABLE tmp
-- 	(
-- 		consultant_business_key varchar(64) not null,
-- 		consultant_key bigint not null,
-- 		_1st_day bigint not null,
-- 		_2nd_day bigint not null,
-- 		_3rd_day bigint not null,
-- 		_4th_day bigint not null,
-- 		_5th_day bigint not null,
-- 		_6th_day bigint not null,
-- 		_7th_day bigint not null,
-- 		_1st_service_key varchar(128) null,
-- 		_2nd_service_key varchar(128) null,
-- 		_3rd_service_key varchar(128) null,
-- 		_4th_service_key varchar(128) null,
-- 		_5th_service_key varchar(128) null,
-- 		_6th_service_key varchar(128) null,
-- 		_7th_service_key varchar(128) null
-- 	);

  EXECUTE
    'COPY pro.work_calendar (consultant_key, _1st_day, _2nd_day, _3rd_day, _4th_day, _5th_day, _6th_day, _7th_day,' ||
		'_1st_service_key, _2nd_service_key, _3rd_service_key, _4th_service_key, _5th_service_key, _6th_service_key, _7th_service_key )' ||
    'FROM ''' || '/Users/szymonbocian/Documents/CallCenterStaffing/Input/work_calendar.csv' ||  '''DELIMITER '','' CSV HEADER;';

-- 	EXECUTE
-- 	  'SELECT' || ||
-- 	  'FROM tmp ' ||
-- 	  'LEFT JOIN pro.service_dim sd1 ON tmp._1st_service_name = sd1.service_short_name_eng' ||
-- 	  'LEFT JOIN pro.service_dim sd2 ON tmp._2nd_service_name = sd2.service_short_name_eng' ||
-- 	  'LEFT JOIN pro.service_dim sd3 ON tmp._3rd_service_name = sd3.service_short_name_eng' ||
-- 	  'LEFT JOIN pro.service_dim sd4 ON tmp._4th_service_name = sd4.service_short_name_eng' ||
-- 	  'LEFT JOIN pro.service_dim sd5 ON tmp._5th_service_name = sd5.service_short_name_eng' ||
-- 	  'LEFT JOIN pro.service_dim sd6 ON tmp._6th_service_name = sd6.service_short_name_eng' ||
-- 	  'LEFT JOIN pro.service_dim sd7 ON tmp._7th_service_name = sd7.service_short_name_eng'

	END;
$$;

alter function meta.pro_calendar_merge() owner to szymonbocian;

