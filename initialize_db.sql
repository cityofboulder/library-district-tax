-- Run this file as a superuser connected to the user's database of choice
create schema if not exists sandbox;
create schema if not exists raw;
create schema if not exists proc;
create schema if not exists clean;
set search_path = sandbox, raw, proc, clean;
create extension if not exists postgis;