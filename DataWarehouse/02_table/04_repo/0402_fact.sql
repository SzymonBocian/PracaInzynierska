create table if not exists fact.single_call_fact
(
	call_single_key serial not null
		constraint pk_call_single_key
			primary key,
	call_business_key char(10),
	client_key integer not null
		constraint fk_client_key
			references pro.client_dim
				on update restrict on delete restrict,
	consultant_key integer not null
		constraint fk_consultant_key
			references pro.consultant_dim (consultant_key)
				on update restrict on delete restrict,
	office_key integer not null
		constraint fk_office_key
			references pro.office_dim
				on update restrict on delete restrict,
	service_key integer not null
		constraint fk_service_key
			references pro.service_dim
				on update restrict on delete restrict,
	start_join_date_key bigint not null
		constraint fk_start_join_date_key
			references tech.date_dim
				on update restrict on delete restrict,
	start_conv_date_key bigint not null
		constraint fk_start_conv_date_key
			references tech.date_dim
				on update restrict on delete restrict,
	end_conn_date_key bigint not null
		constraint fk_end_conn_date_key
			references tech.date_dim
				on update restrict on delete restrict,
	start_join_time_key bigint not null
		constraint fk_start_join_time_key
			references tech.time_dim
				on update restrict on delete restrict,
	start_conv_time_key bigint not null
		constraint fk_start_conv_time_key
			references tech.time_dim
				on update restrict on delete restrict,
	end_conn_time_key bigint not null
		constraint fk_end_conn_time_key
			references tech.time_dim
				on update restrict on delete restrict,
	call_duration_in_sec integer not null,
	call_duration_in_min smallint not null,
	wait_time_in_sec integer not null,
	wait_time_in_min smallint not null,
	period_num_15 smallint not null,
	period_num_30 smallint not null,
	conn_time_in_sec integer not null,
	conn_time_in_min smallint not null
);