// Garbage collector to remove empty groups
if (!isServer) exitWith {};

while {true} do
{
	{
		if (count units _x == 0) then
		{
			diag_log text format ["SqdMgt: Deleting empty group %1 (%2 groups)", _x, count allGroups];
			deleteGroup _x;
		};
	} forEach allGroups;

	sleep 60;
};

/*
_list = [];

while {true} do
{
	{
		if (count units _x == 0) then
		{
			if (!(_x in _list)) then
			{
				_list = _list + [[_x, time]];
			};
		};
	} forEach allGroups;

	sleep (30 + random 3);
	
	// only delete groups once they have been empty for a while, in case of bad server lag, etc.
	{
		if (time - (_x select 1) > 120) then
		{
			diag_log text format ["SqdMgt: Deleting empty group %1 (%2secs, %3 groups)", (_x select 0), ceil (time - (_x select 1)), count allGroups];
			deleteGroup (_x select 0);
			_list set [_forEachIndex, objNull];
		};
	} forEach _list;
	_list = _list - [objNull];
};
*/
