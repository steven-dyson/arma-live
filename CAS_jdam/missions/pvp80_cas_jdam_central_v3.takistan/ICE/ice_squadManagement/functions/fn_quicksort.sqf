// Desc: Sorts an array of any type (data or nested-arrays) according to the passed in comparison function.
// Params: [_array, _fn_compare]
// _fn_compare must accept 2 array data items and return < 0, 0 or > 0 based on the comparison it chooses to use.
/* Eg: 
	_fn_compare = {if (_this select 0 < _this select 1) then {-1} else {if (_this select 0 > _this select 1) then {1} else {0}} }; // for simple integers
	_fn_compare = {if ([_this select 0] call _fn_value < [_this select 1] call _fn_value) then {-1} else {if ([_this select 0] call _fn_value > [_this select 1] call _fn_value) then {1} else {0}}}; // for nested arrays (records) with any data types
	_sortedArray = [_unsortedArray, _fn_compare] call ICE_fn_quicksort;
*/
//-----------------------------------------------------------------------------
scriptName "ICE_fn_quicksort";
/*
	(Original BIS function was: Sort Numbers. By Andrew Barron.)
	Modified to sort arrays with ANY data types, even mixed and nested arrays.
	Added 2nd parameter (_fn_compare) to perform the data comparison to sort on.
	Sorts an array of numbers from lowest (left) to highest (right). 
	The passed array is modified by reference.
	This function uses the quick sort algorithm.
*/

// set up a function for recursion
private "_sort";
_sort =
{
	private ["_h","_i","_j","_a","_lo","_hi","_x","_fn_compare"];

	_a = _this select 0; //array to be sorted
	_fn_compare = _this select 1; //function to compare the array data
	_lo = _this select 2; //lower index to sort from
	_hi = _this select 3; //upper index to sort to

	_h = nil;            //used to make a do-while loop below
	_i = _lo;
	_j = _hi;
	if (count _a == 0) exitWith {};
	_x = _a select ((_lo+_hi)/2);

	//  partition
	while {isNil "_h" || _i <= _j} do
	{
		//find first and last elements within bound that are greater / lower than _x
		while {[_a select _i, _x] call _fn_compare < 0} do {_i=_i+1};
		while {[_a select _j, _x] call _fn_compare > 0} do {_j=_j-1};

		if (_i<=_j) then
		{
			//swap elements _i and _j
			_h = _a select _i;
			_a set [_i, _a select _j];
			_a set [_j, _h];

			_i=_i+1;
			_j=_j-1;
		};
	};

	// recursion
	if (_lo<_j) then {[_a, _fn_compare, _lo, _j] call _sort};
	if (_i<_hi) then {[_a, _fn_compare, _i, _hi] call _sort};
};

// and start it off
[_this select 0, _this select 1, 0, 0 max ((count (_this select 0))-1)] call _sort;

// array is already modified by reference, but return the modified array anyway
_this select 0
