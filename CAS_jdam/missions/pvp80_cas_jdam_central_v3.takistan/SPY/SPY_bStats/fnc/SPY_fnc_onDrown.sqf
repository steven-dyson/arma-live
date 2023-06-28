/*
	Author: Spyder (spyder@armalive.com)

	Description:
	Run where a drowning is detected by bStats.

	Parameter(s):
		0: OBJECT - victim who drowned

	Returns:
	BOOL
*/

scriptName "SPY_bStats_fnc_onDrown";

_v = [_this, 0, objNull, [objNull]] call BIS_fnc_param;

// Retrieve victim info
_vUID = _v getVariable "SPY_id_uid";
_vClass = typeOf _v;
_vName = SPY_container getVariable format ["SPY_id_%1", _vUID] select 0;
_vSide = SPY_container getVariable format ["SPY_id_%1", _vUID] select 1;
_vPos = getPosASL _v;

// Player death message
if ((SPY_bStats_msgsEnabled)) then 
{
	_null = [[5, (format ["%1 has drowned", _vName]), 0, ["SPY bStats", "Event Log"], false], "SPY_core_fnc_bMessage", true, false, false] call BIS_fnc_MP;
};

// Update score
[_vUID, "d", 1] call SPY_bStats_fnc_addScoreUnit;
[[_vSide], false] call SPY_bStats_fnc_addSideScore;

// CEH for hooks
_null = [[_v, _vUID, _vName, _vSide, _vPos, _vClass], "SPY_bStats_onDrown", 0, false] call SPY_core_fnc_cehExec;

true