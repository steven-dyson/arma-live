--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = raw, pg_catalog;

DROP TRIGGER weaponstats_cook ON raw.weaponstats;
DROP TRIGGER upsert ON raw.weaponstats;
DROP TRIGGER update_playernames ON raw.sessionplayer;
DROP TRIGGER restrict_server_to_user ON raw.session;
DROP TRIGGER playersum_add ON raw.pointevent;
DROP TRIGGER killevent_cook_insert ON raw.killevent;
DROP TRIGGER killevent_cook_delete ON raw.killevent;
DROP TRIGGER "filter_10Gm_bug" ON raw.killevent;
SET search_path = cooked, pg_catalog;

DROP TRIGGER weaponstats_sum_upsert ON cooked.weaponstats_sum;
DROP TRIGGER playername_upsert ON cooked.playername;
SET search_path = raw, pg_catalog;

DROP INDEX raw.session_perp;
DROP INDEX raw.killed_by;
DROP INDEX raw.killed;
SET search_path = cooked, pg_catalog;

DROP INDEX cooked.player_lastseen;
SET search_path = static, pg_catalog;

ALTER TABLE ONLY static.classnames DROP CONSTRAINT classnames_pkey;
ALTER TABLE ONLY static.classgroups DROP CONSTRAINT classgroups_pkey;
SET search_path = raw, pg_catalog;

ALTER TABLE ONLY raw.weaponstats DROP CONSTRAINT weaponstats_pkey;
ALTER TABLE ONLY raw.sessionplayer DROP CONSTRAINT sessionplayer_session_uid_start_key;
ALTER TABLE ONLY raw.sessionplayer DROP CONSTRAINT sessionplayer_pkey;
ALTER TABLE ONLY raw.session DROP CONSTRAINT session_pkey;
SET search_path = queries, pg_catalog;

ALTER TABLE ONLY queries.page_views_player DROP CONSTRAINT page_views_player_pkey;
SET search_path = cooked, pg_catalog;

ALTER TABLE ONLY cooked.weaponstats_sum DROP CONSTRAINT weaponstats_sum_pkey;
ALTER TABLE ONLY cooked.playersum DROP CONSTRAINT playersum_pkey;
ALTER TABLE ONLY cooked.playername DROP CONSTRAINT playername_pkey;
SET search_path = raw, pg_catalog;

ALTER TABLE raw.sessionplayer ALTER COLUMN rowid DROP DEFAULT;
ALTER TABLE raw.session ALTER COLUMN sessionid DROP DEFAULT;
SET search_path = static, pg_catalog;

DROP TABLE static.classnames;
DROP TABLE static.classgroups;
SET search_path = raw, pg_catalog;

DROP TABLE raw.weaponstats;
DROP SEQUENCE raw.sessionplayer_rowid_seq;
DROP TABLE raw.sessionplayer;
DROP SEQUENCE raw.session_sessionid_seq;
DROP TABLE raw.pointevent;
SET search_path = queries, pg_catalog;

DROP VIEW queries.total_time_played;
DROP TABLE queries.page_views_player;
SET search_path = cooked, pg_catalog;

DROP TABLE cooked.weaponstats_sum;
DROP TABLE cooked.playersum;
DROP VIEW cooked.kills_more_info;
SET search_path = raw, pg_catalog;

DROP TABLE raw.session;
DROP TABLE raw.killevent;
SET search_path = cooked, pg_catalog;

DROP VIEW cooked.playername_latest;
DROP TABLE cooked.playername;
SET search_path = static, pg_catalog;

DROP FUNCTION static.test_before_insert_upsert();
DROP FUNCTION static.add_unknown_classes();
SET search_path = raw, pg_catalog;

DROP FUNCTION raw.weaponstats_upsert();
DROP FUNCTION raw.weaponstats_cook();
DROP FUNCTION raw.session_servername();
DROP FUNCTION raw.pointevent_after_insert();
DROP FUNCTION raw.playersession_after_insert_multisafe();
DROP FUNCTION raw.playersession_after_insert();
DROP FUNCTION raw.killevent_filterbug();
DROP FUNCTION raw.killevent_after_insert();
DROP FUNCTION raw.killevent_after_delete();
DROP FUNCTION raw.check_user();
SET search_path = queries, pg_catalog;

DROP FUNCTION queries.view_page_player(playerid integer);
SET search_path = cooked, pg_catalog;

DROP FUNCTION cooked.weaponstats_sum_upsert();
DROP FUNCTION cooked."recook weaponstats_sum"();
DROP FUNCTION cooked."recook playersum"();
DROP FUNCTION cooked.playername_upsert();
DROP EXTENSION adminpack;
DROP EXTENSION plpgsql;
DROP SCHEMA static;
DROP SCHEMA raw;
DROP SCHEMA queries;
DROP SCHEMA public;
DROP SCHEMA cooked;
--
-- Name: cooked; Type: SCHEMA; Schema: -; Owner: mahuja
--

CREATE SCHEMA cooked;


ALTER SCHEMA cooked OWNER TO mahuja;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO postgres;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- Name: queries; Type: SCHEMA; Schema: -; Owner: mahuja
--

CREATE SCHEMA queries;


ALTER SCHEMA queries OWNER TO mahuja;

--
-- Name: SCHEMA queries; Type: COMMENT; Schema: -; Owner: mahuja
--

COMMENT ON SCHEMA queries IS 'SQL code doing complex selects (e.g. ALS php embedded with joins) should be moved here; that way we get the dependency tracking.';


--
-- Name: raw; Type: SCHEMA; Schema: -; Owner: mahuja
--

CREATE SCHEMA raw;


ALTER SCHEMA raw OWNER TO mahuja;

--
-- Name: static; Type: SCHEMA; Schema: -; Owner: mahuja
--

CREATE SCHEMA static;


ALTER SCHEMA static OWNER TO mahuja;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: adminpack; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS adminpack WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION adminpack; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION adminpack IS 'administrative functions for PostgreSQL';


SET search_path = cooked, pg_catalog;

--
-- Name: playername_upsert(); Type: FUNCTION; Schema: cooked; Owner: bstats_auto
--

CREATE FUNCTION playername_upsert() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$begin
perform * from playername where playerid = new.playerid and "name" = new.name;
if found then
  update playername set last_seen = now() where playerid = new.playerid and "name" = new.name;
  return null;
end if;
return new;
end $$;


ALTER FUNCTION cooked.playername_upsert() OWNER TO bstats_auto;

--
-- Name: recook playersum(); Type: FUNCTION; Schema: cooked; Owner: mahuja
--

CREATE FUNCTION "recook playersum"() RETURNS void
    LANGUAGE plpgsql COST 100000
    AS $$
declare 
	v record;
begin

