/*
	Author: Spyder (spyder@armalive.com)

	Description:
	Updates damagers array on victim vehicle
	
	Parameter(s):
		0: OBJECT - victim vehicle that was damaged
		1: OBJECT - damager

	Returns:
	BOOL
*/

scriptName "SPY_bStats_fnc_saveDmgState_veh";

private ["_previousEntry", "_damagers"];

_vVehicle = [_this, 0, objNull, [objNull]] call BIS_fnc_param;
_d = [_this, 1, objNull, [objNull]] call BIS_fnc_param;

// Retrieve all vehicle and damage info
_vehicleSide = _vVehicle getVariable "SPY_bStats_side";
_damagers = _vVehicle getVariable "SPY_bStats_damagers";
_vVehicleCrew = _vVehicle getVariable "SPY_bStats_crew";

// For each saved damager, check against new damager. If found update selection.
{
	if (((_x select 0) isEqualTo _d)) exitWith 
	{
		_damagers set [_forEachIndex, [_d, 0, (time + 180)]];
		_previousEntry = true;
		
		if ((_previousEntry)) exitWith {};
	};
	
} forEach _damagers;

// Damager was not in list, add a new entry
if ((isNil "_previousEntry")) then 
{
	_damagers pushBack [_d, 0, (time + 180)];
};

// Debug
_null = [[1, (format ["UDV: %1, %2", _vVehicle, _d]), 0, ["SPY Systems", "Debug Log"], false], "SPY_core_fnc_bMessage", true, false, false] call BIS_fnc_MP;

true