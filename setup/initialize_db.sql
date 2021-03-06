-- Run this file as a superuser connected to the user's database of choice

-- Drop everything
DROP SCHEMA IF EXISTS SANDBOX CASCADE;

DROP SCHEMA IF EXISTS RAW CASCADE;

DROP SCHEMA IF EXISTS PROC CASCADE;

DROP SCHEMA IF EXISTS CLEAN CASCADE;

DROP EXTENSION IF EXISTS POSTGIS CASCADE;

-- Create schema
CREATE SCHEMA SANDBOX;

CREATE SCHEMA RAW;

CREATE SCHEMA PROC;

CREATE SCHEMA CLEAN;

SET SEARCH_PATH = PUBLIC, SANDBOX, RAW, PROC, CLEAN;

-- Add postgis extension
CREATE EXTENSION IF NOT EXISTS POSTGIS;