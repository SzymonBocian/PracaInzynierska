create table if not exists pro.client_dim
(
	client_key serial not null
		constraint pk_id_client_key
			primary key,
	client_business_key varchar(12) not null,
	client_first_name varchar(32) not null,
	client_second_name varchar(32) default '-'::character varying not null,
	client_last_name varchar(64) not null,
	sex_pl varchar(10) not null,
	sex_eng varchar(6) not null,
	sex_shortcut_pl char not null,
	sex_shortcut_eng char not null,
	client_age integer not null,
	eff_start_dt date default CURRENT_DATE not null,
	eff_start_tm time default (to_timestamp('00:00:00'::text, 'HH24:MI:SS'::text))::time without time zone not null,
	load_dt date default CURRENT_DATE not null,
	load_tm time default CURRENT_TIME not null,
	eff_end_dt date default to_date('2020-12-31'::text, 'YYYY-MM-DD'::text) not null,
	eff_end_tm time default (to_timestamp('23:59:59'::text, 'HH24:MI:SS'::text))::time without time zone not null,
	active boolean default true not null
);

create index if not exists ix_client_business_key
	on pro.client_dim (client_business_key);


create table if not exists pro.consultant_dim
(
	consultant_key serial not null
		constraint pk_consultant_key
			primary key,
	consultant_business_key char(12),
	consultant_first_name varchar(32) not null,
	consultant_second_name varchar(32) default '-'::character varying not null,
	consultant_last_name varchar(64) not null,
	manager_key integer
		constraint fk_manager_key
			references pro.consultant_dim
				on update restrict on delete restrict,
	eff_start_dt date default CURRENT_DATE not null,
	eff_start_tm time default (to_timestamp('00:00:00'::text, 'HH24:MI:SS'::text))::time without time zone not null,
	load_dt date default CURRENT_DATE not null,
	load_tm time default CURRENT_TIME not null,
	eff_end_dt date default to_date('2020-12-31'::text, 'YYYY-MM-DD'::text) not null,
	eff_end_tm time default (to_timestamp('23:59:59'::text, 'HH24:MI:SS'::text))::time without time zone not null,
	active boolean default true not null
);

create table if not exists pro.office_dim
(
	office_key serial not null
		constraint pk_office_key
			primary key,
	office_business_key char(10),
	old_office_key integer
		constraint fk_old_office_key
			references pro.office_dim
				on update restrict on delete restrict,
	office_hier_key integer
		constraint fk_office_hier_key
			references pro.office_dim
				on update restrict on delete restrict,
	office_name varchar(64) not null,
	adress_street_name varchar(128) not null,
	adress_street_number varchar(4) not null,
	adress_local_number integer not null,
	location_latitude numeric(6,4) not null,
	location_longitude numeric(7,4) not null,
	eff_start_dt date default CURRENT_DATE not null,
	eff_start_tm time default (to_timestamp('00:00:00'::text, 'HH24:MI:SS'::text))::time without time zone not null,
	load_dt date default CURRENT_DATE not null,
	load_tm time default CURRENT_TIME not null,
	eff_end_dt date default to_date('2020-12-31'::text, 'YYYY-MM-DD'::text) not null,
	eff_end_tm time default (to_timestamp('23:59:59'::text, 'HH24:MI:SS'::text))::time without time zone not null,
	active boolean default true not null,
	constraint uix_office_business_key
		unique (office_business_key, active)
);

create table if not exists pro.service_dim
(
	service_key serial not null
		constraint pk_service_key
			primary key,
	service_business_key char(10)
		constraint uix_service_business_key
			unique,
	service_full_name_eng varchar(64) not null,
	service_full_name_pl varchar(64) not null,
	service_short_name_eng varchar(32) not null,
	service_short_name_pl varchar(32) not null,
	service_code char(16) not null,
	eff_start_dt date default CURRENT_DATE not null,
	eff_start_tm time default (to_timestamp('00:00:00'::text, 'HH24:MI:SS'::text))::time without time zone not null,
	load_dt date default CURRENT_DATE not null,
	load_tm time default CURRENT_TIME not null,
	eff_end_dt date default to_date('2020-12-31'::text, 'YYYY-MM-DD'::text) not null,
	eff_end_tm time default (to_timestamp('23:59:59'::text, 'HH24:MI:SS'::text))::time without time zone not null,
	active boolean default true not null
);
