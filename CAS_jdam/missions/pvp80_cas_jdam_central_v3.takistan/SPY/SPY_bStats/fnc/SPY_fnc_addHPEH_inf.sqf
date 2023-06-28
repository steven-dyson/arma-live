/*
	Author: Spyder (spyder@armalive.com)

	Description:
	Add a HitPart EH to a unit. Used in conjunction with BIS_fnc_MP as it fires on the shooters machine.

	Parameter(s):
		0: OBJECT - unit to init

	Returns:
	BOOL 
*/

scriptName "SPY_bStats_fnc_addHPEH_inf";

_unit = [_this, 0, objNull, [objNull]] call BIS_fnc_param;

_hpeh = _unit addEventHandler
[
	"HitPart",
	{
		_null = (_this select 0) call SPY_bStats_fnc_refineHit_inf;
	}
];

true