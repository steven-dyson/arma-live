/*
	Author: Spyder (spyder@armalive.com)

	Description:
	Returns the killer or damaging unit in an event based on the victim vehicle's killer, or nearby exploding vehicle's killer.

	Parameter(s):
		0: OBJECT - unit detected by BIS event handlers. Will return vehicle in all cases where unit is inside of a vehicle.
		1: OBJECT - victim infantry or vehicle
		2: OBJECT - victim's vehicle at time of event. Infantry units only.
		3: STRING - ammo class of projectile used in event against victim.
		4: BOOLEAN - true if event is kill and you are checking for death from exploding vehicles.
		5: ARRAY - array of damaging units

	Returns:
	OBJECT - unit responsible for event. null-object is returned on fail.
*/

scriptName "SPY_bStats_fnc_getUnit";

private ["_unit"];

_unit = [_this, 0, objNull, [objNull]] call BIS_fnc_param;
_victim = [_this, 1, objNull, [objNull]] call BIS_fnc_param;
_vVehicle = [_this, 2, objNull, [objNull]] call BIS_fnc_param;
_uAmmoClass = [_this, 3, "", [""]] call BIS_fnc_param;
_expCheck = [_this, 4, false, [false]] call BIS_fnc_param;
_damagingUnits = [_this, 5, [], [[]]] call BIS_fnc_param;

// Cross reference each unit in a vehicle with the ammo used for the event.
if ((!isNil "_uAmmoClass") and (!isNull _unit)) then
{
	_weaponVar = format ["SPY_bStats_%1", _uAmmoClass];
	{
		if ((!isNil {_x getVariable _weaponVar})) exitWith
		{
			_unit = _x;
		};
	}
	forEach crew _unit;
};

// Attempt killer of hit event
if (!(_unit isKindOf "Man")) then
{
	_unit = (_victim getVariable "SPY_bStats_killer");
};

// Attempt killer of vehicle on infantry units
if (!(_unit isKindOf "Man") and (!isNull _vVehicle) and (!alive _vVehicle)) then
{
	_unit = (_vVehicle getVariable "SPY_bStats_killer");
	_victim setVariable ["SPY_bStats_lastHitWeapon", _vVehicle getVariable "SPY_bStats_lastHitWeapon", true];
};

// Attempt killer of nearby vehicle on infantry or vehicle units
if (!(_unit isKindOf "Man") and (_expCheck)) then 
{
	{
		_unit = (_x getVariable "SPY_bStats_killer");
		
		if ((_unit isKindOf "Man")) exitWith
		{
			_victim setVariable ["SPY_bStats_lastHitWeapon", _x getVariable "SPY_bStats_lastHitWeapon", true];
		};
	}
	forEach (nearestObjects [getPos _victim, ["LandVehicle", "Air"], 40]);
};

// Attempt damaging unit
if (!(_unit isKindOf "Man") and (count _damagingUnits > 0) and (!alive _victim)) then 
{
	player sideChat format ["D: %1", _damagingUnits];
	_unit = (_damagingUnits select (count _damagingUnits - 1) select 0);
};

// Check for game logics for explosives or arty here.
// Ready

// No killer found
if (!(_unit isKindOf "Man")) then 
{
	_unit = objNull;
};

// Debug
// _null = [1, format ["GU %1", _unit], 0, ["SPY Systems", "Debug Log"], true] spawn SPY_core_fnc_bMessage;

_unit