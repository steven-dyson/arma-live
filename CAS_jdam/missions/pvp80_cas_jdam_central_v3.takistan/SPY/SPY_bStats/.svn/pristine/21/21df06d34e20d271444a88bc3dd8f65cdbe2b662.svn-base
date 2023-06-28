/*
	Author: Spyder (spyder@armalive.com)

	Description:
	Run where a vehicle kill is detected by bStats.

	Parameter(s):
		0: OBJECT - vehicle that was destroyed
		1: OBJECT - killer
		2: ARRAY - list of valid assisting units

	Returns:
	BOOL
*/

scriptName "SPY_bStats_fnc_onKill_veh";

private ["_kWeaponToDisplay", "_weaponType", "_score"];

_vVehicle = [_this, 0, objNull, [objNull]] call BIS_fnc_param;
_k = [_this, 1, objNull, [objNull]] call BIS_fnc_param;
_assists = [_this, 2, [], [[]]] call BIS_fnc_param;

// Retrieve vehicle info
_vVehicleUID = _vVehicle getVariable "SPY_bStats_uid";
_vVehicleSide = _vVehicle getVariable "SPY_bStats_side";
_vVehiclePos = getPosASL _vVehicle;
_vVehicleClass = typeOf _vVehicle;

// Retrieve killer info
_kUID = _k getVariable "SPY_id_uid";
_kName = SPY_container getVariable format ["SPY_id_%1", _kUID] select 0;
_kSide = SPY_container getVariable format ["SPY_id_%1", _kUID] select 1;
_kIsAI = SPY_container getVariable format ["SPY_id_%1", _kUID] select 3;
_kPos = getPosASL _k;
_kClass = typeOf _k;
_kDist = _vVehiclePos distance _kPos;

// Retrieve weapon used
_kWeapon = (_vVehicle getVariable "SPY_bStats_lastHitWeapon" select 0);
_kVehicle = (_vVehicle getVariable "SPY_bStats_lastHitWeapon" select 1);

// Determine weapon type of scoring and modify weapon for display
if (!isNull _kVehicle) then
{
	_kWeaponToDisplay = _kVehicle;
	_score = (["vehkill", [2, _vVehicle], _kDist] call SPY_bStats_fnc_getScoreValue);
}
else
{
	_kWeaponToDisplay = _kWeapon;
	_score = (["vehkill", [1, _vVehicle], _kDist] call SPY_bStats_fnc_getScoreValue);
};

// Player message
if ((SPY_bStats_msgsEnabled) && (SPY_bStats_msgsEnemy) && !(_kIsAI)) then
{
	_null = [[5, (format ["You killed a %1 (%2)", ([_vVehicle] call SPY_core_fnc_displayName), ([_kWeaponToDisplay] call SPY_core_fnc_displayName)]), 0, ["SPY bStats", "Event Log"], false], "SPY_core_fnc_bMessage", _k, false, false] call BIS_fnc_MP;
};

// Update score
[_kUID, "sb", _score] call SPY_bStats_fnc_addScoreUnit;
[_kUID, "kv", 1] call SPY_bStats_fnc_addScoreUnit;

// Kill assists
{
	_null = [_x] spawn SPY_bStats_fnc_onKillAssist;
}
forEach _assists;

// CEH for hooks
_null = [[_vVehicle, _vVehicleUID, _vVehicleSide, _vVehiclePos, _vVehicleClass, _k, _kUID, _kName, _kSide, _kPos, _kClass, _kWeapon, _kVehicle, _assists, _score], "SPY_bStats_onKill_veh", 0, false] call SPY_core_fnc_cehExec;

true