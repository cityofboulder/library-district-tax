/*
When joining spatial data, the following need to be considered:

    1. We only care about parcels in the library district
	2. Which municipality the parcel resides in
	3. Whether the parcel was impacted by the Marshall Fire
	4. Which voting precinct the parcel resides in

The library district is the only inner join we want; otherwise,
we still want to retain parcels even if they do not have a
spatial relationship with the comparing geometry; thus, left
outer joins.
*/

INSERT INTO CLEAN.LIBRARY_PARCELS (OID, PARCELNUM, PRECINCT, MUNINAME, MARSHFIRE, GEOM)
SELECT P.OID,
	P.PARCELNUM,
	PC.PRECINCTNUM PRECINCT,
	CASE WHEN M.MUNINAME IS NULL THEN 'Unincorporated' ELSE M.MUNINAME END MUNINAME,
	CASE WHEN F.FIRENAME IS NULL THEN FALSE ELSE TRUE END MARSHFIRE,
	P.GEOM
FROM PROC.PARCELS P
INNER JOIN PROC.LIBRARY L
ON ST_INTERSECTS(P.GEOM, L.GEOM)
LEFT OUTER JOIN PROC.MUNICIPALITIES M
ON ST_WITHIN(ST_POINTONSURFACE(P.GEOM), M.GEOM)
LEFT OUTER JOIN PROC.FIRES F
ON ST_INTERSECTS(P.GEOM, F.GEOM)
LEFT OUTER JOIN PROC.PRECINCTS PC
ON ST_WITHIN(ST_POINTONSURFACE(P.GEOM), PC.GEOM);