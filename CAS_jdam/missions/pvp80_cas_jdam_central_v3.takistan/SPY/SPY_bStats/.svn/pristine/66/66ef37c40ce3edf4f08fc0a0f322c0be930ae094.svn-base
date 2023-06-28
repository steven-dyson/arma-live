/*
	Author: Spyder (spyder@armalive.com)

	Description:
	Store new and old weapon start and end time when SPY Core CEH onSwitchedWeapon fires (called using SPY_core_cehAdd_a from bStats init_c.sqf)

	Parameter(s):
		0: OBJECT - unit who switched weapons
		1: STRING - weapon unit switched to
		2: STRING - weapon unit switched from

	Returns:
	BOOL
*/

scriptName "SPY_bStats_fnc_onSwitchedWpn";

private ["_vehicle"];

_unit = [_this, 0, objNull, [objNull]] call BIS_fnc_param;
_weapon = [_this, 1, "", [""]] call BIS_fnc_param;
_weaponOld = [_this, 2, "", [""]] call BIS_fnc_param;

if ((_weapon in ["", "TruckHorn"])) exitWith { false };

_vehicle = objNull;

if (!(vehicle _unit isEqualTo _unit)) then
{
	_vehicle = vehicle _unit;
};

// Old weapon
if (!(isNil {_unit getVariable "SPY_bStats_weaponVar"})) then
{
	_weaponVarOld = _unit getVariable "SPY_bStats_weaponVar";
	_weaponStatsOld = _unit getVariable _weaponVarOld;
	_timeOld = _weaponStatsOld select 2;
	_weaponStatsOld set [2, _timeOld + (time - (_unit getVariable "SPY_bStats_weaponStartTime"))];
};

// Variable name based on weapon
_weaponVar = format ["SPY_bStats_weapon_%1_%2", _weapon, typeOf _vehicle];

// Create if nil
if ((isNil {_unit getVariable _weaponVar})) then
{
	_unit setVariable [_weaponVar, [_weapon, typeOf _vehicle, 0, 0, [0, 0, 0, 0, 0, 0]], false];
	_currentWeapons = _unit getVariable "SPY_bStats_weaponsForProcess";
	_currentWeapons pushBack _weaponVar;
};

_unit setVariable ["SPY_bStats_weaponVar", _weaponVar, false];
_unit setVariable ["SPY_bStats_weaponStartTime", time, false];

true