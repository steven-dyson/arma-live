/*
	Author: Spyder (spyder@armalive.com)

	Description:
	Adds a script to a custom event handers array to run run on detection

	Parameter(s):
		0: OBJECT - unit to attach event handler to
		1: STRING - event handler type
		2: STRING - unique event handler name
		3: ARRAY - arguments passed
		4: STRING - function to be called

	Returns:
	BOOL
	
	Usage:
	// _null = [unit, event handler type, custom handle, [arguments], "function to be called"] call SPY_core_fnc_cehAdd;
*/

scriptName "SPY_core_fnc_cehAdd";

_unit = [_this, 0, objNull, [objNull]] call BIS_fnc_param;
_type = [_this, 1, "", [""]] call BIS_fnc_param;
_cehID = [_this, 2, "", [""]] call BIS_fnc_param;
_args = [_this, 3, [], [[]]] call BIS_fnc_param;
_fnc = [_this, 4, "", [""]] call BIS_fnc_param;

// Ensure CEH variable is attached to the unit
if ((isNil {_unit getVariable _type})) then
{
	_unit setVariable [_type, [], false];
};

// Retrieve and update CEH data
_data = _unit getVariable _type;
_data pushBack [_cehID, _args, _fnc];

// Save to unit
_unit setVariable [_type, _data, false];

// Debug
_null = [1, (format ["CEH: %1 added (%2)", _type, _cehID]), 0, ["SPY Systems", "Debug Log"], true] spawn SPY_core_fnc_bMessage;

true