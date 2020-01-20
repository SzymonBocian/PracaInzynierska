create table pro.work_calendar
(
	work_calendar_key serial not null
		constraint pk_id_work_calendar_key
			primary key,
	consultant_key bigint not null,
	"_1st_day" smallint not null,
	"_2nd_day" smallint not null,
	"_3rd_day" smallint not null,
	"_4th_day" smallint not null,
	"_5th_day" smallint not null,
	"_6th_day" smallint not null,
	"_7th_day" smallint not null,
	"_1st_service_key" bigint,
	"_2nd_service_key" bigint,
	"_3rd_service_key" bigint,
	"_4th_service_key" bigint,
	"_5th_service_key" bigint,
	"_6th_service_key" bigint,
	"_7th_service_key" bigint
);