delete from "cooked".playersum where true;
-- Generate empty entries to be updated later
-- (since there's no upsert trigger)
insert into "cooked".playersum (playerid) 
select distinct playerid 
from playername;

-- Kills
FOR v IN 
	select 
		perpid as playerid,
		sum(score_value) as score,
		--
		count (case when event_type='kill' then 1 end) as weaponkills,
		--
		--
		count (case when event_type='roadkill' then 1 end) as roadkills,
		count (case when event_type='civcas' then 1 end) as civcas,
		count (case when event_type='civdmg' then 1 end) as civdmg,
		count (case when event_type='tk' then 1 end) as teamkills,
		count (case when event_type='frienddmg' then 1 end) as teamdmg,
		count (case when event_type='vehkill' then 1 end) as killed_vehicles,
		count (case when event_type='vehtk' then 1 end) as tked_vehicles,
		count (case when event_type='assist' then 1 end) as killassist
	from killevent
	group by playerid
LOOP
	update cooked.playersum set 
		(totalscore, battlescore, weaponkills,roadkills,civcas,civdmg,teamkills,teamdmg,killed_vehicles,tked_vehicles,killassist) 
		= (v.score, v.score, v.weaponkills,v.roadkills,v.civcas,v.civdmg,v.teamkills,v.teamdmg,v.killed_vehicles,v.tked_vehicles,v.killassist)
	where playerid=v.playerid;
END LOOP;

-- Deaths

FOR v IN 
	select 
		victimid as playerid,
		sum(score_value) as score,
		count (case when event_type='suicide'then 1 end) as suicides,
		count (case when event_type='accrash'then 1 end) as aircrashes,
		count (case when event_type not in ('suicide','accrash') then 1 end) 
			as deaths
	from killevent
	where event_type not in ('frienddmg','civdmg')
	group by playerid
LOOP
	update cooked.playersum set 
		(suicides,aircrashes,deaths) 
		= (v.suicides,v.aircrashes,v.deaths)
	where playerid=v.playerid;
END LOOP;


-- Pointevents

-- Not implemented 

end
$$;


ALTER FUNCTION cooked."recook playersum"() OWNER TO mahuja;

--
-- Name: recook weaponstats_sum(); Type: FUNCTION; Schema: cooked; Owner: mahuja
--

CREATE FUNCTION "recook weaponstats_sum"() RETURNS void
    LANGUAGE sql COST 100000
    AS $$
lock table "cooked".weaponstats_sum;
delete from "cooked".weaponstats_sum where true;
insert into "cooked".weaponstats_sum 
select 
	player, 
	class, 
	sum(totalseconds) as totalseconds, 
	sum(fired) as fired, 
	sum(vehiclehits) as vehiclehits, 
	sum(headhits) as headhits, 
	sum(bodyhits) as bodyhits, 
	sum(leghits) as leghits,
	sum(armhits) as armhits,
	0 as avgdist,
	0 as avgcnt
from raw.weaponstats
group by player,class;
-- TODO: When we do kills per weapon tracking, do that here also.

$$;


ALTER FUNCTION cooked."recook weaponstats_sum"() OWNER TO mahuja;

--
-- Name: weaponstats_sum_upsert(); Type: FUNCTION; Schema: cooked; Owner: bstats_auto
--

CREATE FUNCTION weaponstats_sum_upsert() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$begin
perform * from weaponstats_sum where player = new.player and "class" = new.class;
if found then
  update cooked.weaponstats_sum set 
	totalseconds = totalseconds + new.totalseconds,
	"fired" = "fired" + new.fired,
	vehiclehits = vehiclehits + new.vehiclehits,
	headhits = headhits + new.headhits,
	bodyhits = bodyhits + new.bodyhits,
	leghits = leghits + new.leghits,
	armhits = armhits + new.armhits
	where player = new.player and "class" = new.class;
  return null;
end if;
return new;
end $$;


ALTER FUNCTION cooked.weaponstats_sum_upsert() OWNER TO bstats_auto;

SET search_path = queries, pg_catalog;

--
-- Name: view_page_player(integer); Type: FUNCTION; Schema: queries; Owner: bstats_auto
--

CREATE FUNCTION view_page_player(playerid integer) RETURNS integer
    LANGUAGE sql SECURITY DEFINER
    AS $_$update queries.page_views_player set cnt = cnt + 1 where playerid = $1 returning cnt;$_$;


ALTER FUNCTION queries.view_page_player(playerid integer) OWNER TO bstats_auto;

SET search_path = raw, pg_catalog;

--
-- Name: check_user(); Type: FUNCTION; Schema: raw; Owner: mahuja
--

CREATE FUNCTION check_user() RETURNS trigger
    LANGUAGE plpgsql STABLE
    AS $$
begin  

SELECT * FROM raw.session s WHERE s.session = new.session AND s.server = current_user;
IF NOT FOUND THEN
    RAISE EXCEPTION 'Invalid session write - non-existent or belongs elsewhere. (%)', myname;
END IF;

return new;
end;
$$;


ALTER FUNCTION raw.check_user() OWNER TO mahuja;

--
-- Name: killevent_after_delete(); Type: FUNCTION; Schema: raw; Owner: bstats_auto
--

CREATE FUNCTION killevent_after_delete() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
begin  
<<victim>>
LOOP
	IF old.victimid is null THEN EXIT victim; end if;
	CASE old.event_type
	when 'frienddmg', 'civdmg', 'tk' THEN EXIT victim;
	WHEN 'suicide' THEN
		UPDATE playersum 
		SET suicides = suicides - 1, totalscore = totalscore - old.score_value, battlescore = battlescore - old.score_value
		WHERE playerid = old.victimid;
	when 'accrash' THEN
		UPDATE playersum 
		SET aircrashes = aircrashes - 1, totalscore = totalscore - old.score_value, battlescore = battlescore - old.score_value
		WHERE playerid = old.victimid;
	when 'kill' THEN
		update playersum 
		set deaths = deaths - 1 --, totalscore = totalscore - old.score_value, battlescore = battlescore - old.score_value
		where playerid = old.victimid;
	ELSE	--everything else... whatever that is
		update playersum 
		set deaths = deaths - 1 --, totalscore = totalscore - old.score_value, battlescore = battlescore - old.score_value
		where playerid = old.victimid;
	end case;
	IF found THEN EXIT victim; END IF;
	RAISE WARNING 'Deleting killevents: No cooked data to undo';
END LOOP;
<<perp>>
LOOP
	IF old.perpid is null then exit perp; end if;
	CASE old.event_type
	WHEN 'suicide','death' THEN RAISE EXCEPTION 'suicide/death with perpid'; -- Should be filtered by perpid over
	WHEN 'kill' then
		UPDATE playersum 
		SET weaponkills = weaponkills - 1, totalscore = totalscore - old.score_value, battlescore = battlescore - old.score_value
		WHERE playerid = old.perpid;
	WHEN 'roadkill' then 
		UPDATE playersum 
		SET roadkills = roadkills - 1, totalscore = totalscore - old.score_value, battlescore = battlescore - old.score_value
		WHERE playerid = old.perpid;
	when 'civcas' then
		UPDATE playersum 
		SET civcas = civcas - 1, totalscore = totalscore - old.score_value, battlescore = battlescore - old.score_value
		WHERE playerid = old.perpid;
	when 'civdmg' then
		UPDATE playersum 
		SET civdmg = civdmg - 1, totalscore = totalscore - old.score_value, battlescore = battlescore - old.score_value
		WHERE playerid = old.perpid;
	when 'tk' then
		UPDATE playersum 
		SET teamkills = teamkills - 1, totalscore = totalscore - old.score_value, battlescore = battlescore - old.score_value
		WHERE playerid = old.perpid;
	when 'frienddmg' then
		UPDATE playersum 
		SET teamdmg = teamdmg - 1, totalscore = totalscore - old.score_value, battlescore = battlescore - old.score_value
		WHERE playerid = old.perpid;
	when 'vehkill' then
		UPDATE playersum 
		SET killed_vehicles = killed_vehicles - 1, totalscore = totalscore - old.score_value, battlescore = battlescore - old.score_value
		WHERE playerid = old.perpid;
	when 'assist' then
		UPDATE playersum
		SET killassist = killassist - 1, totalscore = totalscore - old.score_value, battlescore = battlescore - old.score_value
		WHERE playerid = old.perpid;
	ELSE RAISE EXCEPTION 'Unknown (unimplemented?) Kill type.';
	end case;
	
	IF found THEN EXIT perp; END IF;
	RAISE WARNING 'Deleting killevents: No cooked data to undo';
END LOOP;
return old;
end;
$$;


ALTER FUNCTION raw.killevent_after_delete() OWNER TO bstats_auto;

--
-- Name: killevent_after_insert(); Type: FUNCTION; Schema: raw; Owner: bstats_auto
--

CREATE FUNCTION killevent_after_insert() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
begin  
<<victim>>
LOOP
	IF new.victimid is null THEN EXIT victim; end if;
	CASE new.event_type
	when 'frienddmg', 'civdmg', 'tk' THEN EXIT victim;
	WHEN 'suicide' THEN
		UPDATE playersum 
		SET suicides = suicides + 1, totalscore = totalscore + new.score_value, battlescore = battlescore + new.score_value
		WHERE playerid = new.victimid;
	when 'accrash' THEN
		UPDATE playersum 
		SET aircrashes = aircrashes + 1, totalscore = totalscore + new.score_value, battlescore = battlescore + new.score_value
		WHERE playerid = new.victimid;
	when 'kill' THEN
		UPDATE playersum 
		SET deaths = deaths + 1 -- , totalscore = totalscore + new.score_value, battlescore = battlescore + new.score_value
		WHERE playerid = new.victimid;

	ELSE	--everything else... whatever that is.
		update playersum 
		set deaths = deaths + 1 --, totalscore = totalscore + new.score_value, battlescore = battlescore + new.score_value
		where playerid = new.victimid;
	end case;
	IF found THEN EXIT victim; END IF;
	insert into playersum (playerid) values (new.victimid);
		-- unsafe if another source is inserting at the same time
		-- such as one of them being delayed by whatever.
END LOOP;
<<perp>>
LOOP
	IF new.perpid is null then exit perp; end if;
	CASE new.event_type
	WHEN 'suicide','death' THEN RAISE EXCEPTION 'suicide/death with perpid'; -- Should be filtered by perpid over
	WHEN 'kill' then
		UPDATE playersum 
		SET weaponkills = weaponkills + 1, totalscore = totalscore + new.score_value, battlescore = battlescore + new.score_value
		WHERE playerid = new.perpid;
	WHEN 'roadkill' then 
		UPDATE playersum 
		SET roadkills = roadkills + 1, totalscore = totalscore + new.score_value, battlescore = battlescore + new.score_value
		WHERE playerid = new.perpid;
	when 'civcas' then
		UPDATE playersum 
		SET civcas = civcas + 1, totalscore = totalscore + new.score_value, battlescore = battlescore + new.score_value
		WHERE playerid = new.perpid;
	when 'civdmg' then
		UPDATE playersum 
		SET civdmg = civdmg + 1, totalscore = totalscore + new.score_value, battlescore = battlescore + new.score_value
		WHERE playerid = new.perpid;
	when 'tk' then
		UPDATE playersum 
		SET teamkills = teamkills + 1, totalscore = totalscore + new.score_value, battlescore = battlescore + new.score_value
		WHERE playerid = new.perpid;
	when 'frienddmg' then
		UPDATE playersum 
		SET teamdmg = teamdmg + 1, totalscore = totalscore + new.score_value, battlescore = battlescore + new.score_value
		WHERE playerid = new.perpid;
	when 'vehkill' then
		UPDATE playersum 
		SET killed_vehicles = killed_vehicles + 1, totalscore = totalscore + new.score_value, battlescore = battlescore + new.score_value
		WHERE playerid = new.perpid;
	when 'assist' then
		UPDATE playersum
		SET killassist = killassist + 1, totalscore = totalscore + new.score_value, battlescore = battlescore + new.score_value
		WHERE playerid = new.perpid;
	when 'vehtk' then
		UPDATE playersum 
		SET tked_vehicles = tked_vehicles + 1, totalscore = totalscore + new.score_value, battlescore = battlescore + new.score_value
		WHERE playerid = new.perpid;
	ELSE RAISE EXCEPTION 'Unknown (unimplemented?) Kill type.';
	end case;
	
	IF found THEN EXIT perp; END IF;
	insert into playersum (playerid) values (new.perpid);
		-- unsafe if another source is inserting at the same time
		-- such as one of them being delayed, or done far after the fact.
END LOOP;
return new;
end;
$$;


ALTER FUNCTION raw.killevent_after_insert() OWNER TO bstats_auto;

--
-- Name: killevent_filterbug(); Type: FUNCTION; Schema: raw; Owner: mahuja
--

CREATE FUNCTION killevent_filterbug() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
begin
IF new.distance > 1000000 THEN 
	new.score_value = 20;
	new.distance = NULL;
	new.victim_position = NULL;
end if;
return new;
end;
$$;


ALTER FUNCTION raw.killevent_filterbug() OWNER TO mahuja;

--
-- Name: playersession_after_insert(); Type: FUNCTION; Schema: raw; Owner: bstats_auto
--

CREATE FUNCTION playersession_after_insert() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
begin
LOOP
	-- first try to update the key
	UPDATE playername 
		SET last_seen = current_timestamp 
		WHERE playerid = new.uid AND name = new.name;
	IF found THEN
		RETURN new;
	END IF;
	-- not there, so try to insert the key
	-- if someone else inserts the same key concurrently,
	-- we could get a unique-key failure
	BEGIN
		INSERT INTO playername(playerid,name)
			VALUES (new.uid, new.name);
		RETURN new;
	EXCEPTION WHEN unique_violation THEN
		-- do nothing, and loop to try the UPDATE again
	END;
END LOOP;
return new;
end;
$$;


ALTER FUNCTION raw.playersession_after_insert() OWNER TO bstats_auto;

--
-- Name: playersession_after_insert_multisafe(); Type: FUNCTION; Schema: raw; Owner: bstats_auto
--

CREATE FUNCTION playersession_after_insert_multisafe() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
begin
LOOP
	-- first try to update the key
	UPDATE playername 
		SET last_seen = current_timestamp 
		WHERE playerid = new.uid AND name = new.name;
	IF found THEN
		RETURN new;
	END IF;
	-- not there, so try to insert the key
	-- if someone else inserts the same key concurrently,
	-- we could get a unique-key failure
	BEGIN
		INSERT INTO playername(playerid,name)
			VALUES (new.uid, new.name);
		RETURN new;
	EXCEPTION WHEN unique_violation THEN
		-- do nothing, and loop to try the UPDATE again
	END;
END LOOP;
return new;
end;
$$;


ALTER FUNCTION raw.playersession_after_insert_multisafe() OWNER TO bstats_auto;

--
-- Name: pointevent_after_insert(); Type: FUNCTION; Schema: raw; Owner: bstats_auto
--

CREATE FUNCTION pointevent_after_insert() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
begin  
UPDATE playersum 
SET totalscore = totalscore + new.score_value, otherscore = otherscore + new.score_value
WHERE playerid = new.victimid;

IF not found THEN 
	insert into playersum (playerid, totalscore, otherscore) values (new.victimid, new.score_value, new.score_value);
END IF;
-- unsafe if another source is inserting at the same time
-- such as one of them being delayed by whatever.
return new;
end;
$$;


ALTER FUNCTION raw.pointevent_after_insert() OWNER TO bstats_auto;

--
-- Name: session_servername(); Type: FUNCTION; Schema: raw; Owner: mahuja
--

CREATE FUNCTION session_servername() RETURNS trigger
    LANGUAGE plpgsql COST 1
    AS $$begin
new.server = current_user;
return new;
end$$;


ALTER FUNCTION raw.session_servername() OWNER TO mahuja;

--
-- Name: weaponstats_cook(); Type: FUNCTION; Schema: raw; Owner: bstats_auto
--

CREATE FUNCTION weaponstats_cook() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$begin
if TG_OP='INSERT' then
  insert into cooked.weaponstats_sum (player, "class", totalseconds, fired, vehiclehits, headhits, bodyhits, leghits, armhits)
  values ( new.player, new.class,
	new.totalseconds,
	new.fired,
	new.vehiclehits,
	new.headhits,
	new.bodyhits,
	new.leghits,
	new.armhits);
  return null;
end if;
if TG_OP='UPDATE' then
  insert into cooked.weaponstats_sum (player, "class", totalseconds, fired, vehiclehits, headhits, bodyhits, leghits, armhits)
  values ( new.player, new.class,
	new.totalseconds - old.totalseconds,
	new.fired - old.fired,
	new.vehiclehits - old.vehiclehits,
	new.headhits - old.headhits,
	new.bodyhits - old.bodyhits,
	new.leghits - old.leghits,
	new.armhits - old.armhits);
  return null;
end if;
if TG_OP='DELETE' then
  insert into cooked.weaponstats_sum (player, "class", totalseconds, fired, vehiclehits, headhits, bodyhits, leghits, armhits)
  values ( new.player, new.class,
	- old.totalseconds,
	- old.fired,
	- old.vehiclehits,
	- old.headhits,
	- old.bodyhits,
	- old.leghits,
	- old.armhits);
  return null;
end if;

end $$;


ALTER FUNCTION raw.weaponstats_cook() OWNER TO bstats_auto;

--
-- Name: weaponstats_upsert(); Type: FUNCTION; Schema: raw; Owner: bstats_auto
--

CREATE FUNCTION weaponstats_upsert() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$begin
perform * from weaponstats where session = new.session and player = new.player and "class" = new.class;
if found then
  update weaponstats set 
	totalseconds = totalseconds + new.totalseconds,
	"fired" = "fired" + new.fired,
	vehiclehits = vehiclehits + new.vehiclehits,
	headhits = headhits + new.headhits,
	bodyhits = bodyhits + new.bodyhits,
	leghits = leghits + new.leghits,
	armhits = armhits + new.armhits
	where "session" = new.session and player = new.player and "class" = new.class;
  return null;
end if;
return new;
end $$;


ALTER FUNCTION raw.weaponstats_upsert() OWNER TO bstats_auto;

SET search_path = static, pg_catalog;

--
-- Name: add_unknown_classes(); Type: FUNCTION; Schema: static; Owner: mahuja
--

CREATE FUNCTION add_unknown_classes() RETURNS void
    LANGUAGE sql
    AS $$insert into classnames (classname) 
SELECT distinct class FROM weaponstats_sum
left join static.classnames on class = classnames.classname
WHERE classnames.classname IS NULL
$$;


ALTER FUNCTION static.add_unknown_classes() OWNER TO mahuja;

--
-- Name: FUNCTION add_unknown_classes(); Type: COMMENT; Schema: static; Owner: mahuja
--

COMMENT ON FUNCTION add_unknown_classes() IS 'Fill classnames with entries known/reported through wpninfo but not already registered';


--
-- Name: test_before_insert_upsert(); Type: FUNCTION; Schema: static; Owner: mahuja
--

CREATE FUNCTION test_before_insert_upsert() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
perform * from test where key = new.key;
if found then
  update test set val = new.val where key=new.key;
  return null;
end if;
return new;
end
$$;


ALTER FUNCTION static.test_before_insert_upsert() OWNER TO mahuja;

SET search_path = cooked, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: playername; Type: TABLE; Schema: cooked; Owner: mahuja; Tablespace: 
--

CREATE TABLE playername (
    playerid integer NOT NULL,
    name character varying(50) NOT NULL,
    last_seen timestamp with time zone DEFAULT now() NOT NULL,
    first_seen timestamp with time zone DEFAULT now() NOT NULL
);
ALTER TABLE ONLY playername ALTER COLUMN name SET STORAGE PLAIN;


ALTER TABLE cooked.playername OWNER TO mahuja;

--
-- Name: playername_latest; Type: VIEW; Schema: cooked; Owner: mahuja
--

CREATE VIEW playername_latest AS
    WITH latest AS (SELECT playername.playerid, max(playername.last_seen) AS last_seen FROM playername GROUP BY playername.playerid) SELECT playername.playerid, playername.name, playername.last_seen, playername.first_seen FROM (playername JOIN latest ON (((playername.playerid = latest.playerid) AND (playername.last_seen = latest.last_seen))));


ALTER TABLE cooked.playername_latest OWNER TO mahuja;

SET search_path = raw, pg_catalog;

--
-- Name: killevent; Type: TABLE; Schema: raw; Owner: mahuja; Tablespace: 
--

CREATE TABLE killevent (
    session integer NOT NULL,
    gametime integer NOT NULL,
    victimid integer,
    perpid integer,
    perp_position real[],
    victim_position real[],
    event_type character varying(15) NOT NULL,
    score_value integer,
    distance real,
    weaponclass character varying(40),
    param_int integer,
    param_str character varying(40),
    CONSTRAINT killevent_distance_check CHECK ((distance >= (0)::double precision))
);
ALTER TABLE ONLY killevent ALTER COLUMN perp_position SET STORAGE PLAIN;
ALTER TABLE ONLY killevent ALTER COLUMN victim_position SET STORAGE PLAIN;
ALTER TABLE ONLY killevent ALTER COLUMN event_type SET STORAGE PLAIN;
ALTER TABLE ONLY killevent ALTER COLUMN weaponclass SET STORAGE PLAIN;


ALTER TABLE raw.killevent OWNER TO mahuja;

--
-- Name: session; Type: TABLE; Schema: raw; Owner: mahuja; Tablespace: 
--

CREATE TABLE session (
    sessionid integer NOT NULL,
    server character varying(20) NOT NULL,
    missionname character varying(50) NOT NULL,
    registered timestamp with time zone DEFAULT now() NOT NULL,
    duration integer,
    winner character varying(12)
);
ALTER TABLE ONLY session ALTER COLUMN server SET STORAGE PLAIN;
ALTER TABLE ONLY session ALTER COLUMN missionname SET STORAGE PLAIN;
ALTER TABLE ONLY session ALTER COLUMN winner SET STORAGE PLAIN;


ALTER TABLE raw.session OWNER TO mahuja;

SET search_path = cooked, pg_catalog;

--
-- Name: kills_more_info; Type: VIEW; Schema: cooked; Owner: mahuja
--

CREATE VIEW kills_more_info AS
    SELECT s.registered, killevent.gametime, (s.registered + ((killevent.gametime || ' seconds'::text))::interval) AS "when", killevent.perpid, p.name AS perp_name, killevent.victimid, v.name AS victim_name, killevent.score_value, killevent.event_type, killevent.weaponclass, killevent.perp_position, killevent.victim_position, killevent.distance FROM (((raw.killevent JOIN playername_latest p ON ((killevent.perpid = p.playerid))) JOIN playername_latest v ON ((killevent.victimid = v.playerid))) JOIN raw.session s ON ((killevent.session = s.sessionid)));


ALTER TABLE cooked.kills_more_info OWNER TO mahuja;

--
-- Name: VIEW kills_more_info; Type: COMMENT; Schema: cooked; Owner: mahuja
--

COMMENT ON VIEW kills_more_info IS 'Simplifies the job for an admin looking up a specific set of kills, adding extra info from other tables that helps put it in context.';


--
-- Name: playersum; Type: TABLE; Schema: cooked; Owner: mahuja; Tablespace: 
--

CREATE TABLE playersum (
    playerid integer NOT NULL,
    totalscore integer DEFAULT 0 NOT NULL,
    battlescore integer DEFAULT 0 NOT NULL,
    otherscore integer DEFAULT 0 NOT NULL,
    suicides integer DEFAULT 0 NOT NULL,
    weaponkills integer DEFAULT 0 NOT NULL,
    deaths integer DEFAULT 0 NOT NULL,
    aircrashes integer DEFAULT 0 NOT NULL,
    roadkills integer DEFAULT 0 NOT NULL,
    civcas integer DEFAULT 0 NOT NULL,
    civdmg integer DEFAULT 0 NOT NULL,
    teamkills integer DEFAULT 0 NOT NULL,
    teamdmg integer DEFAULT 0 NOT NULL,
    killed_vehicles integer DEFAULT 0 NOT NULL,
    tked_vehicles integer DEFAULT 0 NOT NULL,
    killassist integer DEFAULT 0 NOT NULL
);


ALTER TABLE cooked.playersum OWNER TO mahuja;

--
-- Name: weaponstats_sum; Type: TABLE; Schema: cooked; Owner: mahuja; Tablespace: 
--

CREATE TABLE weaponstats_sum (
    player integer NOT NULL,
    class character varying(40) NOT NULL,
    totalseconds integer DEFAULT 0 NOT NULL,
    fired integer DEFAULT 0 NOT NULL,
    vehiclehits integer DEFAULT 0 NOT NULL,
    headhits integer DEFAULT 0 NOT NULL,
    bodyhits integer DEFAULT 0 NOT NULL,
    leghits integer DEFAULT 0 NOT NULL,
    armhits integer DEFAULT 0 NOT NULL,
    avgdist real DEFAULT 0 NOT NULL,
    avgcnt integer DEFAULT 0 NOT NULL
);
ALTER TABLE ONLY weaponstats_sum ALTER COLUMN class SET STORAGE PLAIN;


ALTER TABLE cooked.weaponstats_sum OWNER TO mahuja;

SET search_path = queries, pg_catalog;

--
-- Name: page_views_player; Type: TABLE; Schema: queries; Owner: mahuja; Tablespace: 
--

CREATE TABLE page_views_player (
    playerid integer NOT NULL,
    cnt integer DEFAULT 0
);


ALTER TABLE queries.page_views_player OWNER TO mahuja;

--
-- Name: total_time_played; Type: VIEW; Schema: queries; Owner: mahuja
--

CREATE VIEW total_time_played AS
    SELECT weaponstats_sum.player, ((sum(weaponstats_sum.totalseconds) || ' seconds'::text))::interval AS totaltime, sum(weaponstats_sum.totalseconds) AS totalseconds FROM cooked.weaponstats_sum GROUP BY weaponstats_sum.player;


ALTER TABLE queries.total_time_played OWNER TO mahuja;

SET search_path = raw, pg_catalog;

--
-- Name: pointevent; Type: TABLE; Schema: raw; Owner: mahuja; Tablespace: 
--

CREATE TABLE pointevent (
    session integer NOT NULL,
    gametime integer NOT NULL,
    playerid integer NOT NULL,
    event_type character varying(15) NOT NULL,
    score_value integer,
    param_int integer,
    param_real real,
    param_text character varying(50),
    playerpos real[]
);
ALTER TABLE ONLY pointevent ALTER COLUMN playerpos SET STORAGE PLAIN;


ALTER TABLE raw.pointevent OWNER TO mahuja;

--
-- Name: session_sessionid_seq; Type: SEQUENCE; Schema: raw; Owner: mahuja
--

CREATE SEQUENCE session_sessionid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE raw.session_sessionid_seq OWNER TO mahuja;

--
-- Name: session_sessionid_seq; Type: SEQUENCE OWNED BY; Schema: raw; Owner: mahuja
--

ALTER SEQUENCE session_sessionid_seq OWNED BY session.sessionid;


--
-- Name: sessionplayer; Type: TABLE; Schema: raw; Owner: mahuja; Tablespace: 
--

CREATE TABLE sessionplayer (
    session integer NOT NULL,
    uid integer NOT NULL,
    name character varying(50) NOT NULL,
    start integer NOT NULL,
    "end" integer,
    registered timestamp with time zone DEFAULT now(),
    side character varying(10),
    rowid integer NOT NULL
);
ALTER TABLE ONLY sessionplayer ALTER COLUMN name SET STORAGE PLAIN;
ALTER TABLE ONLY sessionplayer ALTER COLUMN side SET STORAGE PLAIN;


ALTER TABLE raw.sessionplayer OWNER TO mahuja;

--
-- Name: sessionplayer_rowid_seq; Type: SEQUENCE; Schema: raw; Owner: mahuja
--

CREATE SEQUENCE sessionplayer_rowid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE raw.sessionplayer_rowid_seq OWNER TO mahuja;

--
-- Name: sessionplayer_rowid_seq; Type: SEQUENCE OWNED BY; Schema: raw; Owner: mahuja
--

ALTER SEQUENCE sessionplayer_rowid_seq OWNED BY sessionplayer.rowid;


--
-- Name: weaponstats; Type: TABLE; Schema: raw; Owner: mahuja; Tablespace: 
--

CREATE TABLE weaponstats (
    session integer NOT NULL,
    player integer NOT NULL,
    class character varying(40) NOT NULL,
    totalseconds integer DEFAULT 0,
    fired integer DEFAULT 0,
    vehiclehits integer DEFAULT 0,
    headhits integer DEFAULT 0,
    bodyhits integer DEFAULT 0,
    leghits integer DEFAULT 0,
    armhits integer DEFAULT 0
);


ALTER TABLE raw.weaponstats OWNER TO mahuja;

SET search_path = static, pg_catalog;

--
-- Name: classgroups; Type: TABLE; Schema: static; Owner: mahuja; Tablespace: 
--

CREATE TABLE classgroups (
    groupname character varying(40) NOT NULL,
    categories character varying(40)[],
    vorder smallint,
    worder smallint
);


ALTER TABLE static.classgroups OWNER TO mahuja;

--
-- Name: classnames; Type: TABLE; Schema: static; Owner: mahuja; Tablespace: 
--

CREATE TABLE classnames (
    classname character varying(40) NOT NULL,
    displayname character varying(40),
    vehiclecategory character varying(20),
    weaponcategory character varying(20),
    CONSTRAINT either_weapon_or_vehicle CHECK ((NOT ((weaponcategory IS NOT NULL) AND (vehiclecategory IS NOT NULL))))
);


ALTER TABLE static.classnames OWNER TO mahuja;

SET search_path = raw, pg_catalog;

--
-- Name: sessionid; Type: DEFAULT; Schema: raw; Owner: mahuja
--

ALTER TABLE ONLY session ALTER COLUMN sessionid SET DEFAULT nextval('session_sessionid_seq'::regclass);


--
-- Name: rowid; Type: DEFAULT; Schema: raw; Owner: mahuja
--

ALTER TABLE ONLY sessionplayer ALTER COLUMN rowid SET DEFAULT nextval('sessionplayer_rowid_seq'::regclass);


SET search_path = cooked, pg_catalog;

--
-- Name: playername_pkey; Type: CONSTRAINT; Schema: cooked; Owner: mahuja; Tablespace: 
--

ALTER TABLE ONLY playername
    ADD CONSTRAINT playername_pkey PRIMARY KEY (playerid, name);


--
-- Name: playersum_pkey; Type: CONSTRAINT; Schema: cooked; Owner: mahuja; Tablespace: 
--

ALTER TABLE ONLY playersum
    ADD CONSTRAINT playersum_pkey PRIMARY KEY (playerid);


--
-- Name: weaponstats_sum_pkey; Type: CONSTRAINT; Schema: cooked; Owner: mahuja; Tablespace: 
--

ALTER TABLE ONLY weaponstats_sum
    ADD CONSTRAINT weaponstats_sum_pkey PRIMARY KEY (player, class);


SET search_path = queries, pg_catalog;

--
-- Name: page_views_player_pkey; Type: CONSTRAINT; Schema: queries; Owner: mahuja; Tablespace: 
--

ALTER TABLE ONLY page_views_player
    ADD CONSTRAINT page_views_player_pkey PRIMARY KEY (playerid);


SET search_path = raw, pg_catalog;

--
-- Name: session_pkey; Type: CONSTRAINT; Schema: raw; Owner: mahuja; Tablespace: 
--

ALTER TABLE ONLY session
    ADD CONSTRAINT session_pkey PRIMARY KEY (sessionid);


--
-- Name: sessionplayer_pkey; Type: CONSTRAINT; Schema: raw; Owner: mahuja; Tablespace: 
--

ALTER TABLE ONLY sessionplayer
    ADD CONSTRAINT sessionplayer_pkey PRIMARY KEY (rowid);


--
-- Name: sessionplayer_session_uid_start_key; Type: CONSTRAINT; Schema: raw; Owner: mahuja; Tablespace: 
--

ALTER TABLE ONLY sessionplayer
    ADD CONSTRAINT sessionplayer_session_uid_start_key UNIQUE (session, uid, start);


--
-- Name: weaponstats_pkey; Type: CONSTRAINT; Schema: raw; Owner: mahuja; Tablespace: 
--

ALTER TABLE ONLY weaponstats
    ADD CONSTRAINT weaponstats_pkey PRIMARY KEY (session, player, class);


SET search_path = static, pg_catalog;

--
-- Name: classgroups_pkey; Type: CONSTRAINT; Schema: static; Owner: mahuja; Tablespace: 
--

ALTER TABLE ONLY classgroups
    ADD CONSTRAINT classgroups_pkey PRIMARY KEY (groupname);


--
-- Name: classnames_pkey; Type: CONSTRAINT; Schema: static; Owner: mahuja; Tablespace: 
--

ALTER TABLE ONLY classnames
    ADD CONSTRAINT classnames_pkey PRIMARY KEY (classname);


SET search_path = cooked, pg_catalog;

--
-- Name: player_lastseen; Type: INDEX; Schema: cooked; Owner: mahuja; Tablespace: 
--

CREATE INDEX player_lastseen ON playername USING btree (playerid, last_seen);


SET search_path = raw, pg_catalog;

--
-- Name: killed; Type: INDEX; Schema: raw; Owner: mahuja; Tablespace: 
--

CREATE INDEX killed ON killevent USING btree (perpid, victimid);


--
-- Name: killed_by; Type: INDEX; Schema: raw; Owner: mahuja; Tablespace: 
--

CREATE INDEX killed_by ON killevent USING btree (victimid, perpid);


--
-- Name: session_perp; Type: INDEX; Schema: raw; Owner: mahuja; Tablespace: 
--

CREATE INDEX session_perp ON killevent USING btree (session, perpid);


SET search_path = cooked, pg_catalog;

--
-- Name: playername_upsert; Type: TRIGGER; Schema: cooked; Owner: mahuja
--

CREATE TRIGGER playername_upsert BEFORE INSERT ON playername FOR EACH ROW EXECUTE PROCEDURE playername_upsert();


--
-- Name: weaponstats_sum_upsert; Type: TRIGGER; Schema: cooked; Owner: mahuja
--

CREATE TRIGGER weaponstats_sum_upsert BEFORE INSERT ON weaponstats_sum FOR EACH ROW EXECUTE PROCEDURE weaponstats_sum_upsert();


SET search_path = raw, pg_catalog;

--
-- Name: filter_10Gm_bug; Type: TRIGGER; Schema: raw; Owner: mahuja
--

CREATE TRIGGER "filter_10Gm_bug" BEFORE INSERT ON killevent FOR EACH ROW EXECUTE PROCEDURE killevent_filterbug();


--
-- Name: killevent_cook_delete; Type: TRIGGER; Schema: raw; Owner: mahuja
--

CREATE TRIGGER killevent_cook_delete AFTER DELETE ON killevent FOR EACH ROW EXECUTE PROCEDURE killevent_after_delete();


--
-- Name: killevent_cook_insert; Type: TRIGGER; Schema: raw; Owner: mahuja
--

CREATE TRIGGER killevent_cook_insert AFTER INSERT ON killevent FOR EACH ROW EXECUTE PROCEDURE killevent_after_insert();


--
-- Name: playersum_add; Type: TRIGGER; Schema: raw; Owner: mahuja
--

CREATE TRIGGER playersum_add AFTER INSERT ON pointevent FOR EACH ROW EXECUTE PROCEDURE pointevent_after_insert();


--
-- Name: restrict_server_to_user; Type: TRIGGER; Schema: raw; Owner: mahuja
--

CREATE TRIGGER restrict_server_to_user BEFORE INSERT OR UPDATE ON session FOR EACH ROW EXECUTE PROCEDURE session_servername();


--
-- Name: update_playernames; Type: TRIGGER; Schema: raw; Owner: mahuja
--

CREATE TRIGGER update_playernames AFTER INSERT ON sessionplayer FOR EACH ROW EXECUTE PROCEDURE playersession_after_insert();


--
-- Name: upsert; Type: TRIGGER; Schema: raw; Owner: mahuja
--

CREATE TRIGGER upsert BEFORE INSERT ON weaponstats FOR EACH ROW EXECUTE PROCEDURE weaponstats_upsert();


--
-- Name: weaponstats_cook; Type: TRIGGER; Schema: raw; Owner: mahuja
--

CREATE TRIGGER weaponstats_cook AFTER INSERT OR DELETE OR UPDATE ON weaponstats FOR EACH ROW EXECUTE PROCEDURE weaponstats_cook();


--
-- Name: cooked; Type: ACL; Schema: -; Owner: mahuja
--

REVOKE ALL ON SCHEMA cooked FROM PUBLIC;
REVOKE ALL ON SCHEMA cooked FROM mahuja;
GRANT ALL ON SCHEMA cooked TO mahuja;
GRANT USAGE ON SCHEMA cooked TO bstats_reader;
GRANT USAGE ON SCHEMA cooked TO bstats_admin;
GRANT USAGE ON SCHEMA cooked TO bstats_auto;


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- Name: queries; Type: ACL; Schema: -; Owner: mahuja
--

REVOKE ALL ON SCHEMA queries FROM PUBLIC;
REVOKE ALL ON SCHEMA queries FROM mahuja;
GRANT ALL ON SCHEMA queries TO mahuja;
GRANT USAGE ON SCHEMA queries TO PUBLIC;


--
-- Name: raw; Type: ACL; Schema: -; Owner: mahuja
--

REVOKE ALL ON SCHEMA raw FROM PUBLIC;
REVOKE ALL ON SCHEMA raw FROM mahuja;
GRANT ALL ON SCHEMA raw TO mahuja;
GRANT USAGE ON SCHEMA raw TO bstats_reader;
GRANT USAGE ON SCHEMA raw TO bstats_admin;
GRANT USAGE ON SCHEMA raw TO bstats_servers;
GRANT USAGE ON SCHEMA raw TO bstats_auto;


--
-- Name: static; Type: ACL; Schema: -; Owner: mahuja
--

REVOKE ALL ON SCHEMA static FROM PUBLIC;
REVOKE ALL ON SCHEMA static FROM mahuja;
GRANT ALL ON SCHEMA static TO mahuja;
GRANT USAGE ON SCHEMA static TO PUBLIC;


SET search_path = cooked, pg_catalog;

--
-- Name: recook playersum(); Type: ACL; Schema: cooked; Owner: mahuja
--

REVOKE ALL ON FUNCTION "recook playersum"() FROM PUBLIC;
REVOKE ALL ON FUNCTION "recook playersum"() FROM mahuja;
GRANT ALL ON FUNCTION "recook playersum"() TO mahuja;
GRANT ALL ON FUNCTION "recook playersum"() TO PUBLIC;
GRANT ALL ON FUNCTION "recook playersum"() TO bstats_admin;


--
-- Name: recook weaponstats_sum(); Type: ACL; Schema: cooked; Owner: mahuja
--

REVOKE ALL ON FUNCTION "recook weaponstats_sum"() FROM PUBLIC;
REVOKE ALL ON FUNCTION "recook weaponstats_sum"() FROM mahuja;
GRANT ALL ON FUNCTION "recook weaponstats_sum"() TO mahuja;
GRANT ALL ON FUNCTION "recook weaponstats_sum"() TO PUBLIC;
GRANT ALL ON FUNCTION "recook weaponstats_sum"() TO bstats_admin;


SET search_path = queries, pg_catalog;

--
-- Name: view_page_player(integer); Type: ACL; Schema: queries; Owner: bstats_auto
--

REVOKE ALL ON FUNCTION view_page_player(playerid integer) FROM PUBLIC;
REVOKE ALL ON FUNCTION view_page_player(playerid integer) FROM bstats_auto;
GRANT ALL ON FUNCTION view_page_player(playerid integer) TO bstats_auto;
GRANT ALL ON FUNCTION view_page_player(playerid integer) TO PUBLIC;
GRANT ALL ON FUNCTION view_page_player(playerid integer) TO bstats_reader;


SET search_path = cooked, pg_catalog;

--
-- Name: playername; Type: ACL; Schema: cooked; Owner: mahuja
--

REVOKE ALL ON TABLE playername FROM PUBLIC;
REVOKE ALL ON TABLE playername FROM mahuja;
GRANT ALL ON TABLE playername TO mahuja;
GRANT SELECT,INSERT,UPDATE ON TABLE playername TO bstats_auto;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE playername TO bstats_admin;
GRANT SELECT ON TABLE playername TO bstats_reader;


--
-- Name: playername_latest; Type: ACL; Schema: cooked; Owner: mahuja
--

REVOKE ALL ON TABLE playername_latest FROM PUBLIC;
REVOKE ALL ON TABLE playername_latest FROM mahuja;
GRANT ALL ON TABLE playername_latest TO mahuja;
GRANT SELECT ON TABLE playername_latest TO "all";
GRANT SELECT ON TABLE playername_latest TO bstats_admin;
GRANT SELECT ON TABLE playername_latest TO bstats_reader;


SET search_path = raw, pg_catalog;

--
-- Name: killevent; Type: ACL; Schema: raw; Owner: mahuja
--

REVOKE ALL ON TABLE killevent FROM PUBLIC;
REVOKE ALL ON TABLE killevent FROM mahuja;
GRANT ALL ON TABLE killevent TO mahuja;
GRANT SELECT ON TABLE killevent TO bstats_auto;
GRANT SELECT,INSERT ON TABLE killevent TO bstats_servers;
GRANT SELECT ON TABLE killevent TO bstats_reader;
GRANT SELECT,DELETE ON TABLE killevent TO bstats_admin;


--
-- Name: session; Type: ACL; Schema: raw; Owner: mahuja
--

REVOKE ALL ON TABLE session FROM PUBLIC;
REVOKE ALL ON TABLE session FROM mahuja;
GRANT ALL ON TABLE session TO mahuja;
GRANT SELECT,INSERT,UPDATE ON TABLE session TO bstats_servers;
GRANT SELECT,DELETE,UPDATE ON TABLE session TO bstats_admin;
GRANT SELECT ON TABLE session TO bstats_reader;
GRANT SELECT,UPDATE ON TABLE session TO bstats_auto;


SET search_path = cooked, pg_catalog;

--
-- Name: kills_more_info; Type: ACL; Schema: cooked; Owner: mahuja
--

REVOKE ALL ON TABLE kills_more_info FROM PUBLIC;
REVOKE ALL ON TABLE kills_more_info FROM mahuja;
GRANT ALL ON TABLE kills_more_info TO mahuja;
GRANT SELECT ON TABLE kills_more_info TO bstats_admin;
GRANT SELECT ON TABLE kills_more_info TO bstats_reader;


--
-- Name: playersum; Type: ACL; Schema: cooked; Owner: mahuja
--

REVOKE ALL ON TABLE playersum FROM PUBLIC;
REVOKE ALL ON TABLE playersum FROM mahuja;
GRANT ALL ON TABLE playersum TO mahuja;
GRANT SELECT ON TABLE playersum TO bstats_reader;
GRANT SELECT,INSERT,UPDATE ON TABLE playersum TO bstats_auto;
GRANT SELECT ON TABLE playersum TO bstats_admin;


--
-- Name: weaponstats_sum; Type: ACL; Schema: cooked; Owner: mahuja
--

REVOKE ALL ON TABLE weaponstats_sum FROM PUBLIC;
REVOKE ALL ON TABLE weaponstats_sum FROM mahuja;
GRANT ALL ON TABLE weaponstats_sum TO mahuja;
GRANT SELECT,INSERT,UPDATE ON TABLE weaponstats_sum TO bstats_auto;
GRANT SELECT ON TABLE weaponstats_sum TO bstats_reader;
GRANT SELECT ON TABLE weaponstats_sum TO bstats_admin;


SET search_path = queries, pg_catalog;

--
-- Name: page_views_player; Type: ACL; Schema: queries; Owner: mahuja
--

REVOKE ALL ON TABLE page_views_player FROM PUBLIC;
REVOKE ALL ON TABLE page_views_player FROM mahuja;
GRANT ALL ON TABLE page_views_player TO mahuja;
GRANT SELECT ON TABLE page_views_player TO PUBLIC;
GRANT SELECT,INSERT,UPDATE ON TABLE page_views_player TO bstats_auto;


--
-- Name: total_time_played; Type: ACL; Schema: queries; Owner: mahuja
--

REVOKE ALL ON TABLE total_time_played FROM PUBLIC;
REVOKE ALL ON TABLE total_time_played FROM mahuja;
GRANT ALL ON TABLE total_time_played TO mahuja;
GRANT SELECT ON TABLE total_time_played TO PUBLIC;


SET search_path = raw, pg_catalog;

--
-- Name: pointevent; Type: ACL; Schema: raw; Owner: mahuja
--

REVOKE ALL ON TABLE pointevent FROM PUBLIC;
REVOKE ALL ON TABLE pointevent FROM mahuja;
GRANT ALL ON TABLE pointevent TO mahuja;
GRANT INSERT ON TABLE pointevent TO bstats_servers;
GRANT SELECT ON TABLE pointevent TO bstats_reader;
GRANT SELECT ON TABLE pointevent TO bstats_auto;
GRANT SELECT,DELETE ON TABLE pointevent TO bstats_admin;


--
-- Name: session_sessionid_seq; Type: ACL; Schema: raw; Owner: mahuja
--

REVOKE ALL ON SEQUENCE session_sessionid_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE session_sessionid_seq FROM mahuja;
GRANT ALL ON SEQUENCE session_sessionid_seq TO mahuja;
GRANT ALL ON SEQUENCE session_sessionid_seq TO bstats_servers;


--
-- Name: sessionplayer; Type: ACL; Schema: raw; Owner: mahuja
--

REVOKE ALL ON TABLE sessionplayer FROM PUBLIC;
REVOKE ALL ON TABLE sessionplayer FROM mahuja;
GRANT ALL ON TABLE sessionplayer TO mahuja;
GRANT SELECT,DELETE,UPDATE ON TABLE sessionplayer TO bstats_admin;
GRANT SELECT ON TABLE sessionplayer TO bstats_auto;
GRANT SELECT ON TABLE sessionplayer TO bstats_reader;
GRANT SELECT,INSERT,UPDATE ON TABLE sessionplayer TO bstats_servers;


--
-- Name: sessionplayer_rowid_seq; Type: ACL; Schema: raw; Owner: mahuja
--

REVOKE ALL ON SEQUENCE sessionplayer_rowid_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE sessionplayer_rowid_seq FROM mahuja;
GRANT ALL ON SEQUENCE sessionplayer_rowid_seq TO mahuja;
GRANT ALL ON SEQUENCE sessionplayer_rowid_seq TO bstats_servers;


--
-- Name: weaponstats; Type: ACL; Schema: raw; Owner: mahuja
--

REVOKE ALL ON TABLE weaponstats FROM PUBLIC;
REVOKE ALL ON TABLE weaponstats FROM mahuja;
GRANT ALL ON TABLE weaponstats TO mahuja;
GRANT SELECT,INSERT,UPDATE ON TABLE weaponstats TO bstats_servers;
GRANT SELECT ON TABLE weaponstats TO bstats_reader;
GRANT SELECT ON TABLE weaponstats TO bstats_auto;
GRANT SELECT,DELETE ON TABLE weaponstats TO bstats_admin;


SET search_path = static, pg_catalog;

--
-- Name: classgroups; Type: ACL; Schema: static; Owner: mahuja
--

REVOKE ALL ON TABLE classgroups FROM PUBLIC;
REVOKE ALL ON TABLE classgroups FROM mahuja;
GRANT ALL ON TABLE classgroups TO mahuja;
GRANT SELECT ON TABLE classgroups TO PUBLIC;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE classgroups TO bstats_admin;


--
-- Name: classnames; Type: ACL; Schema: static; Owner: mahuja
--

REVOKE ALL ON TABLE classnames FROM PUBLIC;
REVOKE ALL ON TABLE classnames FROM mahuja;
GRANT ALL ON TABLE classnames TO mahuja;
GRANT SELECT ON TABLE classnames TO PUBLIC;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE classnames TO bstats_admin;


SET search_path = cooked, pg_catalog;

--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: cooked; Owner: mahuja
--

ALTER DEFAULT PRIVILEGES FOR ROLE mahuja IN SCHEMA cooked REVOKE ALL ON FUNCTIONS  FROM PUBLIC;
ALTER DEFAULT PRIVILEGES FOR ROLE mahuja IN SCHEMA cooked REVOKE ALL ON FUNCTIONS  FROM mahuja;
ALTER DEFAULT PRIVILEGES FOR ROLE mahuja IN SCHEMA cooked GRANT ALL ON FUNCTIONS  TO bstats_admin;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: cooked; Owner: mahuja
--

ALTER DEFAULT PRIVILEGES FOR ROLE mahuja IN SCHEMA cooked REVOKE ALL ON TABLES  FROM PUBLIC;
ALTER DEFAULT PRIVILEGES FOR ROLE mahuja IN SCHEMA cooked REVOKE ALL ON TABLES  FROM mahuja;
ALTER DEFAULT PRIVILEGES FOR ROLE mahuja IN SCHEMA cooked GRANT SELECT ON TABLES  TO bstats_admin;
ALTER DEFAULT PRIVILEGES FOR ROLE mahuja IN SCHEMA cooked GRANT SELECT ON TABLES  TO bstats_reader;


SET search_path = queries, pg_catalog;

--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: queries; Owner: mahuja
--

ALTER DEFAULT PRIVILEGES FOR ROLE mahuja IN SCHEMA queries REVOKE ALL ON FUNCTIONS  FROM PUBLIC;
ALTER DEFAULT PRIVILEGES FOR ROLE mahuja IN SCHEMA queries REVOKE ALL ON FUNCTIONS  FROM mahuja;
ALTER DEFAULT PRIVILEGES FOR ROLE mahuja IN SCHEMA queries GRANT ALL ON FUNCTIONS  TO bstats_reader;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: queries; Owner: mahuja
--

ALTER DEFAULT PRIVILEGES FOR ROLE mahuja IN SCHEMA queries REVOKE ALL ON TABLES  FROM PUBLIC;
ALTER DEFAULT PRIVILEGES FOR ROLE mahuja IN SCHEMA queries REVOKE ALL ON TABLES  FROM mahuja;
ALTER DEFAULT PRIVILEGES FOR ROLE mahuja IN SCHEMA queries GRANT SELECT ON TABLES  TO PUBLIC;


SET search_path = raw, pg_catalog;

--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: raw; Owner: mahuja
--

ALTER DEFAULT PRIVILEGES FOR ROLE mahuja IN SCHEMA raw REVOKE ALL ON TABLES  FROM PUBLIC;
ALTER DEFAULT PRIVILEGES FOR ROLE mahuja IN SCHEMA raw REVOKE ALL ON TABLES  FROM mahuja;
ALTER DEFAULT PRIVILEGES FOR ROLE mahuja IN SCHEMA raw GRANT SELECT,DELETE ON TABLES  TO bstats_admin;
ALTER DEFAULT PRIVILEGES FOR ROLE mahuja IN SCHEMA raw GRANT SELECT,DELETE,UPDATE ON TABLES  TO bstats_auto;
ALTER DEFAULT PRIVILEGES FOR ROLE mahuja IN SCHEMA raw GRANT SELECT ON TABLES  TO bstats_reader;
ALTER DEFAULT PRIVILEGES FOR ROLE mahuja IN SCHEMA raw GRANT INSERT ON TABLES  TO bstats_servers;


SET search_path = static, pg_catalog;

--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: static; Owner: mahuja
--

ALTER DEFAULT PRIVILEGES FOR ROLE mahuja IN SCHEMA static REVOKE ALL ON TABLES  FROM PUBLIC;
ALTER DEFAULT PRIVILEGES FOR ROLE mahuja IN SCHEMA static REVOKE ALL ON TABLES  FROM mahuja;
ALTER DEFAULT PRIVILEGES FOR ROLE mahuja IN SCHEMA static GRANT SELECT ON TABLES  TO PUBLIC;
ALTER DEFAULT PRIVILEGES FOR ROLE mahuja IN SCHEMA static GRANT SELECT,INSERT,DELETE,UPDATE ON TABLES  TO bstats_admin;


--
-- PostgreSQL database dump complete
--

