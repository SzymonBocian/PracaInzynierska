create table if not exists tech.date_dim
(
	date_key bigint not null
		constraint pk_date_key
			primary key,
	date_value date
		constraint uix_date_value
			unique,
	next_date_value date not null,
	year_value integer not null,
	year_quarter smallint not null,
	year_month smallint not null,
	day_of_year smallint not null,
	day_of_month smallint not null,
	day_of_week integer not null,
	year_name_eng varchar(4) not null,
	year_quarter_name_eng varchar(7) not null,
	quarter_name_eng varchar(8) not null,
	month_name_eng varchar(3) not null,
	month_name_long_eng varchar(9) not null,
	week_day_name_eng varchar(3) not null,
	week_day_name_long_eng varchar(9) not null,
	start_of_year_date date not null,
	end_of_year_date date not null,
	start_of_quarter_date date not null,
	end_of_quarter_date date not null,
	start_of_month_date date not null,
	end_of_month_date date not null,
	start_of_week_sun_date date not null,
	end_of_week_sun_date date not null,
	start_of_week_mon_date date not null,
	end_of_week_mon_date date not null,
	iso_week_of_year integer
);

create table if not exists tech.time_dim
(
	time_key bigint not null
		constraint pk_time_key
			primary key,
	time_value time
		constraint uix_time_value
			unique,
	quarter_of_an_hour smallint not null,
	hour_value smallint not null,
	minute_value smallint not null,
	second_value smallint not null,
	quarter_in_day integer not null,
	hour_in_day smallint not null,
	minute_in_day integer not null,
	second_in_day integer not null,
	quarter_name_eng char(3) not null,
	quarter_name_long_eng varchar(10) not null
);