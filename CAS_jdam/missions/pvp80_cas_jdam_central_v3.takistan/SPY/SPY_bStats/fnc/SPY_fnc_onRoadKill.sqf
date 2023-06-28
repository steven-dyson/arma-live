/*
	Author: Spyder (spyder@armalive.com)

	Description:
	Run where a roadkill is detected by bStats.

	Parameter(s):
		0: OBJECT - victim who was killed
		1: OBJECT - killer
		2: ARRAY - list of valid assisting units

	Returns:
	BOOL
*/

scriptName "SPY_bStats_fnc_onRoadKill";

_v = [_this, 0, objNull, [objNull]] call BIS_fnc_param;
_k = [_this, 1, objNull, [objNull]] call BIS_fnc_param;
_assists = [_this, 2, [], [[]]] call BIS_fnc_param;

// Retrieve victim info
_vUID = _v getVariable "SPY_id_uid";
_vClass = typeOf _v;
_vName = SPY_container getVariable format ["SPY_id_%1", _vUID] select 0;
_vSide = SPY_container getVariable format ["SPY_id_%1", _vUID] select 1;
_vPos = getPosASL _v;

// Retrieve killer info
_kUID = _k getVariable "SPY_id_uid";
_kClass = typeOf _k;
_kName = SPY_container getVariable format ["SPY_id_%1", _kUID] select 0;
_kSide = SPY_container getVariable format ["SPY_id_%1", _kUID] select 1;
_kPos = getPosASL _k;
_kVehicle = _k getVariable "SPY_bStats_vehicle";

// Player Message
if ((SPY_bStats_msgsEnabled) && (SPY_bStats_msgsEnemy)) then
{
	_null = [[5, (format ["%1 ran over %2 (%3)", _kName, _vName, ([_kVehicle] call SPY_core_fnc_displayName)]), 0, ["SPY bStats", "Event Log"], false], "SPY_core_fnc_bMessage", true, false, false] call BIS_fnc_MP;
};

// Update score
_score = (["kill", 1, 0] call SPY_bStats_fnc_getScoreValue); // Retrieve score value of event
[_kUID, "sb", _score] call SPY_bStats_fnc_addScoreUnit; // Killer battle score
[_kUID, "ki", 1] call SPY_bStats_fnc_addScoreUnit; // Killer kills
[_vUID, "d", 1] call SPY_bStats_fnc_addScoreUnit; // Victim Deaths
[[_vSide, _kSide], true] call SPY_bStats_fnc_addSideScore; // Broadcast side score

// Kill assists
{
	_null = [_x] spawn SPY_bStats_fnc_onKillAssist;
}
forEach _assists;

// CEH for hooks
_null = [[_v, _vUID, _vName, _vSide, _vPos, _vClass, _k, _kUID, _kName, _kSide, _KPos, _kClass, _kVehicle, _assists, _score], "SPY_bStats_onRoadKill", 0, false] call SPY_core_fnc_cehExec;

true