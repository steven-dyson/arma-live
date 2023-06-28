/***************************************************************************
SPY INIT AND COMPILE (METHOD)
CREATED BY SPYDER
SPYDER@ARMALIVE.COM
***************************************************************************/



/***************************************************************************
INIT: SERVER
****************************************************************************/
private ["_center", "_group", "_settings", "_sync", "_hud", "_kits", "_mpcs", "_fnc", "_objSys"];

if ((!(isDedicated)) && (isServer)) exitWith {};

if ((isServer)) then {

	if ((isNil "JDAM_GAMELOGIC")) then {

		_center = createCenter sideLogic;
		_group = createGroup _center;
		JDAM_GAMELOGIC = _group createUnit ["LOGIC", [0, 0, 0], [], 0, "NONE"];
		publicVariable "JDAM_GAMELOGIC";

	};
	
};
/***************************************************************************
END
****************************************************************************/



/***************************************************************************
INIT SCRIPTS: ALL
****************************************************************************/
// _settings = [] execVM "JDAM\JDAM_settings.sqf";
// waitUntil {scriptDone _settings};
// JDAM_GAMELOGIC globalChat "JDAM: MISSION PARAMETERS SET";

// _sync = [] execVM "JDAM\JDAM_sync.sqf";
// waitUntil {scriptDone _sync};
// JDAM_GAMELOGIC globalChat "JDAM: SYNCHRONIZATION COMPLETE";

// _hud = [] execVM "JDAM\JDAM_hud\init.sqf";
// waitUntil {!isNil "HUD_DISPLAY_FUNCTIONS_LIST"};
// JDAM_GAMELOGIC globalChat "JDAM: HUD SYSTEM ENABLED";

// _kits = [] execVM "PLAYER_KITS\InitPlayerKits.sqf";
// waitUntil {scriptDone _kits};
// JDAM_GAMELOGIC globalChat "JDAM: KIT SYSTEM LOADED";

_mpcs = [] execVM "JDAM\JDAM_mpcs\JDAM_init.sqf";
waitUntil {scriptDone _mpcs};
// JDAM_GAMELOGIC globalChat "JDAM: BROADCAST SYSTEM OPERATIONAL";

_fnc = [] execVM "JDAM\JDAM_fnc\JDAM_init.sqf";
waitUntil {scriptDone _fnc};
// JDAM_GAMELOGIC globalChat "JDAM: FUNCTIONS SET";

// [] spawn {

	// _objSys = [] execVM "JDAM\JDAM_objSys\init.sqf";
	// waitUntil {scriptDone _objSys};
	// JDAM_GAMELOGIC globalChat "JDAM: OBJECTIVE SYSTEM INITILIZED";

// };
/***************************************************************************
END
****************************************************************************/