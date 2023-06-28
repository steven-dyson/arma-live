/*
	Author: Spyder (spyder@armalive.com)

	Description:
	Initialize a client for bStats.

	Parameter(s):
		NONE

	Returns:
	BOOL
*/

scriptName "SPY_bStats_init_client";

private ["_pUID", "_varName", "_array_playerList"];

_pUID = (player getVariable "SPY_id_uid");

_varName = (format ["SPY_bStats_%1", _pUID]);

// New player joined game
if ((isNil {SPY_container getVariable format ["%1_side", _varName]})) then 
{
	// Player score variables default
	SPY_container setVariable [format ["%1_sb", _varName], 0, true];
	SPY_container setVariable [format ["%1_stw", _varName], 0, true];
	SPY_container setVariable [format ["%1_pp", _varName], 0, true];
	SPY_container setVariable [format ["%1_ki", _varName], 0, true];
	SPY_container setVariable [format ["%1_d", _varName], 0, true];
	SPY_container setVariable [format ["%1_s", _varName], 0, true];
	SPY_container setVariable [format ["%1_tk", _varName], 0, true];
	SPY_container setVariable [format ["%1_kv", _varName], 0, true];
	SPY_container setVariable [format ["%1_ka", _varName], 0, true];
	SPY_container setVariable [format ["%1_acc", _varName], 0, true];
	SPY_container setVariable [format ["%1_obj", _varName], 0, true];
	SPY_container setVariable [format ["%1_side", _pUID], playerSide, true];
		
	// Initial join message
	if ((time > 30) && (SPY_jip_client)) then 
	{
		_null = [[3, (format ["%1 joined the %2 team", (name player), ([playerSide] call SPY_core_fnc_displayName)]), 0, ["SPY bStats", "Event Log"], false], "SPY_core_fnc_bMessage", true, false, false] call BIS_fnc_MP;
	};

// Previous player joined game
}
else
{
	// Re-join side message
	if ((time > 30) && (SPY_jip_client) && ((SPY_container getVariable format ["%1_side", _varName]) isEqualTo playerSide)) exitWith 
	{
		_null = [[3, (format ["%1 re-joined the %2 team", (name player), ([playerSide] call SPY_core_fnc_displayName)]), 0, ["SPY Systems", "Debug Log"], false], "SPY_core_fnc_bMessage", true, false, false] call BIS_fnc_MP;
	};
	
	// Switch side message
	if ((time > 30) && (SPY_jip_client) && !((SPY_container getVariable format ["%1_side", _varName]) isEqualTo playerSide)) exitWith 
	{
		_null = [[3, (format ["%1 switched to the %2 team", (name player), ([playerSide] call SPY_core_fnc_displayName)]), 0, ["SPY Systems", "Debug Log"], false], "SPY_core_fnc_bMessage", true, false, false] call BIS_fnc_MP;
	};	
};

// Player object variables
if ((vehicle player isEqualTo player)) then
{
	player setVariable ["SPY_bStats_vehicle", objNull, true];
}
else
{
	player setVariable ["SPY_bStats_vehicle", vehicle player, true];
};

player setVariable ["SPY_bStats_damagers", [], false];
player setVariable ["SPY_bStats_isDriver", (!(vehicle player isEqualTo player) && (driver vehicle player isEqualTo player)), false];
player setVariable ["SPY_bStats_weaponsForProcess", [], false];
player setVariable ["SPY_bStats_weaponStartTime", time, false];
player setVariable ["SPY_bStats_killer", objNull, true];
player setVariable ["SPY_bStats_lastHitWeapon", ["", objNull], true];
player setVariable ["SPY_bStats_deathState", 0, true];

// Player global variables
SPY_score_open = false;

// bStats diary records
player createDiarySubject ["SPY bStats","SPY bStats"];
player createDiaryRecord ["SPY bStats", ["Credits", "Author: Spyder"]];
player createDiaryRecord ["SPY bStats", ["About", "www.armalive.com Version 1.16"]];

// Executes when a player fires a handheld weapon. Shots fired are stored.
SPY_bStats_eh_f = player addEventHandler 
[
	"Fired", 
	{
		_null = [(_this select 0), (_this select 2), (_this select 4), (_this select 6)] call SPY_bStats_fnc_saveShot;
	}
];

