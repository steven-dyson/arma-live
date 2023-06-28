/*
	Author: Spyder (spyder@armalive.com)

	Description:
	Removes a function to be run from a event handler type with the matching ID.

	Parameter(s):
		0: OBJECT - unit event hander is attached to
		1: STRING - custom event handler type
		2: STRING - unique ID of event handler

	Returns:
	BOOL
	
	Usage:
	// _null = [unit, event handler type, string ID of event hander] call SPY_core_fnc_cehRemove;
*/

_unit = [_this, 0, objNull, [objNull]] call BIS_fnc_param;
_type = [_this, 1, "", [""]] call BIS_fnc_param;
_id = [_this, 2, "", [""]] call BIS_fnc_param;

_cehValue = _unit getVariable _type;

{
	if ((_x select 0) isEqualTo _id) exitWith
	{
		_cehValue set [_forEachIndex, -1];
		_cehValue = _cehValue - [-1];
		_unit setVariable [_type, _cehValue, false];
	};
	
	true
}
forEach _cehValue;

false