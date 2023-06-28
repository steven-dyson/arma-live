/***************************************************************************
A2UPLINK
CREATED BY MAHUJA
****************************************************************************/
if (!isServer) exitWith {};
if (!isNil "uplink_init") exitWith {};	// been run already
uplink_init = false;

// Settings
uplink_default_read_delay = 10;
uplink_filenamebase = "\userconfig\uplink\f";	// MUST match a2u config

// And allow the server admin to override them
0 execvm "\userconfig\a2u_settings.sqf";

// Convenience functions
uplink_error = {
	_msg = "Uplink error: " + str _this;
	diag_log _msg;
};
uplink_escapestring = {
	private "_string";
	if (typename _this == "ARRAY") then {_string = _this select 0;} else { _string = _this; };
	assert {typename _string == "STRING";};
	
	_escape = toarray "\" select 0;
	_needescape = toarray "\""";	// Meaning \ and " 
	_newstr = [];
	{
		if (_x in _needescape) then { _newstr set [(count _newstr), _escape]; };
		_newstr set [(count _newstr), _x];
	} foreach toarray(_string);
	tostring(_newstr)
};

// determine session id
private ["_f"];
uplink_sessionid = "0";
_f = "x";
while {_f != ""} do {
	// Higher than 2^mantissabits-1 won't help much.
	// If this goes into xe+y mode, we might get screwed.
	uplink_sessionid = (str (floor (random 1000000)));
	_f = loadfile (uplink_filenamebase + uplink_sessionid + ".0");	// Will generate rpt error on success case.	
};
// Notify a2u of the new session, and the session id
diag_log text format["#LOGCOMMS INIT %1", uplink_sessionid];

uplink_exec = {
	private "_luacode";
	if (typename _this == "ARRAY") then {_luacode = _this select 0;} else {_luacode = _this;};
	if ((typename _luacode != "STRING")) exitWith { "LUACODE SENT TO UPLINK WAS NOT A STRING" call uplink_error;};
	_n = tostring [10];
	diag_log text ("#LOGCOMMS BEGIN" + _n + _luacode + _n + "#LOGCOMMS END");
};
uplink_readcount = 1;
uplink_exec_return = {
	private ["_luacode","_delay"];
	_delay = uplink_default_read_delay;
	if (typename _this == "ARRAY") then {
		_luacode = _this select 0; 
		if (count _this>1) then {_delay = _this select 1;};
	} else {_luacode = _this;};
	if ((typename _luacode != "STRING")) exitWith { "LUACODE SENT TO UPLINK WAS NOT A STRING" call uplink_error;};
	
	// Determine file number
	_filenumber = uplink_readcount;
	uplink_readcount = uplink_readcount+1;
	// Above is assumed safe from race conditions because of the biiig script experiment
	
	_n = tostring [10];
	diag_log text (format ["#LOGCOMMS BEGIN %1", _filenumber] + _n + _luacode + _n + "#LOGCOMMS END");

	sleep _delay;
	//return
	0 call compile loadfile (uplink_filenamebase + uplink_sessionid + "." + str _filenumber)
};
uplink_exec_callback = {	// You want to use spawn for callback
	_this spawn (_this call uplink_exec_return);
};

uplink_init = true;

// Bstats stuff
// WAITS UNTIL DEFAULT A2U MODE IS SET AND BROADCASTS CURRENT A2U MODE
if (!isnil "SPY_GAMELOGIC") then {
	[format ["bstats_newsession (%1, 1, %2)", (str missionName), uplink_sessionid]] call uplink_exec;
	waitUntil {(!(isNil {SPY_GAMELOGIC getVariable "MHJ_A2U_MODE"}))};
	SPY_GAMELOGIC setVariable ["MHJ_A2U_MODE", ["RUNNING", "RANKED UN-OFFICIAL"], true];
};
