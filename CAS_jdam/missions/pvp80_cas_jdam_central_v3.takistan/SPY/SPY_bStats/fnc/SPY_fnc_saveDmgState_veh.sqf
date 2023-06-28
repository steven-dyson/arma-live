/*
	Author: Spyder (spyder@armalive.com)

	Description:
	Checks for valid hits based on damage amount and damager. If hit is valid damager is stored in array. Local variable prefixes are _v = victim and _d = damager.
	
	Parameter(s):
		0: OBJECT - victim vehicle that was damaged
		1: NUMBER - damage to selection
		2: OBJECT - damager
		3: STRING - ammo used by damager

	Returns:
	BOOL
*/

scriptName "SPY_bStats_fnc_saveDmgState_veh";

private ["_previousEntry", "_damagers", "_d"];

_vVehicle = [_this, 0, objNull, [objNull]] call BIS_fnc_param;
_selDmg = [_this, 2, 0, [0]] call BIS_fnc_param;
_d = [_this, 3, objNull, [objNull]] call BIS_fnc_param;
_dAmmo = [_this, 4, "", [""]] call BIS_fnc_param;

// Processing has already completed
if ((!alive _vVehicle)) exitWith { false };

// %NOTE% No idea on this one
_vVehicle = [_this, 0, objNull, [objNull]] call BIS_fnc_param;

// Retrieve all vehicle and damage info
_vehicleSide = _vVehicle getVariable "SPY_bStats_side";
_damagers = _vVehicle getVariable "SPY_bStats_damagers";
_vVehicleCrew = _vVehicle getVariable "SPY_bStats_crew";

// HandleDamage runs multiple times per hit, only run one time
_vHitVar = format ["SPY_bStats_hit_%1", [diag_tickTime, 0] call BIS_fnc_cutDecimals];

// Exit if one handle damage already with a valid damager, damager is null, self inflicted, or lack of significant damage
if ((!isNil {_vVehicle getVariable _vHitVar}) or (_d isEqualTo _vVehicle) or (_d in _vVehicleCrew) or (_selDmg < 0.01) or (_dAmmo isEqualTo "")) exitWith { false };

// Ensure run once
_vVehicle setVariable [_vHitVar, 1, false];

// Killer was not type of man, run detection
if (!(_d isKindOf "Man")) then 
{
	_d = ([_d, _vVehicle, objNull, _dAmmo, false] call SPY_bStats_fnc_getUnit);  // %NOTE% This breaks the local variable _vVehicle for some reason
};

_vVehicle = [_this, 0, objNull, [objNull]] call BIS_fnc_param;

// No damager found
if ((isNull _d)) exitWith { false };

// Lock death state at 1
_vVehicle setVariable ["SPY_bStats_deathState", 1, true];

// For each saved damager, check against new damager. If found update selection.
{
	if (((_x select 0) isEqualTo _d)) exitWith 
	{
		_damagers set [_forEachIndex, [_d, ((_x select 1) + _selDmg), (time + 180)]];
		_previousEntry = true;
		
		if ((_previousEntry)) exitWith {};
	};
	
} forEach _damagers;

_vVehicle = [_this, 0, objNull, [objNull]] call BIS_fnc_param;

// Damager was not in list, add a new entry
if ((isNil "_previousEntry")) then 
{
	_damagers pushBack [_d, _selDmg, (time + 180)];
};

// Update death state and killer. Must run out of frame.
[_vVehicle, _d] spawn
{
	if ((!alive (_this select 0))) then
	{
		(_this select 0) setVariable ["SPY_bStats_killer", (_this select 1), true];
		(_this select 0) setVariable ["SPY_bStats_deathState", 2, true];
	};
	
	if ((alive (_this select 0)) and ((_this select 0) getVariable "SPY_bStats_deathState" isEqualTo 1)) then
	{
		(_this select 0) setVariable ["SPY_bStats_deathState", 0, true];
	};
};

// Debug
_null = [[1, (format ["SDSV: %1, %2, %3", _vVehicle, _d, _vHitVar]), 0, ["SPY Systems", "Debug Log"], false], "SPY_core_fnc_bMessage", true, false, false] call BIS_fnc_MP;

true