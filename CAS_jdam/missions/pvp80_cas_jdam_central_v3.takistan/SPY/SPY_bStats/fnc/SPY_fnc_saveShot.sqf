/*
	Author: Spyder (spyder@armalive.com)

	Description:
	Create if required and update weapon stats variable for specific weapon. Also create variable used for weapon detection based on ammo attached to vehicle player.

	Parameter(s):
		0: OBJECT - unit who fired weapon
		1: STRING - muzzle unit fired
		1: STRING - ammo class fired

	Returns:
	BOOL
*/

scriptName "SPY_bStats_fnc_saveShot";

private ["_unit", "_vehicle"];

_unit = [_this, 0, player, [player]] call BIS_fnc_param;
_muzzle = [_this, 1, "", [""]] call BIS_fnc_param;
_ammo = [_this, 2, "", [""]] call BIS_fnc_param;
_bullet = [_this, 3, objNull, [objNull]] call BIS_fnc_param;

// Default value for dismounted
_vehicle = objNull;

// Vehicle was returned as shooter
if ((_unit in vehicles)) then
{
	_vehicle = _unit;
	_unit = player;
	
	// Define unit. This is random for AI only vehicles.
	/*{
		if (local _unit) then
		{
			_unit = _x;
		};
	}
	forEach crew _vehicle;*/
};

// Unit isn't able to fire
if (((assignedVehicleRole _unit select 0) isEqualTo "Cargo")) exitWith { false };

// Save owner information to variable based on projectile name
SPY_container setVariable [format ["SPY_bStats_%1_owner", _bullet], _unit, false];
SPY_container setVariable [format ["SPY_bStats_%1_ownerWeapon", _bullet], _muzzle, false];
SPY_container setVariable [format ["SPY_bStats_%1_ownerVehicle", _bullet], _vehicle, false];

// Don't store empty muzzle or vehicle horn
if ((_muzzle in ["", "TruckHorn"])) exitWith { false };

// Save weapon to unit variable
_weaponVar = format ["SPY_bStats_%1", _ammo];
_unit setVariable [_weaponVar, [_muzzle, _vehicle, _unit], true];

// Variable name based on weapon
_weaponStatsVar = format ["SPY_bStats_weapon_%1_%2", _muzzle, typeOf _vehicle];

// Create weapon stats variable if nil
if ((isNil {_unit getVariable _weaponStatsVar})) then
{
	_unit setVariable [_weaponStatsVar, [_muzzle, typeOf _vehicle, 0, 0, [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]], false];
	_currentWeapons = _unit getVariable "SPY_bStats_weaponsForProcess";
	_currentWeapons pushBack _weaponStatsVar;
};

// Gather required info and store shot
_weaponStats = _unit getVariable _weaponStatsVar;
_shots = (_weaponStats select 3) + 1;
_weaponStats set [3, _shots];

true