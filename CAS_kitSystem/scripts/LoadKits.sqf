private "_folderScriptsWest";
private "_folderScriptsEast";
private "_rank";
private "_code";
waitUntil {(!isNil "JDAM_WEST_KIT_CRATE") && (!isNil "JDAM_EAST_KIT_CRATE")};
_folderScriptsWest = call compile preProcessFile "CAS\CAS_kitSystem\WEST\ScriptList.sqf";
_folderScriptsEast = call compile preProcessFile "CAS\CAS_kitSystem\EAST\ScriptList.sqf";					
_rank = 50;
{
	_code = call compile preProcessFile format["%1\%2.sqf", "CAS\CAS_kitSystem\WEST", _x];
	if (!((_code select 6) in ["WestDefaultKit", "EastDefaultKit"])) then
	{
		_null = [_code, JDAM_WEST_KIT_CRATE, _rank] call PlayerKits_KitActionUpdater;
		_rank = _rank + 1;
	};
} foreach _folderScriptsWest;
_rank = 0;
{
	_code = call compile preProcessFile format["%1\%2.sqf", "CAS\CAS_kitSystem\EAST", _x];
	if ((_code select 6) != "DefaultKit") then
	{
		_null = [_code, JDAM_EAST_KIT_CRATE, _rank] call PlayerKits_KitActionUpdater;
		_rank = _rank + 1;
	};
} foreach _folderScriptsEast;

