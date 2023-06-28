/*
	Author: Spyder (spyder@armalive.com)

	Description:
	Store a hit to weapon or vehicle stats

	Parameter(s):
		0: OBJECT - damager
		1: NUMBER - selection hit converted to number
		2: STRING - weapon used
		3: STRING - vehicle used where "D" is for dismount by default

	Returns:
	BOOL
*/

private ["_vehicle"];

_scriptName = "SPY_bStats_fnc_saveHit";

_d = [_this, 0, objNull, [objNull]] call BIS_fnc_param;
_selectionType = [_this, 1, 1, [0]] call BIS_fnc_param;
_weapon = [_this, 2, "", [""]] call BIS_fnc_param;
_vehicle = [_this, 3, objNull, [objNull]] call BIS_fnc_param;

// Variable names based on weapon and vehicle
_weaponVar = format ["SPY_bStats_weapon_%1_%2", _weapon, typeOf _vehicle];

waitUntil { !isNil {_d getVariable _weaponVar } };

// Gather stats and add hit to proper selection
_weaponStats = (_d getVariable _weaponVar);
_hits = _weaponStats select 4;
_hits set [_selectionType, ((_hits select _selectionType) + 1)];

true