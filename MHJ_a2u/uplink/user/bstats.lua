--[[
	SPY battlestats, uplink module.

	This version will do two things, depending on config settings.
	- Store to a local sqlite database
	- Store to master stats server
	- Dump sql commands used to a file
	
	TODO:
	Check that many of my assumptions work. 
		- In particular how I retrieve session IDs.
	Transport points
	Medic points
	Repair points
	ROE flags logging
]]
loadprogress ("Loading bstats");
errlog("Bstats module version $Revision: 91 $");
local _G = _G;

-- silence errors for non-implemented features
function secenv.bstats_roeflag (uid, time) end
----

local bstats_api_version = 1;
local bstats_ignore_session = true;

local localdb, masterdb, sqldump;
local localsession, mastersession, gamesession;
local servername = bstats_master_servername or "local";

if (bstats_sqldump) then 
	local err
	sqldump, err = io.open (bstats_sqldump, "w+")
end
if (bstats_sqlitedb) then
	require ("luasql.sqlite3")
	local env = assert(luasql.sqlite3)	-- missing ()?
	localdb = assert(env:connect(bstats_sqlitedb))
	-- TODO: Tables if not exists
end
if (bstats_master_db) then
	require ("luasql.postgres")
	local env = assert (luasql.postgres())
	loadprogress ("Bstats: Connecting to master DB as " .. bstats_master_db[2])
	masterdb = assert (env:connect(unpack(bstats_master_db)))
	loadprogress ("Bstats: Connected")
end

local function bstats_sql_assert (sql, returncode, message)
	if returncode then return end;
	error (message .. sql);
end

local function bstats_sql(sql)
	if sqldump then sqldump:write(sql, "\n") end
	if masterdb then bstats_sql_assert(sql, masterdb:execute(sql:format(mastersession))) end
	if localdb then bstats_sql_assert(sql, localdb:execute(sql:format(localsession))) end
end;

local function dbstring(s)
	if (s==nil) then return "NULL" end
	s = tostring(s)
	if masterdb then return "'"..masterdb:escape(s).."'"	-- If both master and local are in effect, differences in their escaping might prove a problem
	elseif localdb then return "'"..localdb:escape(s).."'"
	else	-- Can't imagine why it would ever end up in this section
	--s = s:gsub ("\\'","\\\\'")	-- TODO: This section REALLY needs a review. Especially since it may get used by both sqlite and postgresql.
	s = s:gsub ("\\","\\\\");
	s = s:gsub ("'","\\'")
	return "'"..s.."'"
	end
end
local function dbnumber(n)
	if not n then return "NULL" end
	return tostring(tonumber(n))
end
local function dbarray(a)
	if not a then return "NULL" end
	-- TODO: find out what needs to be done
	-- Keep sql injection in mind
	
	a = tostring(a):gsub('%[',"{"):gsub("%]","}");
	return dbstring(a)
end

local prevINIT = oninit
function onINIT(new_game_session)
	gamesession = new_game_session
	localsession = nil
	mastersession = nil
end


-- Here begins the functions the game will be calling.

function secenv.bstats_newsession (missionname, api_ver, sessionid)
	if mastersession or localsession then errlog ("Attempted extra mission init.") return end
	if api_ver ~= bstats_api_version  then 
		bstats_ignore_session = true;
		errlog("Bstats: Wrong version: " .. missionname)
		return
	end
	bstats_ignore_session = false
	local q = [[INSERT INTO "session" (server, missionname) VALUES (%s, %s) ]];
	q = q:format(dbstring(servername), dbstring(missionname))
	if sqldump then sqldump:write(q, "\n") end
	if localdb then 
		assert(localdb:execute(q))
		local cur = localdb:execute("last_insert_rowid()")
		local val = cur:fetch();
		localsession = val;
	end
	if masterdb then 
		local cur = assert (masterdb:execute(q .. " returning sessionid"))
		local val = cur:fetch();
		mastersession = val;
	end
end

function secenv.bstats_endsession (duration, winner)
	if bstats_ignore_session then return end
	local q = [[UPDATE "session" set duration=%s, winner=%s WHERE sessionid = %%s]]
	q = q:format(dbnumber(duration), dbstring(winner))
	bstats_sql(q)
end

-- These need to be reset for new sessions too
bstats_session_playerlist_local = {}
bstats_session_playerlist_master = {}

function secenv.bstats_newplayer (playerid, side, timestamp, playername)
	if bstats_ignore_session then return end
	local q = [[INSERT INTO "sessionplayer" (uid, name, start, side, session)
	VALUES (%s, %s, %s, %s, %%s) ]]
	q = q:format(dbstring(playerid), dbstring(playername), dbnumber(timestamp), dbstring(side))
	if sqldump then sqldump:write(q, "\n") end
	if localdb then 
		assert(localdb:execute(q:format(localsession)))
		local cur = localdb:execute("last_insert_rowid()")
		local val = cur:fetch();
		bstats_session_playerlist_local[tonumber(playerid)] = val
	end
	if masterdb then 
		local cur = assert (masterdb:execute(q:format(mastersession) .. " returning rowid"))
		local val = cur:fetch();
		bstats_session_playerlist_master[tonumber(playerid)] = val
	end
