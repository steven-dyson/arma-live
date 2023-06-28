/*
	Author: Spyder (spyder@armalive.com)

	Description:
	Executes functions stored in the custom event handler function array.

	Parameter(s):
		0: ARRAY - reserved arguments
		1: STRING - custom event handler type
		2: SCALAR - index of object event handler is to be executed on
		3: BOOLEAN - true to run on client machine and false to run on server machine only.

	Returns:
	BOOL
	
	Usage:
	// [[reserved arguments], event handler type, index in arguments of object] call SPY_core_fnc_cehExec;
*/

scriptName "SPY_core_fnc_cehExec";

_args = [_this, 0, [], [[]]] call BIS_fnc_param;
_type = [_this, 1, "", [""]] call BIS_fnc_param;
_index = [_this, 2, 0, [0]] call BIS_fnc_param;
_machineType = [_this, 3, true, [true]] call BIS_fnc_param;

_cehValue = (_args select _index) getVariable _type;

// Exit if CEH value is nil
if ((isNil "_cehValue")) exitWith { false };

// Exit if target does not match
//if ((isDedicated and !_machineType) or (!isDedicated and _machineType)) exitWith { player sideChat "REALLY"; false };

{
	_args pushBack [(_x select 1)];
	_fnc = call compile (_x select 2);
	_args call _fnc;
}
forEach _cehValue;

true