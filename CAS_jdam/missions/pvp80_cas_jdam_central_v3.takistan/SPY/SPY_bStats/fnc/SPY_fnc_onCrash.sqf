/*
	Author: Spyder (spyder@armalive.com)

	Description:
	Run where an aircraft crash is detected by bStats.

	Parameter(s):
		0: OBJECT - victim who was killed

	Returns:
	BOOL
*/

scriptName "SPY_bStats_fnc_onCrash";

_v = [_this, 0, objNull, [objNull]] call BIS_fnc_param;

// Retrieve victim info
_vUID = _v getVariable "SPY_id_uid";
_vClass = typeOf _v;
_vName = SPY_container getVariable format ["SPY_id_%1", _vUID] select 0;
_vSide = SPY_container getVariable format ["SPY_id_%1", _vUID] select 1;
_vPos = getPosASL _v;

// Get vehicle and crew count
_vVehicle = _v getVariable "SPY_bStats_vehicle";
_vVehicleCrew = (_vVehicle getVariable "SPY_bStats_crew");
_vVehicleCrewCount = ((count _vVehicleCrew) - 1);

// Player message
if ((SPY_bStats_msgsEnabled)) then
{
	_null = [[5, (format ["%1 crashed their %2 (%3 passengers)", _vName, ([_vVehicle] call SPY_core_fnc_displayName), _vVehicleCrewCount]), 0, ["SPY bStats", "Event Log"], false], "SPY_core_fnc_bMessage", true, false, false] call BIS_fnc_MP;
};

// Update score
_score = (["accrash", objNull, _vVehicleCrewCount] call SPY_bStats_fnc_getScoreValue);
[_vUID, "sb", _score] call SPY_bStats_fnc_addScoreUnit;
[_vUID, "acc", 1] call SPY_bStats_fnc_addScoreUnit;
[_vUID, "d", 1] call SPY_bStats_fnc_addScoreUnit;
[[_vSide], false] call SPY_bStats_fnc_addSideScore;

// CEH for hooks
_null = [[_v, _vUID, _vName, _vSide, _vPos, _vClass, _vVehicle, _vVehicleCrewCount, _score], "SPY_bStats_onCrash", 0, false] call SPY_core_fnc_cehExec;

true