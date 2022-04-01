#!/bin/bash

# Extract data
# create the database
psql -U postgres -f ./setup/create_db.sql
# initialize the database schema and extensions
psql -U postgres -d library -f ./setup/initialize_db.sql
# create raw and processing tables
psql -U postgres -d library -f ./setup/create_tables.sql
# extract spatial data
sh ./setup/extract_spatial.sh
# extract tabular data
psql -d library -f ./setup/extract_csv.sql

# Process data
# format raw into processing schema
psql -U postgres -d library -f ./processing/format_raw_data.sql
# process tax data
psql -u postgres -d library -f ./processing/tax_joins.sql
# process spatial data
psql -u postgres -d library -f ./processing/spatial_joins.sql

# Analyze data
# create revenues table
psql -u postgres -d library -f ./analysis/anticipated_revenue.sql
# extract as a shp
pgsql2shp -u postgres library clean.revenue