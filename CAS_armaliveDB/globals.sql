--
-- PostgreSQL database cluster dump
--

\connect postgres

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;



--
-- Drop roles
--

DROP ROLE "all";
DROP ROLE als_official_1;
DROP ROLE als_official_2;
DROP ROLE "armalive.com";
DROP ROLE bstats_admin;
DROP ROLE bstats_allreader;
DROP ROLE bstats_auto;
DROP ROLE bstats_reader;
DROP ROLE bstats_servers;
DROP ROLE dao_valhalla;
DROP ROLE ddrop;
DROP ROLE frontline_combat;
DROP ROLE local;
DROP ROLE mahuja;
DROP ROLE phpbbuser;
DROP ROLE postgres;
DROP ROLE psymorph;
DROP ROLE spyder;
DROP ROLE uplink_debug;


--
-- Roles
--

CREATE ROLE "all";
ALTER ROLE "all" WITH NOSUPERUSER NOINHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION VALID UNTIL 'infinity';
CREATE ROLE als_official_1;
ALTER ROLE als_official_1 WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION PASSWORD 'md54243c4331ad66597216e4ceb3e8caef3' VALID UNTIL 'infinity';
CREATE ROLE als_official_2;
ALTER ROLE als_official_2 WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION PASSWORD 'md534660b2a965a293d1df0d34830006515';
CREATE ROLE "armalive.com";
ALTER ROLE "armalive.com" WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION PASSWORD 'md54a19d99168ea3c77d7ebd4fc952d5183' VALID UNTIL 'infinity';
CREATE ROLE bstats_admin;
ALTER ROLE bstats_admin WITH NOSUPERUSER INHERIT CREATEROLE NOCREATEDB NOLOGIN NOREPLICATION VALID UNTIL 'infinity';
CREATE ROLE bstats_allreader;
ALTER ROLE bstats_allreader WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION VALID UNTIL 'infinity';
CREATE ROLE bstats_auto;
ALTER ROLE bstats_auto WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION VALID UNTIL 'infinity';
COMMENT ON ROLE bstats_auto IS 'This is meant to give the correct privilege level to automatic database changes based on other agents actions - like updating the "sum" tables.';
CREATE ROLE bstats_reader;
ALTER ROLE bstats_reader WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION VALID UNTIL 'infinity';
CREATE ROLE bstats_servers;
ALTER ROLE bstats_servers WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION VALID UNTIL 'infinity';
CREATE ROLE dao_valhalla;
ALTER ROLE dao_valhalla WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION PASSWORD 'md52e2b2ec6393be9d15a6f2c5b0c246d1c' VALID UNTIL 'infinity';
CREATE ROLE ddrop;
ALTER ROLE ddrop WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION PASSWORD 'md53621734da8a397b78c181f205802e2df' VALID UNTIL 'infinity';
COMMENT ON ROLE ddrop IS 'This is a user account for the db used for the ddrop project. It has nothing to do with bstats.';
CREATE ROLE frontline_combat;
ALTER ROLE frontline_combat WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION PASSWORD 'md546726e171122cf7f94f45a381bc4273d';
CREATE ROLE local;
ALTER ROLE local WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION PASSWORD 'md566d9565fb2a0114e81313f81f206279d' VALID UNTIL '2011-09-01 00:00:00+02';
CREATE ROLE mahuja;
ALTER ROLE mahuja WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION PASSWORD 'md5b92dcbd92637e2a2666a763eaf823465' VALID UNTIL 'infinity';
ALTER ROLE mahuja SET search_path TO "$user", public, static, raw, cooked, pg_catalog;
CREATE ROLE phpbbuser;
ALTER ROLE phpbbuser WITH NOSUPERUSER INHERIT NOCREATEROLE CREATEDB LOGIN NOREPLICATION PASSWORD 'md53f7728bd35fe8d886a6c5083535405d2';
CREATE ROLE postgres;
ALTER ROLE postgres WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION PASSWORD 'md53a2ffdf3ad221cdca438ffa6a2f87f02';
CREATE ROLE psymorph;
ALTER ROLE psymorph WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION PASSWORD 'md5b70e28c4918a6e186a2ec41d8f05cc8d' VALID UNTIL '2012-07-01 09:00:00+02';
CREATE ROLE spyder;
ALTER ROLE spyder WITH NOSUPERUSER INHERIT CREATEROLE NOCREATEDB LOGIN NOREPLICATION PASSWORD 'md5db83853398deae17145e58b09e1f9877' VALID UNTIL 'infinity';
CREATE ROLE uplink_debug;
ALTER ROLE uplink_debug WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION PASSWORD 'md58231793e777cd82f7a8d57dbaf852fd3' VALID UNTIL 'infinity';
COMMENT ON ROLE uplink_debug IS 'Used for debug runs - the data created by this user is not real, or a duplicate of what another server has entered to the db. (Or should have, if it worked right.)';


--
-- Role memberships
--

GRANT "all" TO bstats_admin GRANTED BY mahuja;
GRANT "all" TO bstats_auto GRANTED BY mahuja;
GRANT "all" TO bstats_reader GRANTED BY mahuja;
GRANT "all" TO bstats_servers GRANTED BY mahuja;
GRANT "all" TO mahuja GRANTED BY mahuja;
GRANT bstats_admin TO mahuja GRANTED BY mahuja;
GRANT bstats_admin TO spyder WITH ADMIN OPTION GRANTED BY mahuja;
GRANT bstats_reader TO "armalive.com" GRANTED BY mahuja;
GRANT bstats_reader TO bstats_admin WITH ADMIN OPTION GRANTED BY mahuja;
GRANT bstats_reader TO bstats_auto GRANTED BY mahuja;
GRANT bstats_reader TO psymorph GRANTED BY mahuja;
GRANT bstats_servers TO als_official_1 GRANTED BY mahuja;
GRANT bstats_servers TO als_official_2 GRANTED BY spyder;
GRANT bstats_servers TO bstats_admin WITH ADMIN OPTION GRANTED BY mahuja;
GRANT bstats_servers TO bstats_auto GRANTED BY mahuja;
GRANT bstats_servers TO dao_valhalla GRANTED BY mahuja;
GRANT bstats_servers TO frontline_combat GRANTED BY spyder;
GRANT bstats_servers TO local GRANTED BY mahuja;
GRANT bstats_servers TO uplink_debug GRANTED BY mahuja;




--
-- PostgreSQL database cluster dump complete
--

CREATE DATABASE bstats_master;
