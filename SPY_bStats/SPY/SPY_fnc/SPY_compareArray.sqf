/***************************************************************************
COMPARE ARRAY
CREATED BY SPYDER
SPYDER@ARMALIVE.COM
***************************************************************************/

private ["_a", "_b", "_index", "_equal"];

_a = (_this select 0);
_b = (_this select 1);

if ((typeName _a != "ARRAY") || (typeName _b != "ARRAY")) exitWith {

	false

};

_index = 0;

for "_i" from 1 to (count _a) do {

	if (((count _a) != (count _b))) exitWith {_equal = false;};
	
	if ((isNil {_a select _index}) || (isNil {_b select _index})) exitWith {_equal = false;};
	
	if (((typeName (_a select _index)) != (typeName (_b select _index)))) exitWith {_equal = false;};

	if (((_a select _index) != (_b select _index))) exitWith {_equal = false};
	
	_index = (_index + 1);
	
	if ((_index == (count _a))) exitWith {_equal = true;};

};

if ((isNil "_equal")) then {_equal = false};

_equal