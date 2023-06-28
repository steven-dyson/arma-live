/***************************************************************************
SPY Initialization and Compile (Method)
Created by Spyder
spyder@armalive.com
***************************************************************************/



/***************************************************************************
EXEC
****************************************************************************/
private ["_mpcs", "_fnc"];

// _settings = [] execVM "CAS\CAS_settings.sqf";
// waitUntil {scriptDone _settings};

// _sync = [] execVM "CAS\CAS_sync.sqf";
// waitUntil {scriptDone _sync};

// _hud = [] execVM "CAS\CAS_hud\init.sqf";
// waitUntil {!isNil "HUD_DISPLAY_FUNCTIONS_LIST"};

// _kits = [] execVM "PLAYER_KITS\InitPlayerKits.sqf";
// waitUntil {scriptDone _kits};

_mpcs = [] execVM "CAS\CAS_core\CAS_mpcs\CAS_init_s.sqf";
waitUntil {scriptDone _mpcs};

_fnc = [] execVM "CAS\CAS_core\CAS_fnc\CAS_init_a.sqf";
waitUntil {scriptDone _fnc};

// [] spawn {

	// _objSys = [] execVM "CAS\CAS_objSys\init.sqf";
	// waitUntil {scriptDone _objSys};
	// CAS_GAMELOGIC globalChat "CAS: OBJECTIVE SYSTEM INITILIZED";

// };
/***************************************************************************
END
****************************************************************************/