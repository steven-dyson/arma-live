--[[
	Prototype implementation for MSO use
]]

local _G = _G	-- If all non-secenv accesses are through this, it will work even with lua 5.2
local sessionid
local sqf_escape = secenv.sqf_escape
local sqf = secenv.sqf

require ("luasql.sqlite3")
local dbenv = luasql.sqlite3()
local db = assert (dbenv:connect("msodb.sqlite3"))

local data = db:execute("select * from staticobjects limit 1")
if not data then 
	local file = assert (io.open("uplink/user/mso_schema.sql"))
	assert(db:execute(file:read("*a")))
	file:close()
end

-- Utility functions for database usage
local function dbstring(s)
	if (s==nil) then return "NULL" end
	s = tostring(s)
	return "'"..db:escape(s).."'"
end
local function dbnumber(n)
	if not n or not tonumber(n) then return "NULL" end
	return tostring(tonumber(n))
end
local function dbassert (sql, returncode, message)
	if returncode then return returncode end;
	error (message .. sql);
end

local store_static_query1 = [[delete from staticobjects where sessionid = %s and objectid = %s;]]
local store_static_query2 = [[
insert into staticobjects values (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s);
]]
function secenv.mso_storestatic (objectid, class, position, vectordir, vectorup, health, weapons, ammo, weaponcargo, ammocargo)
	db:execute("begin transaction");
	
	local q1 = store_static_query1:format (
		dbnumber(sessionid),
		dbstring(objectid))
	local q2 = store_static_query2:format (
		dbnumber(sessionid),
		dbstring(objectid), 
		dbstring(class), 
		dbstring(position), 
		dbstring(vectordir), 
		dbstring(vectorup), 
		dbnumber(health),
		dbstring(weapons),
		dbstring(ammo),
		dbstring(weaponcargo), 
		dbstring(ammocargo)
	);
	dbassert(q1,db:execute(q1))
	dbassert(q2,db:execute(q2))
	db:commit();
end

local function mso_getstatic (def)
	--createVehicle [type, position, markers, placement, special]
	local x = [[
private ["_obj","_weaponcargo","_ammocargo"];
_obj = createvehicle ["%s", [0,0,0], [], 0, "CAN_COLLIDE"];
_obj setposasl %s;
_obj setvectordir %s;
_obj setvectorup %s;
_obj setdamage %d;
removeallweapons _obj;
{_obj addmagazine _x} foreach %s;
{_obj addweapon _x} foreach %s;
clearweaponcargoglobal _obj;
clearmagazinecargoglobal _obj;
_weaponcargo = %s;
for "_i" from 0 to ((count (_weaponcargo select 0)) -1) do {  
	_obj addWeaponCargoGlobal [_weaponcargo select 0 select _i, _weaponcargo select 1 select _i];
};
_ammocargo = %s;
for "_i" from 0 to ((count (_ammocargo select 0)) -1) do {  
	_obj addMagazineCargoGlobal [_ammocargo select 0 select _i, _ammocargo select 1 select _i];
};
format["mso_updatestatic(%d, '%s', %%1);", str netid _obj] call uplink_exec;
]]
	
	x = x:format(def.class, def.position, def.vectordir, def.vectorup, tostring(def.health), def.ammo, def.weapons, def.weaponcargo, def.ammocargo, def.sessionid,def.objectid)

	sqf(x);
end

local getallstatic_query = [[
select * from staticobjects
where sessionid != %s
]]
function secenv.mso_getallstatic ()
	local q = getallstatic_query:format(sessionid)
	local cur = dbassert(q,db:execute(q))
	local t = {}
	local t = cur:fetch(t,"a")
	while t do 
		mso_getstatic(t);
		t = cur:fetch(t,"a")
	end
end

-- updatestatic basically "takes ownership" of an object from a previous session, reassigning its id. This way further updates will not happen to the old object.
local updatestatic_query = [[
update staticobjects set 
	sessionid = %s,
	objectid = %s
where
	sessionid = %s, objectid = %s;
]]
function secenv.mso_updatestatic (oldsessionid, oldobjectid, newobjectid) 
	if (newobjectid == "") then 
		error("mso_updatestatic: Empty new ID");
	end
	local q = updatestatic_query:format(sessionid,newobjectid,oldsessionid,oldobjectid);
end

local prevINIT = onINIT
function onINIT(sid)
	db:execute("vacuum")
	sessionid = sid
	--print ("MSO New session",sid)
	return prevINIT(sid)
end

local prevIdle = onIdle
function onIdle()
	-- Plan is to periodically vacuum db. Every 3600 seconds or so?
	
	return prevIdle()
end
