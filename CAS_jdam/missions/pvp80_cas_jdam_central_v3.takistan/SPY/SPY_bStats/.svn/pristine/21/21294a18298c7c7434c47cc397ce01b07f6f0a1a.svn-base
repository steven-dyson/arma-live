/*
	Author: Spyder (spyder@armalive.com)

	Description:
	Review a hit spawned from HitPart EH against bStats fncs and variables to raise accuracy and call additional scripts 

	Parameter(s):
		0: OBJECT - unit was hit
		1: OBJECT - damager of unit (as reported by BIS HitPart EH)
		2: ARRAY - of selections (select 0 is the one we use)

	Returns:
	BOOL
*/

scriptName "SPY_bStats_fnc_refineHit_veh";

private ["_selectionType", "_d"];

_vVehicle = [_this, 0, objNull, [objNull]] call BIS_fnc_param;
_d = [_this, 1, objNull, [objNull]] call BIS_fnc_param;
_bullet = [_this, 2, objNull, [objNull]] call BIS_fnc_param;
_vSelection = [_this select 5, 0, "", [""]] call BIS_fnc_param;

// Exit if vehicle is dead
if ((!alive _vVehicle)) exitWith { false };

// Create variable name with name to nearest millisecond
_vHitVar = format ["SPY_bStats_hitP_%1", [diag_tickTime, 1] call BIS_fnc_cutDecimals];

// Exit if one HitPart ran within the same millisecond.
if ((!isNil {_vVehicle getVariable _vHitVar}) or (_vVehicle isEqualTo _d)) exitWith { false }; 

// Create variable
_vVehicle setVariable [_vHitVar, 0, false];

// Killer was not type of man, run detection
if (!(_d isKindOf "Man")) then 
{
	// Check for variable associated to bullet
	_d = SPY_container getVariable format ["SPY_bStats_%1_owner", _bullet];
	
	// Check for killer of nearby vehicle
	if (!(_d isKindOf "Man")) then
	{
		_d = ([_d, _vVehicle, objNull, ""] call SPY_bStats_fnc_getUnit);
	}
};

// Gather additional vehicle info
_vVehicleSide = _vVehicle getVariable "SPY_bStats_side";
_vVehicleCrew = _vVehicle getVariable "SPY_bStats_crew";

// Exit if damager is null, self inflicted, or in same vehicle
if ((isNull _d) or (_d isEqualTo _vVehicle) or (_d in _vVehicleCrew)) exitWith { false };

// Gather damaging unit info
_dUID = (_d getVariable "SPY_id_uid");
_dName = (SPY_container getVariable ("SPY_id_" + _dUID) select 0);
_dSide = (SPY_container getVariable ("SPY_id_" + _dUID) select 1);
_dIsAI = (SPY_container getVariable ("SPY_id_" + _dUID) select 3);
_dVar = (format ["SPY_bStats_%1", _dUID]);

// Retrieve weapon and vehicle
_dWeapon = SPY_container getVariable format ["SPY_bStats_%1_ownerWeapon", _bullet];
_dVehicle = SPY_container getVariable format ["SPY_bStats_%1_ownerVehicle", _bullet];

// Save damager weapon and vehicle
_d setVariable [format ["SPY_bStats_%1", _vVehicle], [_dWeapon, _dVehicle], true];

// Format selection
switch (_vSelection) do 
{
	case "body": {_selectionType = 6;};
	case "wheel": {_selectionType = 7;};
	case "engine": {_selectionType = 8;};
	case "windshield": {_selectionType = 9;};
	case "turret": {_selectionType = 10;};
	default {_selectionType = 6;};
};

// Store hit selection
if (!(_dSide isEqualTo _vVehicleSide) and !(_dIsAI)) then 
{
	[_d, _selectionType, _dWeapon, _dVehicle] spawn SPY_bStats_fnc_saveHit;
};

// Update damagers
//[[_vVehicle, _d], "SPY_bStats_fnc_updateDamagers_veh", false, false, true] call BIS_fnc_MP;

// Save killer data and delete hit variable. Spawn runs out of frame so death is detected.
[_vVehicle, _vHitVar, _d] spawn
{
	sleep 0.5;

	_vVehicle = [_this, 0, objNull, [objNull]] call BIS_fnc_param;
	_vHitVar = [_this, 1, "", [""]] call BIS_fnc_param;
	//_d = [_this, 2, objNull, [objNull]] call BIS_fnc_param;
	
	if ((!alive _vVehicle)) then
	{
		//_vVehicle setVariable ["SPY_bStats_killer", _d, true];
		//_vVehicle setVariable ["SPY_bStats_deathState", 3, true];
	};
	
	_vVehicle setVariable [_vHitVar, nil, false];
};

// Debug
_null = [[1, (format ["RH Veh: %1, %2, %3, SEL: '%4'", _this select 0, _d, _dWeapon, _vSelection]), 0, ["SPY Systems", "Debug Log"], false], "SPY_core_fnc_bMessage", true, false] call BIS_fnc_MP;

true