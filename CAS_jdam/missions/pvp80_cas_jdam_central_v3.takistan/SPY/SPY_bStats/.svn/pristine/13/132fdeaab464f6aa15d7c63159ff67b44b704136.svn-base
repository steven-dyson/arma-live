/***************************************************************************
Initialize AI
Created by Spyder
spyder@armalive.com
****************************************************************************/

private ["_ai", "_uid", "_array_playerlist", "_vehicle"];

_ai = [_this, 0, objNull, [objNull]] call BIS_fnc_param;

if ((isNull _ai)) exitWith { false };

_uid = (str round ((getPos _ai select 0) + (random 1000000))); // UID are assigned randomly, mainly for testing and integration with player systems
_varName = (format ["SPY_bStats_%1", _uid]); // Standard format bStats variable for scoring

_ai enableSimulation false; // Disable simulation while under init, mainly for testing

_ai setVariable ["SPY_id_uid", _uid, true]; // UID variable
SPY_container setVariable [("SPY_id_" + _uid), [(name _ai), (side _ai), (faction _ai), true], true]; // ID variable
SPY_container setVariable [_varName, [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, (side _ai)], true]; // Standard score variable array; This may be replaced with separate variables

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

// AI object variables
if ((vehicle _ai isEqualTo _ai)) then
{
	_ai setVariable ["SPY_bStats_vehicle", objNull, true];
}
else
{
	_ai setVariable ["SPY_bStats_vehicle", vehicle _ai, true];
};

_ai setVariable ["SPY_bStats_damagers", [], false];
_ai setVariable ["SPY_bStats_isDriver", (!(vehicle _ai isEqualTo _ai) && (driver vehicle _ai isEqualTo _ai)), false];
_ai setVariable ["SPY_bStats_weaponsForProcess", [], false];
_ai setVariable ["SPY_bStats_weaponStartTime", time, false];
_ai setVariable ["SPY_bStats_killer", objNull, true];
_ai setVariable ["SPY_bStats_lastHitWeapon", ["", objNull], true];
_ai setVariable ["SPY_bStats_deathState", 0, true];

// AI object variables (CEH)
_ai setVariable ["SPY_ceh_onKill_inf", [], false];
_ai setVariable ["SPY_ceh_onRoadKill", [], false];

_eh_f = _ai addEventHandler 
[
	"Fired", 
	{
		[(_this select 0), (_this select 1), (_this select 4), (_this select 6)] call SPY_bStats_fnc_saveShot;
	}
];

// Add fired EH to clients vehicle if client started in one
if (!(vehicle _ai isEqualTo _ai)) then
{
	_eh_f_veh = vehicle _ai addEventHandler 
	[
		"Fired", 
		{
			_null = [(_this select 0), (_this select 2), (_this select 4), (_this select 6)] spawn SPY_bStats_fnc_saveShot;
		}
	];
	
	vehicle _ai setVariable ["SPY_bStats_firedEH", _eh_f_veh, false];
};

// Executes when an AI is hit. Damaging unit is stored with relevant data.
_eh_hd = _ai addEventHandler 
[
	"HandleDamage", 
	{
		_null = _this call SPY_bStats_fnc_saveDmgState_inf;
		(_this select 2);
	}
];

// Add the HitPart EH to all local unit on all client machines
_null = [[_ai, false], "SPY_bStats_fnc_addHPEH_inf", true, true] call BIS_fnc_MP;

// Monitors when an AI is killed.
_eh_k = _ai addEventHandler 
[
	"Killed",
	{
		_null = [(_this select 0), (_this select 1)] spawn SPY_bStats_fnc_refineKill_inf;
		
	}
];

// Runs when an AI enters a vehicle
_eh_gi = _ai addEventHandler
[
	"GetIn",
	{
		_ai setVariable ["SPY_bStats_vehicle", vehicle (_this select 2), true];
	}
];

// Runs when an AI exits a vehicle
_eh_go = _ai addEventHandler
[
	"GetOut",
	{
		// _ai setVariable ["SPY_bStats_vehicle", objNull, true];
	}
];

// Determine AI list
switch (side _ai) do 
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

// Add AI to side specific AI list
_playerList = (SPY_container getVariable _array_playerList);
_playerList = (_playerList + [_uid]);
SPY_container setVariable [_array_playerList, _playerList, true];

// CEH
_null = [_ai] execVM "armalive\ALS_init_c.sqf";

// Debug
_null = [1, (format ["IAI %1, %2", _ai, _uid]), 0, ["SPY Systems", "Debug Log"], false] spawn SPY_core_fnc_bMessage;

_ai enableSimulation true; // Turn AI simulation back on