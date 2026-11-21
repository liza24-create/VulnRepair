-- psql -h localhost -p 5432 -U postgres
-- psql "host=localhost port=5432 dbname=vr_db user=vr_admin sslmode=prefer"

-- Role: vr_admin
DROP ROLE IF EXISTS vr_admin;
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

GRANT TEMPORARY, CONNECT ON DATABASE vr_db TO PUBLIC;
GRANT ALL ON DATABASE vr_db TO vr_admin;


-- Grant privileges for our db to the vr_admin role
ALTER DATABASE vr_db OWNER TO vr_admin;

GRANT ALL PRIVILEGES ON DATABASE vr_db TO vr_admin;
GRANT ALL ON vr_db.SCHEMA public TO vr_admin;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO vr_admin;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO vr_admin;

ALTER DEFAULT PRIVILEGES IN SCHEMA public
    GRANT ALL PRIVILEGES ON TABLES TO vr_admin;
ALTER DEFAULT PRIVILEGES IN SCHEMA public
    GRANT ALL PRIVILEGES ON SEQUENCES TO vr_admin;


-- SCHEMA: public
-- DROP SCHEMA IF EXISTS public ;
CREATE SCHEMA IF NOT EXISTS public
    AUTHORIZATION vr_admin;

COMMENT ON SCHEMA public
    IS 'standard public schema';

GRANT USAGE ON SCHEMA public TO PUBLIC;

GRANT ALL ON SCHEMA public TO vr_admin;

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public
GRANT ALL ON TABLES TO vr_admin;

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public
GRANT ALL ON SEQUENCES TO vr_admin;

