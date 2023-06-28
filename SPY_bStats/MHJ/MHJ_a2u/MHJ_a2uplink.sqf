/***************************************************************************
A2UPLINK
CREATED BY MAHUJA
MAHUJA@MAHUJA.NET
****************************************************************************/

private ["_msg", "_sessionid", "_f"];

if (!isServer) exitWith {};
if (!isNil "uplink_init") exitWith {};	// been run already

uplink_init = false;

uplink_exec = {		// A stub which will hold every call until we're done initializing.

	waitUntil {uplink_init};
	_this spawn uplink_exec;	// At which point it will have been redefined to the proper function.
	// Spawn instead of call, to handle the case where it is called from unscheduled code.
	
};

uplink_error = {

	_msg = "Uplink error: " + str _this;
	diag_log _msg;
	SPY_GAMELOGIC globalChat _msg;
	
};

// This MUST be in sync with the outside app
_filenamebase = "\userconfig\uplink\f%1=%2";

// determine session id
_sessionid = "0";
_f = "x";

while {_f == "x"} do {

	_sessionid = (str (floor (random 1000000)));	// Higher than 2^mantissabits-1 won't help much.
	//if (random 2 >= 1) then { _sessionid=-_sessionid; };	// May have more effect than merely increasing the number
	_f = loadfile format [_filenamebase, _sessionid, 0];	// Will generate rpt error on success case.	
	
};

diag_log text format["#LOGCOMMS INIT %1", _sessionid];

/*
	#LOGCOMMS INIT (int)
	Specifies the unique session identifier which will be included in all filenames.
*/

uplink_readcount = 0;
uplink_readerthread_go = false;	// Leave false in readonly version.

uplink_readerthread = [_filenamebase, _sessionid] spawn {
	if (!uplink_readerthread_go) exitwith {};
	_filename = format [_this select 0, _this select 1, "%1"];
	_i = 0;
	
	while {uplink_readerthread_go} do {
		_file = "";
		_fn = format [_filename,_i];
		
		while {_file==""} do { _file = loadfile _fn; };
		
		try {[] call compile file} 
		catch { diag_log text format ["!UPLINK read loop threw on call! Most likely the callback wasn't handling its error. Session(%1) file(%2)", _this select 1, _i ]; };
		uplink_readcount = _i;
		// publicvariable "uplink_readout";	// For debugging purposes, on servers.
	};
};

/*
	The produced file is responsible for
	A) Sending its own ACK 
	B) Calling the callback, if applicable.
		Callbacks should 
		try { _this = [] call _this; }
		to get their parameters in the usual format; should also catch errors.
		Error callbacks have been removed.
*/

uplink_escapestring = {
	_string = (_this select 0);
	_escape = toarray "\" select 0;
	_needescape = toarray "\""";	// \ " 
	_newstr = [];
	{
		if (_x in _needescape) then { _newstr set [(count _newstr), _escape]; };
		_newstr set [(count _newstr), _x];
	} foreach toarray(_string);
	tostring(_newstr)
};
publicVariable "uplink_escapestring";


uplink_exec = {

	// Optional: (Callback) The name of a valid function.
	_luacode = (_this select 0);
	_callback = (_this select 1);
	
	// MISSION IS NOT VALID
	if ((!(SPY_bStats_ranked))) exitWith {};
	
	// Lua code to be interpreted outside. Convenience functions like sql() will exist.
	if ((typename _luacode != "STRING")) exitWith { "LUACODE SENT TO UPLINK WAS NOT A STRING" call uplink_error;};
	if ((isNil ("_callback")) || ((typename _callback != "STRING") && (typename (call compile _callback) != "CODE"))) exitWith {"PROBLEM WITH CALLBACK SENT TO UPLINK" call uplink_error;};	

	if (isNil "_callback") then {_callback = "";};

	_n = (toString [10]);

	diag_log text (format ["#LOGCOMMS BEGIN %1", _callback] + _n + _luacode + _n + "#LOGCOMMS END");
	
};

// SEND NEW SESSION TO A2U FOR LOCAL DB
[format ["bstats_newsession (%1, 1, %2)", (str missionName), _sessionid]] call uplink_exec;

uplink_init = true;

// WAITS UNTIL DEFAULT A2U MODE IS SET AND BROADCASTS CURRENT A2U MODE
waitUntil {(!(isNil {SPY_GAMELOGIC getVariable "MHJ_A2U_MODE"}))};
SPY_GAMELOGIC setVariable ["MHJ_A2U_MODE", ["RUNNING", "RANKED OFFICIAL"], true];
