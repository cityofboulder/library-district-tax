/*
When joining spatial data, the following need to be considered:

    1. Whether the parcel is in the library district
	2. Which municipality the parcel resides in
	3. Whether the parcel was impacted by the Marshall Fire
	4. Which voting precinct the parcel resides in

We still want to retain parcels even if they do not have a
spatial relationship with the library district or marshall fire; thus, 
we use left outer joins and attribute the results based on those spatial
tests.
*/

INSERT INTO CLEAN.LIBRARY_PARCELS (PARCELNUM, PRECINCT, INLIBDIST, MUNINAME, MARSHFIRE, GEOM)
SELECT P.PARCELNUM,
	PC.PRECINCTNUM PRECINCT,
	CASE WHEN L.OID IS NULL THEN FALSE ELSE TRUE END INLIBDIST,
	CASE WHEN M.MUNINAME IS NULL THEN 'Unincorporated' ELSE M.MUNINAME END MUNINAME,
	CASE WHEN F.FIRENAME IS NULL THEN FALSE ELSE TRUE END MARSHFIRE,
	P.GEOM
FROM PROC.PARCELS P
LEFT JOIN PROC.LIBRARY L
ON ST_WITHIN(ST_POINTONSURFACE(P.GEOM), L.GEOM)
LEFT OUTER JOIN PROC.MUNICIPALITIES M
ON ST_WITHIN(ST_POINTONSURFACE(P.GEOM), M.GEOM)
LEFT OUTER JOIN PROC.FIRES F
ON ST_INTERSECTS(P.GEOM, F.GEOM)
LEFT OUTER JOIN PROC.PRECINCTS PC
ON ST_WITHIN(ST_POINTONSURFACE(P.GEOM), PC.GEOM);