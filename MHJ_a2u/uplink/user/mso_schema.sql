create table staticobjects (
	sessionid int,
	objectid varchar(16),	-- netid
	class varchar(40) not null,
	position varchar(50) not null,	-- real[3] would be more work, varchar can be passthrough
	vectordir varchar(50),
	vectorup varchar(50),
	health real,
	weapons text,
	ammo text,
	weaponcargo text,
	ammocargo text,
	PRIMARY KEY (sessionid,objectid)
);

