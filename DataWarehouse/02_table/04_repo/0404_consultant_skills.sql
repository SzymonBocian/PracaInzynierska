create table if not exists pro.consultant_service_assoc
(
	consultant_key integer not null
		constraint fk_consultant_key
			references pro.consultant_dim
				on update restrict on delete restrict,
	service_key integer not null
		constraint fk_service_key
			references pro.service_dim
				on update restrict on delete restrict
);

create unique index if not exists uix_consultant_service_key
	on pro.consultant_service_assoc (consultant_key, service_key);