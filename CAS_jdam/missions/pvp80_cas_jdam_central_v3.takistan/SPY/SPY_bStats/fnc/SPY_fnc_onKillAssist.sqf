/*
	Author: Spyder (spyder@armalive.com)

	Description:
	Run where a kill assist is detected by bStats.

	Parameter(s):
		0: OBJECT - unit awarded kill assist

	Returns:
	BOOLEAN
*/

scriptName "SPY_bStats_fnc_onKillAssist";

_unit = [_this, 0, objNull, [objNull]] call BIS_fnc_param;

_unitUID = _unit getVariable "SPY_id_uid";
_unitIsAI = (SPY_container getVariable format ["SPY_id_%1", _unitUID] select 3);

// Player Message
if ((SPY_bStats_msgsEnabled) and (SPY_bStats_msgsEnemy) and !(_unitIsAI)) then
{
	_null = [[5, "You got a kill assist", 0, ["SPY bStats", "Event Log"], false], "SPY_core_fnc_bMessage", [_unit], false, false] call BIS_fnc_MP;
};

// Retrieve score value of event
_score = (["killassist", objNull, 0] call SPY_bStats_fnc_getScoreValue); // Retrieve score value of event
[_unitUID, "sb", _score] call SPY_bStats_fnc_addScoreUnit; // Killer battle score
[_unitUID, "ka", 1] call SPY_bStats_fnc_addScoreUnit; // Killer kills

// CEH for hooks
_null = [[_unit, _unitUID, _score], "SPY_bStats_onKillAssist", 0, false] call SPY_core_fnc_cehExec;

true