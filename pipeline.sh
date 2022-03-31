#!/bin/bash

# create the database
psql -U postgres -f create_db.sql
# initialize the database schema and extensions
psql -U postgres -d library -f initialize_db.sql
# create raw and processing tables
psql -U postgres -d library -f create_tables.sql
# extract spatial data
sh extract_spatial.sh
# extract tabular data
psql -d library -f extract_csv.sql