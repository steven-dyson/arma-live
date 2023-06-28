// Desc: return a sorted list of groups
// Warning: very slow function. Many nested iterations. Up to 1x4x4x9x13=1872 iterations for a non-match.
// TODO: optimise
//-----------------------------------------------------------------------------
#define _c_groupNames [\
	"Alpha" , "Bravo", "Charlie", "Delta", "Echo", "Foxtrot", "Golf", "Hotel", \
	"India", "Juliet", "Kilo", "Lima", "Mike", "November", "Oscar", "Papa", "Quebec", \
	"Romeo", "Sierra", "Tango", "Uniform", "Victor", "Whisky", "Xray1", "Yankee", "Zulu"\
]

private ["_group", "_myGroup", "_groupName", "_array", "_letter"];
_group = _this;

_myGroup = "";
//if (_group == group player) then { _myGroup = format [" %1", localize "STR_ICE_sqdMgt_38"] };

_groupName = format ["%1", _group];
if (isNull _group) then {_groupName = localize "STR_ICE_sqdMgt_66"}; // Unassigned

_array = toArray _groupName;
if (count _array >= 7 && _groupName != localize "STR_ICE_sqdMgt_66") then // Unassigned
{
	// check that array follows Arma 2 group string syntax. Eg: "B 4-4-M"
	if (
		(_array select 1 == 32) && // ' '=32
		(_array select 3 == 45) && // '-'=45
		(_array select 5 == 45)) then
	{
		_letter = _array select 6;
		_letter = _letter-65;
		if ((_letter >= 0) && (_letter < 26)) then // although technically, it only goes up to 13 ("M").
		{
			// strip off first 2 chars: "B "
			_array set [0, 64]; // @=64, use this as deletion character value.
			_array set [1, 64];
			// strip off last group char: "M"
			_array set [6, 64];
			// remove chars
			_array = _array-[64]; // TODO: slow command. It may be faster to shift bytes and resize array.
			//_array reSize (count _array -1);
			// append "alpha" squad name
			_groupName = (toString _array) + (_c_groupNames select _letter);
		};
	}
	else
	{
		// strip off first 2 chars: "B "
		_array set [0, 64]; // @=64
		_array set [1, 64];
		// remove chars
		_array = _array - [64]; // TODO: slow command. It may be faster to shift bytes and resize array.
		// keep original name
		_groupName = (toString _array);
	};
};

format ["%1%2", _groupName, _myGroup]