// Executes when player is hit. Damaging unit is stored with relevant data.
SPY_bStats_eh_hd = player addEventHandler 
[
	"HandleDamage", 
	{ 	
		_null = _this call SPY_bStats_fnc_saveDmgState_inf;	
		(_this select 2);
	}
];

// Add the HitPart EH to all local unit on all client machines
_null = [[player, false], "SPY_bStats_fnc_addHPEH_inf", true, true] call BIS_fnc_MP;

// Monitors when a player is killed.
SPY_bStats_eh_k = player addEventHandler 
[
	"Killed", 
	{
		_null = [(_this select 0), (_this select 1)] spawn SPY_bStats_fnc_refineKill_inf;
	}
];

// Monitors when a player hands over controls (pilot > co-pilot or visa versa) to set and un-set the player as driver.
SPY_bStats_eh_cs = player addEventHandler 
[
	"ControlsShifted", 
	{
		_null = [[(_this select 0), true], "_this spawn SPY_bStats_fnc_addVeh", (_this select 1)] spawn CAS_mpCB;
		_null = [[(_this select 0), true], "_this spawn SPY_bStats_fnc_removeVeh", (_this select 2)] spawn CAS_mpCB;
	}
];

player sideChat format ["TEST %1", isNil "SPY_core_fnc_cehAdd"];

// This is executed when a player is detected changing vehicle position. This does run when controls are shifted.
[player, "SPY_ceh_changedVehPos", "SPY_bStats", [], "SPY_bStats_fnc_onChangedVehPos"] call SPY_core_fnc_cehAdd;

// This is executed when a player is detected switching weapons.
[player, "SPY_ceh_switchedWpn", "SPY_bStats", [], "SPY_bStats_fnc_onSwitchedWeapon"] call SPY_core_fnc_cehAdd;

// Monitors when a player receives damage and reset when criteria is meet (heal, dead, or timeout)
_null = [] spawn SPY_bStats_fnc_resetDmg_inf;

// Adds keydown EH for scoreboard
if ((SPY_bStats_sbEnabled)) then 
{
	waitUntil { sleep 0.1; (!isNull (findDisplay 46)) };
	
	(findDisplay 46) displayAddEventHandler ["KeyDown", "if (([(_this select 1), 'NetworkStats'] call SPY_core_fnc_isKey)  && (!SPY_SCORE_OPEN)) then {_null = [] spawn SPY_bStats_fnc_displayScoreGUI;}; ([(_this select 1), 'NetworkStats'] call SPY_core_fnc_isKey);"];
	(findDisplay 46) displayAddEventHandler ["KeyUp", "if (([(_this select 1), 'NetworkStats'] call SPY_core_fnc_isKey) && (SPY_SCORE_OPEN)) then {closeDialog 46;}; ([(_this select 1), 'NetworkStats'] call SPY_core_fnc_isKey);"];
};

// Initialize vehicle if client started in one
if (!(vehicle player isEqualTo player)) then
{
	[vehicle player, playerSide] call SPY_bStats_fnc_initVeh;
};

// Determine player list
switch (playerSide) do 
{
	case west: 
	{
		_array_playerList = "SPY_bStats_players_blu";
	};
	case east: 
	{
		_array_playerList = "SPY_bStats_players_op";
	};
};

// Add player to side specific player list
_playerList = (SPY_container getVariable _array_playerList);
_playerList = (_playerList + [getPlayerUID player]);
SPY_container setVariable [_array_playerList, _playerList, true];

// Updates scoreboard order
[] spawn 
{
	while {sleep 5; true} do 
	{
		_blu = [SPY_container getVariable "SPY_bStats_players_blu", [], {(SPY_container getVariable format ["SPY_bStats_%1_sb", _x]) + (SPY_container getVariable format ["SPY_bStats_%1_stw", _x])}, "DECEND"] call BIS_fnc_sortBy;
		_op = [SPY_container getVariable "SPY_bStats_players_op", [], {(SPY_container getVariable format ["SPY_bStats_%1_sb", _x]) + (SPY_container getVariable format ["SPY_bStats_%1_stw", _x])}, "DECEND"] call BIS_fnc_sortBy;

		SPY_container setVariable ["SPY_bStats_players_blu", _blu, false];
		SPY_container setVariable ["SPY_bStats_players_op", _op, false];
	};
};

// Debug
_null = [1, "bStats Initialized *Client*", 0, ["SPY Systems", "Debug Log"], true] spawn SPY_core_fnc_bMessage;
