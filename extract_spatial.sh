#!/bin/bash

#---COUNTY DATA---
# parcels
echo "Extracting parcels..."
ogr2ogr \
-f PostgreSQL \
Pg:"dbname=library" \
GeoJSON:"https://opendata.arcgis.com/datasets/89ae49d4ddf246388ee5f5e952aa84db_0.geojson" \
-nln "raw.parcels" \
-t_srs "EPSG:2876" \
-overwrite

# municipalities
echo "Extracting municipalities..."
ogr2ogr \
-f PostgreSQL \
Pg:"dbname=library" \
GeoJSON:"https://opendata.arcgis.com/datasets/9597d3916aba47e887ca563d5ac15938_0.geojson" \
-nln "raw.municipalities" \
-t_srs "EPSG:2876" \
-overwrite

# precincts
echo "Extracting voting precincts..."
ogr2ogr \
-f PostgreSQL \
Pg:"dbname=library" \
GeoJSON:"https://opendata.arcgis.com/datasets/c8e2897d283b47f780920af0827d5126_0.geojson" \
-nln "raw.precincts" \
-t_srs "EPSG:2876" \
-overwrite

# fire perimeters
echo "Extracting fire perimeters..."
ogr2ogr \
-f PostgreSQL \
Pg:"dbname=library" \
GeoJSON:"https://opendata.arcgis.com/datasets/61f20f4a64274969a9e740eda5c62de7_0.geojson" \
-nln "raw.fires" \
-t_srs "EPSG:2876" \
-overwrite

#---BOULDER DATA---
# library district
echo "Extracting library districts..."
ogr2ogr \
-f PostgreSQL \
Pg:"dbname=library" \
GeoJSON:"https://opendata.arcgis.com/datasets/5f29b5fb39c74f5c99717da73c6c62cc_0.geojson" \
-nln "raw.library" \
-t_srs "EPSG:2876" \
-overwrite