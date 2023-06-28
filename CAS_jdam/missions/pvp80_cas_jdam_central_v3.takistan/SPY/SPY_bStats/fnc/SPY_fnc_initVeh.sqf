/***************************************************************************
Initialize Vehicle
Created by Spyder
spyder@armalive.com
****************************************************************************/

private ["_vehicle", "_side"];

_vehicle = [_this, 0, objNull, [objNull]] call BIS_fnc_param;
_side = [_this, 1, CIVILIAN, [CIVILIAN]] call BIS_fnc_param;

waitUntil { sleep 0.1; !isNil "SPY_server_initialized" };
waitUntil { sleep 0.1; SPY_server_initialized };

if ((isNil {_vehicle getVariable "SPY_bStats_deathState"})) then 
{	
	_vehicle setVariable ["SPY_bStats_uid", round ((getPos _vehicle select 0) + (getPos _vehicle select 1)), true];
	_vehicle setVariable ["SPY_bStats_side", _side, true];
	_vehicle setVariable ["SPY_bStats_crew", crew _vehicle, true];
	_vehicle setVariable ["SPY_bStats_switchState", false, true];
	_vehicle setVariable ["SPY_bStats_damagers", [], true];
	_vehicle setVariable ["SPY_bStats_killer", objNull, true];
	_vehicle setVariable ["SPY_bStats_lastHitWeapon", ["", objNull], true];
	_vehicle setVariable ["SPY_bStats_deathState", 0, true];
};

_vehicle addEventHandler 
[
	"HandleDamage", 
	{	
		_null = _this call SPY_bStats_fnc_saveDmgState_veh;
		_this select 2;
	}
];

_hpeh = _vehicle addEventHandler
[
	"HitPart",
	{
		_null = (_this select 0) call SPY_bStats_fnc_refineHit_veh;
	}
];

_vehicle addEventHandler
[
	"Killed", 
	{
		[[(_this select 0), (_this select 1)], "SPY_bStats_fnc_refineKill_veh", false, false] call BIS_fnc_MP;
	}
];

// Execute reset thread on server only
if ((isServer)) then 
{
	_null = [_vehicle] spawn SPY_bStats_fnc_resetDmg_veh;
};

// Debug
_null = [[1, (format ["IV: %1, %2", _vehicle, _side]), 0, ["SPY Systems", "Debug Log"], false], "SPY_core_fnc_bMessage", true, false, false] call BIS_fnc_MP;