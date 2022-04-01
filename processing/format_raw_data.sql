-- Parcels
INSERT INTO PROC.PARCELS (ORIGOID, PARCELNUM, GEOM)
SELECT OBJECTID,
	PARCEL_NO,
	(ST_DUMP(WKB_GEOMETRY)).GEOM
FROM RAW.PARCELS
WHERE PARCEL_NO IS NOT NULL;

-- Municipalities
INSERT INTO PROC.MUNICIPALITIES (MUNINAME, GEOM)
SELECT ZONEDESC,
	(ST_DUMP(WKB_GEOMETRY)).GEOM
FROM RAW.MUNICIPALITIES;

-- Precincts
INSERT INTO PROC.PRECINCTS (PRECINCTNUM, GEOM)
SELECT RIGHT(PRECINCT, 3),
	(ST_DUMP(WKB_GEOMETRY)).GEOM
FROM RAW.PRECINCTS;

-- Fires
INSERT INTO PROC.FIRES (FIRENAME, GEOM)
SELECT NAME,
	(ST_DUMP(WKB_GEOMETRY)).GEOM
FROM RAW.FIRES
WHERE NAME = 'MARSHALL';

-- Library district
INSERT INTO PROC.LIBRARY (GEOM)
SELECT (ST_DUMP(WKB_GEOMETRY)).GEOM
FROM RAW.LIBRARY
WHERE INEFFDATE IS NULL;

-- Tax accounts
INSERT INTO PROC.ACCOUNTS (STRAP, PARCELNUM)
SELECT STRAP,
	PARCELNO
FROM RAW.ACCOUNTS;

-- Taxable value
INSERT INTO PROC.VALUES (STRAP, TAXYR, ACTUALVAL, ASSESSVAL)
SELECT STRAP,
	TAX_YR,
	TOTALACTUALVAL::INTEGER,
	TOTALASSESSEDVAL::INTEGER
FROM RAW.VALUES;

-- Parcel owners
INSERT INTO PROC.OWNERS (STRAP, PARCELNUM, MILLLEVY, ACCTTYPE)
SELECT DISTINCT ON (STRAP, FOLIO)
	STRAP,
	FOLIO,
	MILL_LEVY::NUMERIC,
	ACCOUNT_TYPE
FROM RAW.OWNERS
ORDER BY STRAP, FOLIO;