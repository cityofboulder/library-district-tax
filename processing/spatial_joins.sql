/*
When joining spatial data, the following need to be considered:

    1. Whether the parcel is in the library district
		a.	If a parcel number is associated with multiple polygons and any
			one of those is inside the district, then all of them are
			dissolved and labelled as inside the district
	2. Which municipality the parcel resides in
		a.	If a parcel number is associated with multiple polygons and each
			falls in a different municipality, then all of them are
			dissolved and labelled as part of both municipalities
	3. Whether the parcel was impacted by the Marshall Fire
		a.	If a parcel number is associated with multiple polygons and any
		of those were affected by the marshall fire, then all of them are
		dissolved and labelled as impacted by the fire.
	4. Which voting precinct the parcel resides in
		a.	If a parcel number is associated with multiple polygons and each
			falls in a different voting district, then all of them are
			dissolved and labelled as part of both voting districts

We still want to retain parcels even if they do not have a
spatial relationship with the library district or marshall fire; thus, 
we use left outer joins and attribute the results based on those spatial
tests.
*/

INSERT INTO CLEAN.LIBRARY_PARCELS (PARCELNUM, PRECINCT, INLIBDIST, MUNINAME, MARSHFIRE, GEOM)
SELECT P.PARCELNUM,
	STRING_AGG(DISTINCT PC.PRECINCTNUM, ', ') PRECINCT,
	CASE
		WHEN SUM(CASE WHEN L.OID IS NOT NULL THEN 1 ELSE 0 END) > 0
		THEN TRUE ELSE FALSE
	END INLIBDIST,
	STRING_AGG(DISTINCT CASE WHEN M.MUNINAME IS NULL THEN 'Unincorporated' ELSE M.MUNINAME END, ', ') MUNINAME,
	CASE 
		WHEN SUM(CASE WHEN F.FIRENAME IS NOT NULL THEN 1 ELSE 0 END) > 0
	 	THEN TRUE ELSE FALSE
	END MARSHFIRE,
	ST_COLLECT(P.GEOM) GEOM
FROM PROC.PARCELS P
LEFT JOIN PROC.LIBRARY L
ON ST_WITHIN(ST_POINTONSURFACE(P.GEOM), L.GEOM)
LEFT OUTER JOIN PROC.MUNICIPALITIES M
ON ST_WITHIN(ST_POINTONSURFACE(P.GEOM), M.GEOM)
LEFT OUTER JOIN PROC.FIRES F
ON ST_INTERSECTS(P.GEOM, F.GEOM)
LEFT OUTER JOIN PROC.PRECINCTS PC
ON ST_WITHIN(ST_POINTONSURFACE(P.GEOM), PC.GEOM)
GROUP BY PARCELNUM;