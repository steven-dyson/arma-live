/*
	Author: Spyder (spyder@armalive.com)

	Description:
	Run where a suicide is detected by bStats.

	Parameter(s):
		0: OBJECT - unit awarded kill assist

	Returns:
	BOOLEAN
*/

scriptName "SPY_bStats_fnc_onSuicide";

_v = [_this, 0, objNull, [objNull]] call BIS_fnc_param;

// Retrieve victim info
_vUID = _v getVariable "SPY_id_uid";
_vName = SPY_container getVariable format ["SPY_id_%1", _vUID] select 0;
_vSide = SPY_container getVariable format ["SPY_id_%1", _vUID] select 1;
_vPos = getPosASL _v;
_vClass = typeOf _v;

// Player message
if ((SPY_bStats_msgsEnabled)) then
{
	_null = [[5, (format ["%1 committed suicide", _vName]), 0, ["SPY bStats", "Event Log"], false], "SPY_core_fnc_bMessage", true, false, false] call BIS_fnc_MP;
};

// Add score
_score = (["suicide", objNull, 0] call SPY_bStats_fnc_getScoreValue);
[_vUID, "sb", _score] call SPY_bStats_fnc_addScoreUnit;
[_vUID, "s", 1] call SPY_bStats_fnc_addScoreUnit;
[_vUID, "d", 1] call SPY_bStats_fnc_addScoreUnit;

// Broadcast side score
[[_vSide], false] call SPY_bStats_fnc_addSideScore;

// CEH for hooks
_null = [[_v, _vUID, _vName, _vSide, _vPos, _vClass, _score], "SPY_bStats_onSuicide", 0, false] call SPY_core_fnc_cehExec;

true