-- psql -h localhost -p 5432 -U postgres
-- psql "host=localhost port=5432 dbname=vr_db user=vr_admin sslmode=prefer"

-- Role: vr_admin
-- DROP ROLE IF EXISTS vr_admin;
CREATE ROLE vr_admin WITH
  LOGIN
  NOSUPERUSER
  INHERIT
  CREATEDB
  NOCREATEROLE
  NOREPLICATION
  NOBYPASSRLS
  ENCRYPTED PASSWORD 'SCRAM-SHA-256$4096:6BkFFsUINQSFEHX97EqGlg==$8wYQMwPXv9tb77Jdp9w3NvxtQOHmPZfYXpB5bbvV7vc=:nZ6Qf0R7cgcVtBmkijDwjDwaS+ZHh32MIkxVxqKQfbo=';

-- Database: vr_db
-- DROP DATABASE IF EXISTS vr_db;
CREATE DATABASE vr_db
    WITH
    OWNER = vr_admin
    ENCODING = 'UTF8'
    LC_COLLATE = 'Ukrainian_Ukraine.1251'
    LC_CTYPE = 'Ukrainian_Ukraine.1251'
    LOCALE_PROVIDER = 'libc'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;

-- 1. Transfer database ownership (grants full privileges on the database itself)
ALTER DATABASE vr_db OWNER TO vr_admin;