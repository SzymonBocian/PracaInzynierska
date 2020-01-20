create table if not exists err.client_dim
(
	status varchar(1000),
	client_first_name varchar(1000),
	client_second_name varchar(1000),
	client_last_name varchar(1000),
	sex_pl varchar(1000),
	sex_eng varchar(1000),
	sex_shortcut_pl varchar(1000),
	sex_shortcut_eng varchar(1000),
	client_age varchar(1000),
	client_business_key varchar(1000)
);

create table if not exists err.consultant_dim
(
	status varchar(1000),
	consultant_first_name varchar(1000),
	consultant_second_name varchar(1000),
	consultant_last_name varchar(1000),
	manager_key varchar(1000),
	consultant_business_key varchar(1000)
);

create table if not exists err.office_dim
(
	status varchar(1000),
	office_business_key varchar(1000),
	old_office_key varchar(1000),
	office_hier_key varchar(1000),
	office_name varchar(1000),
	address_street_name varchar(1000),
	address_street_number varchar(1000),
	address_local_number varchar(1000),
	location_latitude varchar(1000),
	location_longitude varchar(1000)
);

create table if not exists err.service_dim
(
	status varchar(1000),
	service_business_key varchar(1000),
	service_full_name_eng varchar(1000),
	service_full_name_pl varchar(1000),
	service_short_name_eng varchar(1000),
	service_short_name_pl varchar(1000),
	service_code varchar(1000)
);

create table if not exists err.single_call_fact
(
	status varchar(1000),
	client_business_key varchar(1000),
	consultant_business_key varchar(1000),
	office_business_key varchar(1000),
	service_business_key varchar(1000),
	start_join_date_key varchar(1000),
	start_conv_date_key varchar(1000),
	end_conn_date_key varchar(1000),
	start_join_time_key varchar(1000),
	start_conv_time_key varchar(1000),
	end_conn_time_key varchar(1000)
);