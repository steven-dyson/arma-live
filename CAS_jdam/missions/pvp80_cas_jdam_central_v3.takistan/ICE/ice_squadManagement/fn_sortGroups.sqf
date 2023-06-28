// Desc: return a sorted list of groups
// Warning: very slow function. Many nested iterations. Up to 1x4x4x9x13=1872 iterations for a non-match.
// TODO: optimise
//-----------------------------------------------------------------------------
#include "common.sqh"

private ["_result", "_groupArray", "_matchFound", "_sideStr", "_leftNumber", "_middleNumber", 
	"_letter", "_groupStr", "_matchGroupStr", "_group", "_side", "_i", "_j",
	"_fn_value", "_fn_compare"];

_groupArray = _this select 0;

// function to derive a sortable value from the group name.
_fn_value =
{
	private ["_r", "_array"];

	_r = 0;
	_array = toArray str _this; // Eg: "B 4-4-M"
	if (count _array < 7) exitWith {_r};

	_v = (_array select 0)-64; // B=66,O=79,G=71,C=67
	_r = _r+(_v * 221000);
	_v = (_array select 2)-48; // first digit, '0'=48
	_r = _r+(_v * 1000);
	_v = (_array select 4)-48; // second digit, '0'=48
	_r = _r+(_v * 100);
	_v = (_array select 6)-64; // last letter (A-M=65-77)
	_r = _r+_v;
	_r
};

_fn_compare =
{
	private ["_a", "_b"];

	_a = (_this select 0) call _fn_value;
	_b = (_this select 1) call _fn_value;

	if (_a < _b) then {-1} else {if (_a > _b) then {1} else {0}}
};

if (isNil "ICE_fn_quicksort") then {ICE_fn_quicksort = compile preprocessFileLineNumbers _c_basePath(functions\fn_quicksort.sqf);};

_groupArray = [_groupArray, _fn_compare] call ICE_fn_quicksort;

_groupArray
