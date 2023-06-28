/***************************************************************************
SPY Initialization and Compile (Method)
Created by Spyder
spyder@armalive.com
***************************************************************************/

private ["_compile", "_actionContainers"];

if ((!isServer)) then {
	
	_compile = [] execVM "CAS\CAS_JDAM\CAS_compile.sqf";
	waitUntil {sleep 0.1; scriptDone _compile};
	
	// If player is JIP run JIP update
	if (((getMarkerPos "CAS_JDAM_ao1_z1_g1_west" select 0) == 0)) then {

		_null = [[], "_this spawn CAS_JDAM_obj_onJIP_s;", "SERVER"] spawn CAS_mpCB;

	};
	
};

// Player briefing
_briefing = [] execVM "CAS\CAS_JDAM\info\CAS_briefing_c.sqf";
waitUntil {sleep 0.1; scriptDone _briefing};

// Add JDAM actions to objects
_actionContainers = [] execVM "CAS\CAS_JDAM\init\CAS_actionContainers_c.sqf";
waitUntil {sleep 0.1; scriptDone _actionContainers};

// Squad leader actions thread
_null = [] execVM "CAS\CAS_JDAM\init\CAS_squadLeader_c.sqf";

// Grid Status Thread
_null = [] execVM "CAS\CAS_JDAM\obj\CAS_changedGridStatus_c.sqf";

// Safe Zone Thread
_null = [] execVM "CAS\CAS_JDAM\safeZone\CAS_player_c.sqf";

// Hint System Thread
_null = [] execVM "CAS\CAS_JDAM\info\CAS_hints_c.sqf";