#!/bin/bash

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