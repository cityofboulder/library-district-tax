/*
Create tables in the raw (RAW) and processing (PROC) schemas.

All spatial data comes in via ogr2ogr, so the table columns are created
automatically. CSV data needs to be created inside the RAW schema first,
and then extracted into those tables.
*/

-- DROP TABLES

DROP TABLE IF EXISTS RAW.ACCOUNTS CASCADE;

DROP TABLE IF EXISTS RAW.VALUES CASCADE;

DROP TABLE IF EXISTS RAW.OWNERS CASCADE;

DROP TABLE IF EXISTS PROC.ACCOUNTS CASCADE;

DROP TABLE IF EXISTS PROC.VALUES CASCADE;

DROP TABLE IF EXISTS PROC.OWNERS CASCADE;

DROP TABLE IF EXISTS PROC.PARCELS CASCADE;

DROP TABLE IF EXISTS PROC.MUNICIPALITIES CASCADE;

DROP TABLE IF EXISTS PROC.PRECINCTS CASCADE;

DROP TABLE IF EXISTS PROC.FIRES CASCADE;

DROP TABLE IF EXISTS PROC.LIBRARY CASCADE;


-- CREATE TABLES

CREATE TABLE RAW.ACCOUNTS (
	strap VARCHAR,
	Parcelno VARCHAR
);

CREATE TABLE RAW.VALUES (
	strap VARCHAR,
	tax_yr VARCHAR,
	bldAcutalVal VARCHAR,
	LandAcutalVal VARCHAR,
	xfActualVal VARCHAR,
	totalActualVal VARCHAR,
	landAssessedVal VARCHAR,
	bldAssessedVal VARCHAR,
	xfAssessedVal VARCHAR,
	totalAssessedVal VARCHAR,
	status_cd VARCHAR
);

CREATE TABLE RAW.OWNERS (
	CreatedDate VARCHAR,
	strap VARCHAR,
	folio VARCHAR,
	status_cd VARCHAR,
	bld_num VARCHAR,
	str_num VARCHAR,
	str VARCHAR,
	str_pfx VARCHAR,
	str_sfx VARCHAR,
	str_unit VARCHAR,
	city VARCHAR,
	sub_code VARCHAR,
	sub_dscr VARCHAR,
	section VARCHAR,
	township VARCHAR,
	range VARCHAR,
	block VARCHAR,
	lot VARCHAR,
	owner_name VARCHAR,
	mail_to VARCHAR,
	mailingAddr1 VARCHAR,
	mailingAddr2 VARCHAR,
	mailingCity VARCHAR,
	mailingState VARCHAR,
	mailingZip VARCHAR,
	mailingCountry VARCHAR,
	role_cd VARCHAR,
	pct_own VARCHAR,
	taxArea VARCHAR,
	nh VARCHAR,
	mill_levy VARCHAR,
	legalDscr VARCHAR,
	waterFee VARCHAR,
	account_type VARCHAR
);

CREATE TABLE PROC.ACCOUNTS (
	OID SERIAL PRIMARY KEY,
	STRAP VARCHAR,
	PARCELNUM VARCHAR
);

CREATE TABLE PROC.VALUES (
	OID SERIAL PRIMARY KEY,
	STRAP VARCHAR,
	TAXYR VARCHAR,
	ACTUALVAL INTEGER,
	ASSESSVAL INTEGER
);

CREATE TABLE PROC.OWNERS (
	OID SERIAL PRIMARY KEY,
	STRAP VARCHAR,
	PARCELNUM VARCHAR,
	MILLLEVY NUMERIC,
	ACCTTYPE VARCHAR
);

CREATE TABLE PROC.PARCELS (
	OID SERIAL PRIMARY KEY,
	ORIGOID BIGSERIAL,
	PARCELNUM VARCHAR,
	GEOM GEOMETRY(POLYGON, 2876) NOT NULL
);

CREATE TABLE PROC.MUNICIPALITIES (
	OID SERIAL PRIMARY KEY,
	MUNINAME VARCHAR,
	GEOM GEOMETRY(POLYGON, 2876) NOT NULL
);

CREATE TABLE PROC.PRECINCTS (
	OID SERIAL PRIMARY KEY,
	PRECINCTNUM VARCHAR,
	GEOM GEOMETRY(POLYGON, 2876) NOT NULL
);

CREATE TABLE PROC.FIRES (
	OID SERIAL PRIMARY KEY,
    FIRENAME VARCHAR,
	GEOM GEOMETRY(POLYGON, 2876) NOT NULL
);

CREATE TABLE PROC.LIBRARY (
	OID SERIAL PRIMARY KEY,
	GEOM GEOMETRY(POLYGON, 2876) NOT NULL
);

CREATE TABLE CLEAN.TAXES (
	OID SERIAL PRIMARY KEY,
	PARCELNUM VARCHAR,
	ACCTTYPE VARCHAR,
	ACTUALVAL INTEGER,
	ASSESSVAL INTEGER,
	MILLLEVY NUMERIC
);

CREATE TABLE CLEAN.LIBRARY_PARCELS (
	OID SERIAL PRIMARY KEY,
	PRECINCT VARCHAR,
	MUNINAME VARCHAR,
	MARSHFIRE INTEGER,
	GEOM GEOMETRY(POLYGON, 2876) NOT NULL
);

-- CREATE SPATIAL INDICES

CREATE INDEX PARCELS_GEOM_IDX ON PROC.PARCELS USING GIST(GEOM);

CREATE INDEX MUNICIPALITIES_GEOM_IDX ON PROC.MUNICIPALITIES USING GIST(GEOM);

CREATE INDEX PRECINCTS_GEOM_IDX ON PROC.PRECINCTS USING GIST(GEOM);

CREATE INDEX FIRES_GEOM_IDX ON PROC.FIRES USING GIST(GEOM);

CREATE INDEX LIBRARY_GEOM_IDX ON PROC.LIBRARY USING GIST(GEOM);

CREATE INDEX LIBRARY_PARCELS_GEOM_IDX ON CLEAN.LIBRARY_PARCELS USING GIST(GEOM);