end

function secenv.bstats_player_left (playerid, timestamp)
	if bstats_ignore_session then return end
	local q = [[UPDATE "sessionplayer" SET "end"=%s WHERE "rowid" = %s ]] 
	local local_query = q:format(dbnumber(timestamp), dbnumber(bstats_session_playerlist_local[playerid]))
	local master_query = q:format(dbnumber(timestamp), dbnumber(bstats_session_playerlist_master[playerid]))
	if localdb then assert(localdb:execute(local_query)) end
	if masterdb then assert(masterdb:execute(master_query)) end
end

function secenv.bstats_suicide (killeduid, timestamp, score, killedpos)
	if bstats_ignore_session then return end
	local q = [[INSERT INTO "killevent" (victimid, gametime, score_value, victim_position, event_type, session)
	VALUES (%s, %s, %s, %s, 'suicide', %%s)]]
	q = q:format(dbstring(killeduid), dbnumber(timestamp), dbnumber(score), dbarray(killedpos))
	bstats_sql(q)
end

function secenv.bstats_death (killeduid, timestamp, score, killedpos)
	if bstats_ignore_session then return end
	local q = [[INSERT INTO "killevent" (victimid, gametime, score_value, victim_position, event_type, session)
	VALUES (%s, %s, %s, %s, 'death', %%s)]]
	q = q:format(dbstring(killeduid), dbnumber(timestamp), dbnumber(score), dbarray(killedpos))
	bstats_sql(q)
end

function secenv.bstats_accrash (killeduid, timestamp, passengers, score, killedpos)
	if bstats_ignore_session then return end
	local q = [[INSERT INTO "killevent" (victimid, gametime, param_int, score_value, victim_position, event_type, session)
	VALUES (%s, %s, %s, %s, %s, 'accrash', %%s)]]
	q = q:format(dbstring(killeduid),dbnumber(timestamp),dbnumber(passengers), dbnumber(score), dbarray(killedpos))
	bstats_sql(q)
end

function secenv.bstats_kill (killeduid, killeruid, timestamp, weapon, score, distance, killedpos, killerpos)
	if bstats_ignore_session then return end
	local q = [[INSERT INTO "killevent" 
	(weaponclass, distance, score_value, victim_position, perp_position, perpid, victimid, gametime,
	event_type, session)
	VALUES 
	(%s, %s, %s, %s, %s, %s, %s, %s, 'kill', %%s) ]]
	q = q:format(
		dbstring(weapon),
		dbnumber(distance),
		dbnumber(score),
		dbarray (killedpos),
		dbarray (killerpos),
		dbstring(killeruid),
		dbstring(killeduid),
		dbnumber(timestamp)
	)
	bstats_sql(q)
end

function secenv.bstats_vehkill (vehicletype, killeruid, timestamp, weapon, score, distance, killerpos, targetpos)
	if bstats_ignore_session then return end
	local q = [[INSERT INTO "killevent"
	(weaponclass, distance, score_value, victim_position, perp_position, perpid, gametime, param_str, event_type, session)
	VALUES (%s, %s, %s, %s, %s, %s, %s, %s, 'vehkill', %%s) ]]
	q = q:format(
		dbstring(weapon),
		dbnumber(distance),
		dbnumber(score),
		dbarray (killedpos),
		dbarray (killerpos),
		dbstring(killeruid),
		dbnumber(timestamp),
		dbstring(vehicletype)
	)
	bstats_sql(q)
end

function secenv.bstats_vehtk (vehicletype, killeruid, timestamp, weapon, score, distance, killerpos, targetpos)
	if bstats_ignore_session then return end
	local q = [[INSERT INTO "killevent"
	(weaponclass, distance, score_value, victim_position, perp_position, perpid, gametime, param_str, event_type, session)
	VALUES (%s, %s, %s, %s, %s, %s, %s, %s, 'vehtk', %%s) ]]
	q = q:format(
		dbstring(weapon),
		dbnumber(distance),
		dbnumber(score),
		dbarray (killedpos),
		dbarray (killerpos),
		dbstring(killeruid),
		dbnumber(timestamp),
		dbstring(vehicletype)
	)
	bstats_sql(q)
end

function secenv.bstats_killassist (uid, timestamp, score)
	if bstats_ignore_session then return end
	local q = [[INSERT INTO "killevent" (perpid, gametime, score_value, event_type, session)
	VALUES (%s, %s, %s, 'assist', %%s) ]]
	q = q:format(dbstring(uid),dbnumber(timestamp), dbnumber(score))
	bstats_sql(q)
end

function secenv.bstats_tk (killeduid, killeruid, timestamp, weapon, score, distance, killedpos, killerpos)
	if bstats_ignore_session then return end
	local q = [[INSERT INTO "killevent" 
	(weaponclass, distance, score_value, victim_position, perp_position, perpid, victimid, gametime,
	event_type, session)
	VALUES 
	(%s, %s, %s, %s, %s, %s, %s, %s, 'tk', %%s) ]]
	q = q:format(
		dbstring(weapon),
		dbnumber(distance),
		dbnumber(score),
		dbarray (killedpos),
		dbarray (killerpos),
		dbstring(killeruid),
		dbstring(killeduid),
		dbnumber(timestamp)
	)
	bstats_sql(q)
