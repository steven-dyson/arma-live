/*
	Author: Spyder (spyder@armalive.com)

	Description:
	Run where a infantry kill is detected by bStats.

	Parameter(s):
		0: OBJECT - victim who was killed
		1: OBJECT - killer
		2: ARRAY - list of valid assisting units

	Returns:
	BOOL
*/

scriptName "SPY_bStats_fnc_onKill_inf";

private ["_kWeaponToDisplay", "_score"];

_v = [_this, 0, objNull, [objNull]] call BIS_fnc_param;
_k = [_this, 1, objNull, [objNull]] call BIS_fnc_param;
_assists = [_this, 2, [], [[]]] call BIS_fnc_param;

// Retrieve victim info
_vUID = _v getVariable "SPY_id_uid";
_vName = (SPY_container getVariable format ["SPY_id_%1", _vUID] select 0);
_vSide = (SPY_container getVariable format ["SPY_id_%1", _vUID] select 1);
_vIsAI = (SPY_container getVariable format ["SPY_id_%1", _vUID] select 3);
_vPos = getPosASL _v;
_vClass = typeOf _v;

// Retrieve killer info
_kUID = _k getVariable "SPY_id_uid";
_kName = (SPY_container getVariable format ["SPY_id_%1", _kUID] select 0);
_kSide = (SPY_container getVariable format ["SPY_id_%1", _kUID] select 1);
_kIsAI = (SPY_container getVariable format ["SPY_id_%1", _kUID] select 3);
_kPos = getPosASL _k;
_kClass = typeOf _k;
_kDist = _vPos distance _kPos;

// Retrieve weapon used
_kWeapon = (_v getVariable "SPY_bStats_lastHitWeapon" select 0);
_kVehicle = (_v getVariable "SPY_bStats_lastHitWeapon" select 1);

// Default weapon, mainly for testing
if ((isNil "_kWeapon")) then { _kWeapon = "Unknown"; _kVehicle = objNull; };

// Determine weapon type of scoring and modify weapon for display
if (!isNull _kVehicle) then
{
	_kWeaponToDisplay = _kVehicle;
	_score = (["kill", 2, 0] call SPY_bStats_fnc_getScoreValue);
}
else
{
	_kWeaponToDisplay = _kWeapon;
	_score = (["kill", 1, 0] call SPY_bStats_fnc_getScoreValue);
};

// Player message
if ((SPY_bStats_msgsEnabled) && (SPY_bStats_msgsEnemy)) then 
{
	_null = [[5, (format ["%1 killed %2 (%3)", _kName, _vName, ([_kWeaponToDisplay] call SPY_core_fnc_displayName)]), 0, ["SPY bStats", "Event Log"], false], "SPY_core_fnc_bMessage", true, false, false] call BIS_fnc_MP;
};

// Update score
[_kUID, "sb", _score] call SPY_bStats_fnc_addScoreUnit;
[_kUID, "ki", 1] call SPY_bStats_fnc_addScoreUnit;
[_vUID, "d", 1] call SPY_bStats_fnc_addScoreUnit;
[[_vSide, _kSide], true] call SPY_bStats_fnc_addSideScore;

// Kill assists
{
	_null = [_x] spawn SPY_bStats_fnc_onKillAssist;
}
forEach _assists;

// CEH for hooks
_null = [[_v, _vUID, _vName, _vSide, _vPos, _vClass, _k, _kUID, _kName, _kSide, _KPos, _kClass, _kWeapon, _kVehicle, _assists, _score], "SPY_bStats_onKill_inf", 0, false] call SPY_core_fnc_cehExec;

true