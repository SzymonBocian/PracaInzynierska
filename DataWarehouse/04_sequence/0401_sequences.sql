create sequence fact.single_call_fact_call_single_key_seq
	as integer
	maxvalue 2147483647;

alter sequence fact.single_call_fact_call_single_key_seq owner to szymonbocian;

create sequence pro.client_dim_client_key_seq
	as integer
	maxvalue 2147483647;

alter sequence pro.client_dim_client_key_seq owner to szymonbocian;

create sequence pro.consultant_dim_consultant_key_seq
	as integer
	maxvalue 2147483647;

alter sequence pro.consultant_dim_consultant_key_seq owner to szymonbocian;

create sequence pro.office_dim_office_key_seq
	as integer
	maxvalue 2147483647;

alter sequence pro.office_dim_office_key_seq owner to szymonbocian;

create sequence pro.service_dim_service_key_seq
	as integer
	maxvalue 2147483647;

alter sequence pro.service_dim_service_key_seq owner to szymonbocian;


