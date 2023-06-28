/*
	Author: Spyder (spyder@armalive.com)

	Description:
	Initialize

	Parameter(s):
		NONE

	Returns:
	BOOL
*/

private ["_serverSettingsValues", "_serverSettings", "_missionSettingsValues", "_missionSettings", "_initAI"];

// bStats Version
SPY_bStats_version = "1.1.6";
publicVariable "SPY_bStats_version";

// Server settings
_serverSettingsValues = 
[
    #include "\userconfig\SPY\SPY_bStats_settings_s.txt"
];

_serverSettings = [_serverSettingsValues] execVM "\userconfig\SPY\system\SPY_settingsProcess.sqf";

waitUntil { sleep 0.1; scriptDone _serverSettings };

// Mission settings
if ((SPY_bStats_allowMissionOverride)) then 
{
    _missionSettingsValues = 
	[
        #include "SPY_bStats_settings_s.txt"
    ];

    _missionSettings = [_missionSettingsValues] execVM "\userconfig\SPY\system\SPY_settingsProcess.sqf";
	
    waitUntil { sleep 0.1; scriptDone _missionSettings };
};

// bStats radio channel
SPY_bStats_radioIndex = radioChannelCreate [[0.34, 0.96, 0.13, 0.8], "bStats Radio", "[S]", []];
publicVariable "SPY_bStats_radioIndex";

// Define new mission
"armalive" callExtension format
[
	"newmission1;%1;%2",
	missionName, 
	worldName
];

// Set armalive mode; TODO: connected
if ("armalive" callextension "version" != "") then 
{ 
	SPY_container setVariable ["ARMALIVE_MODE", "ENABLED", true]; 
} 
else 
{
	SPY_container setVariable ["ARMALIVE_MODE", "DISABLED", true]; 
};

// Init variables
SPY_container setVariable ["SPY_bStats_missionInfo", [SPY_bStats_teamOneName, SPY_bStats_teamTwoName], true];
SPY_container setVariable ["SPY_bStats_sideScore", [0, 0, 0, 0], true];
SPY_container setVariable ["SPY_bStats_west_kills", 0, true];
SPY_container setVariable ["SPY_bStats_east_kills", 0, true];
SPY_container setVariable ["SPY_bStats_guer_kills", 0, true];
SPY_container setVariable ["SPY_bStats_west_deaths", 0, true];
SPY_container setVariable ["SPY_bStats_east_deaths", 0, true];
SPY_container setVariable ["SPY_bStats_guer_deaths", 0, true];
SPY_container setVariable ["SPY_bStats_playersWest", [], true];
SPY_container setVariable ["SPY_bStats_playersEast", [], true];

// Monitor balance
// _null = [] execVM "SPY\SPY_bStats\balance\SPY_rankingChange.sqf";

// Init all editor placed AI. This is mainly for testing.
{
	if ((alive _x) && (getPlayerUID _x isEqualTo "")) then 
	{
		_initAI = [_x] spawn SPY_bStats_fnc_initAI;
		doStop _x;
		_x disableAI "MOVE";
	};
} forEach allUnits;

// Init all editor placed vehicles. This is mainly for testing.
{
	if ((alive _x)) then 
	{
		//_initVeh = [_x] spawn SPY_bStats_fnc_initVeh;
	};
} forEach vehicles;

// Debug
_null = [1, "bStats Initialized *Server*", 0, ["SPY Systems", "Debug Log"], true] spawn SPY_core_fnc_bMessage;