end

function secenv.bstats_roadkill (killeduid, killeruid, timestamp, vehicle, score, killedpos)
	if bstats_ignore_session then return end
	local q = [[INSERT INTO "killevent"
	(victimid, perpid, gametime, weaponclass, score_value, victim_position, event_type, session)
	VALUES (%s, %s, %s, %s, %s, %s, 'roadkill', %%s) ]]
	q = q:format(
		dbstring(killeduid), 
		dbstring(killeruid), 
		dbnumber(timestamp), 
		dbstring(vehicle), 
		dbnumber(score), 
		dbarray(killedpos)
	)
	bstats_sql(q)
end

function secenv.bstats_civcas (killeduid, killeruid, timestamp, weapon, score, distance, killedpos, killerpos)
	if bstats_ignore_session then return end
	local q = [[INSERT INTO "killevent" 
	(weaponclass, distance, score_value, victim_position, perp_position, perpid, victimid, gametime,
	event_type, session)
	VALUES 
	(%s, %s, %s, %s, %s, %s, %s, %s, 'civcas', %%s) ]]
	q = q:format(
		dbstring(weapon),
		dbnumber(distance),
		dbnumber(score),
		dbarray (killedpos),
		dbarray (killerpos),
		dbstring(killeruid),
		dbstring(killeduid),
		dbnumber(timestamp)
	)
	bstats_sql(q)
end

function secenv.bstats_civdmg (killeduid, killeruid, timestamp, weapon, score, distance, killedpos, killerpos)
	if bstats_ignore_session then return end
	local q = [[INSERT INTO "killevent" 
	(weaponclass, distance, score_value, victim_position, perp_position, perpid, victimid, gametime,
	event_type, session)
	VALUES 
	(%s, %s, %s, %s, %s, %s, %s, %s, 'civdmg', %%s) ]]
	q = q:format(
		dbstring(weapon),
		dbnumber(distance),
		dbnumber(score),
		dbarray (killedpos),
		dbarray (killerpos),
		dbstring(killeruid),
		dbstring(killeduid),
		dbnumber(timestamp)
	)
	bstats_sql(q)
end

function secenv.bstats_friendlydmg (killeduid, killeruid, timestamp, weapon, score, distance, killedpos, killerpos)
	if bstats_ignore_session then return end
	local q = [[INSERT INTO "killevent" 
	(weaponclass, distance, score_value, victim_position, perp_position, perpid, victimid, gametime,
	event_type, session)
	VALUES 
	(%s, %s, %s, %s, %s, %s, %s, %s, 'frienddmg', %%s) ]]
	q = q:format(
		dbstring(weapon),
		dbnumber(distance),
		dbnumber(score),
		dbarray (killedpos),
		dbarray (killerpos),
		dbstring(killeruid),
		dbstring(killeduid),
		dbnumber(timestamp)
	)
	bstats_sql(q)
end

function secenv.bstats_capture(playerid, timestamp, score, tag)
	if bstats_ignore_session then return end
	local q = [[INSERT INTO "pointevent" (playerid, gametime, score_value, param_text, event_type, session)
	VALUES (%s, %s, %s, %s, 'capture', %%s)]]
	q = q:format(dbstring(playerid), dbnumber(timestamp), dbnumber(score), dbstring(tag))
	bstats_sql(q)
end

--bstats_vehinfo (uid, weapon, timestamp, weapon time, total shots, head hits, body hits, arm hits, leg hits, vehicle hits)
function secenv.bstats_wpninfo(playerid, class, timestamp, seconds, fired, headhits, bodyhits, armhits, leghits, vehiclehits)
	if bstats_ignore_session then return end
	local q = [[INSERT INTO "raw".weaponstats (player, "class", totalseconds, fired, vehiclehits, headhits, bodyhits, leghits, armhits, session)
	VALUES
	( %s, %s, %s, %s, %s, %s, %s, %s, %s, %%s)	]]
	q = q:format(
		dbstring(playerid),
		dbstring(class),
		-- ignoring timestamp
		dbnumber(seconds),
		dbnumber(fired),
		dbnumber(vehiclehits),
		dbnumber(headhits),
		dbnumber(bodyhits),
		dbnumber(leghits),
		dbnumber(armhits)
	)
	bstats_sql(q)
end
secenv.bstats_vehinfo = secenv.bstats_wpninfo

function secenv.bstats_trans(uid,timestamp,vehicle,distance,score)
	if bstats_ignore_session then return end
	local q = [[INSERT INTO "pointevent" (playerid, gametime, param_text, param_real, score_value, event_type, session) 
	VALUES (%s, %s, %s, %s, %s, 'trans', %%s);]]
	q = string.format(q,dbstring(uid), dbnumber(timestamp), dbstring (vehicle), dbstring(distance), dbnumber(score))
	bstats_sql(q);
end

loadprogress ("Bstats Loaded");
