/*
	Author: Spyder (spyder@armalive.com)

	Description:
	Returns last weapon and vehicle used from shooter over network during a hit event.

	Parameter(s):
		0: OBJECT - victim
		1: OBJECT - killer

	Returns:
	BOOL
*/

_v = [_this, 0, objNull, [objNull]] call BIS_fnc_param;
_k = [_this, 1, objNull, [objNull]] call BIS_fnc_param;

_kWeapon = _k getVariable format ["SPY_bStats_%1", _v];

_v setVariable ["SPY_bStats_killerWeapon", _kWeapon, true];