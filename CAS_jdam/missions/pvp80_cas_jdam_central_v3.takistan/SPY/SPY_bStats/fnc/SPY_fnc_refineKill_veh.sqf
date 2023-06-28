/*
	Author: Spyder (spyder@armalive.com)

	Description:
	Takes info from BIS Killed EH and then checks variables and runs functions to better determine the killer. Also awards scores for kills and TKs.

	Parameter(s):
		0: OBJECT - victim vehicle
		1: OBJECT - killer (as reported by BIS Killed EH)

	Returns:
	BOOL
*/

private ["_k", "_d", "_vVehicle", "_kWeapon", "_kVehicle"];

_vVehicle = [_this, 0, objNull, [objNull]] call BIS_fnc_param;
_k = [_this, 1, objNull, [objNull]] call BIS_fnc_param;

// Retrieve vehicle info
_vVehicleSide = _vVehicle getVariable "SPY_bStats_side";
_vVehicleCrew = _vVehicle getVariable "SPY_bStats_crew";
_vVehicleReset = _vVehicle getVariable "SPY_bStats_switchState";
_vVehicleUID = _vVehicle getVariable "SPY_bStats_uid";
_damagingUnits = _vVehicle getVariable "SPY_bStats_damagers";

// Wait for saveDmgState to finish
if ((_vVehicle getVariable "SPY_bStats_deathState" > 0)) then
{
	waitUntil { _vVehicle getVariable "SPY_bStats_deathState" isEqualTo 2; };
};

// Killer was not a playable unit, run detection %NOTE% May be able to remove this as killer is saved in hit events.
if (!(_k isKindOf "Man") or (_k in _vVehicleCrew)) then
{
	_k = [_k, _vVehicle, objNull, "", true, _damagingUnits] call SPY_bStats_fnc_getUnit; // %NOTE% This breaks the local variable _vVehicle for some reason
};

// %NOTE% No idea on this one
_vVehicle = [_this, 0, objNull, [objNull]] call BIS_fnc_param;

// Retrieve killer weapon and vehicle if event wasn't roadkill
if ((isNil "_kWeapon")) then
{	
	[[_vVehicle, _k], "SPY_bStats_fnc_getWeaponUsed", [_k], false, true] call BIS_fnc_MP;
	player sideChat "WAITING";
	waitUntil { !isNil {_vVehicle getVariable "SPY_bStats_killerWeapon"} };
player sideChat "READY";
	_kWeapon = (_vVehicle getVariable "SPY_bStats_killerWeapon" select 0);
	_kVehicle = (_vVehicle getVariable "SPY_bStats_killerWeapon" select 1);
player sideChat format ["G: %1", _vVehicle getVariable "SPY_bStats_killerWeapon"];
	// Default weapon, mainly for testing
	if ((isNil "_kWeapon")) then { _kWeapon = "Unknown"; _kVehicle = objNull; };
};

// Error message
if ((isNull _k)) exitWith
{ 
	_null = [[2, "No kill defined refineKill_veh!", 0, ["SPY Systems", "Debug Log"], false], "SPY_core_fnc_bMessage", true, false, false] call BIS_fnc_MP;
	false
};

// Debug
_null = [[1, (format ["RKV %1, %2",_vVehicle, _k]), 0, ["SPY Systems", "Debug Log"], false], "SPY_core_fnc_bMessage", true, false, false] call BIS_fnc_MP;

// Retrieve killer data
_kUID = _k getVariable "SPY_id_uid";
_kName = (SPY_container getVariable format ["SPY_id_%1", _kUID] select 0);
_kSide = (SPY_container getVariable format ["SPY_id_%1", _kUID] select 1);
_kIsAI = (SPY_container getVariable format ["SPY_id_%1", _kUID] select 3);
_kVehicle = _k getVariable "SPY_bStats_vehicle";

// Get assists
_assists = [_vVehicleSide, _kUID, _vVehicle getVariable "SPY_bStats_damagers", _kVehicle getVariable "SPY_bStats_crew"] call SPY_bStats_fnc_getAssists;

// Set death state
_vVehicle setVariable ["SPY_bStats_deathState", 3, false];

// Set killer if it wasn't previously
if ((isNull (_vVehicle getVariable "SPY_bStats_killer"))) then
{
	_vVehicle setVariable ["SPY_bStats_killer", _k, true];
};

// Team vehicle kill check
if ((_kSide isEqualTo _vVehicleSide) and !(isNull _k) and !(_k in _vVehicleCrew)) exitWith
{
	[_vVehicle, _k, _assists] call SPY_bStats_fnc_onTK_veh;
	_null = [_k, "Auto", _kUID, "Server", _kIsAI] spawn SPY_punish;
	player sideChat format ["G2: %1", _vVehicle getVariable "SPY_bStats_killerWeapon"];
	_null = [[_vVehicle, _vVehicleUID, _vVehicleSide, getPos _vVehicle, typeOf _vVehicle, _k, _kUID, _kName, _kSide, getPosASL _k, typeOf _k, _kWeapon, _kVehicle, 0, _assists], "SPY_bStats_onTK_veh", 0, true] call SPY_core_fnc_cehExec;
	true
};

// Enemy vehicle kill
if (!(isNull _k) and !(_k in _vVehicleCrew)) exitWith
{
	[_vVehicle, _k, _assists] call SPY_bStats_fnc_onKill_veh;
	_null = [[_vVehicle, _vVehicleUID, _vVehicleSide, getPos _vVehicle, typeOf _vVehicle, _k, _kUID, _kName, _kSide, getPosASL _k, typeOf _k, _kWeapon, _kVehicle, 0, _assists], "SPY_bStats_onKill_veh", 0, true] call SPY_core_fnc_cehExec;
	true
};

false