/*
	Author: Spyder (spyder@armalive.com)

	Description:
	Review a hit spawned from HitPart EH against bStats fncs and variables to raise accuracy and call additional scripts 

	Parameter(s):
		0: OBJECT - vehicle hit
		1: OBJECT - damager of vehicle (as reported by BIS HitPart EH)
		2: OBJECT - projectile which struck victim
		3: ARRAY - of selections (select 0 is the one we use)

	Returns:
	BOOL
*/

scriptName "SPY_bStats_fnc_refineHit_inf";

private ["_dWeapon", "_dVehicle", "_selectionType"];

_v = [_this, 0, objNull, [objNull]] call BIS_fnc_param;
_d = [_this, 1, objNull, [objNull]] call BIS_fnc_param;
_bullet = [_this, 2, objNull, [objNull]] call BIS_fnc_param;
_vSelection = [(_this select 5), 0, "", [""]] call BIS_fnc_param;

// Exit if unit is dead
if ((!alive _v)) exitWith { false };

// Create variable name with name to nearest millisecond
_vHitVar = format ["SPY_bStats_hitP_%1", [diag_tickTime, 1] call BIS_fnc_cutDecimals];

// Exit if one HitPart ran within the same millisecond.
if ((!isNil {_v getVariable _vHitVar})) exitWith { false }; 

// Create variable
_v setVariable [_vHitVar, 0, false];

// Detect roadkill
_roadKill = ([_v] call SPY_bStats_fnc_detectRK);

// Use roadkill result if hit was from vehicle
if ((_roadKill select 0)) then 
{
	_d = (_roadKill select 1);
	_dWeapon = (_roadKill select 2);
}
else
{
	// Killer was not type of man, run detection
	if (!(_d isKindOf "Man")) then 
	{
		// Check for variable associated to bullet
		_d = SPY_container getVariable format ["SPY_bStats_%1_owner", _bullet];
		
		// Check for killer of nearby vehicle
		if (!(_d isKindOf "Man")) then
		{
			_d = ([_d, _v, _vVehicle, "", false] call SPY_bStats_fnc_getUnit);
		}
	};
};

// Retrieve weapon and vehicle
_dWeapon = SPY_container getVariable format ["SPY_bStats_%1_ownerWeapon", _bullet];
_dVehicle = SPY_container getVariable format ["SPY_bStats_%1_ownerVehicle", _bullet];

// Gather additional victim info
_vUID = (_v getVariable "SPY_id_uid");
_vSide = (SPY_container getVariable format ["SPY_id_%1", _vUID] select 1);
_vVehicle = _v getVariable "SPY_bStats_vehicle";
_vVehicleCrew = _vVehicle getVariable "SPY_bStats_crew";

// Exit if damager is null, self inflicted, or in same vehicle
if ((isNull _d) or (_d isEqualTo _v) or (_d in _vVehicleCrew)) exitWith { false };

// Gather damaging unit info
_dUID = _d getVariable "SPY_id_uid";
_dName = (SPY_container getVariable format ["SPY_id_%1", _dUID] select 0);
_dSide = (SPY_container getVariable format ["SPY_id_%1", _dUID] select 1);
_dIsAI = (SPY_container getVariable format ["SPY_id_%1", _dUID] select 3);
_dVar = format ["SPY_bStats_%1", _dUID];

// Format selection
switch (_vSelection) do 
{
	case "head": {_selectionType = 0;};
	
	case "spine1": {_selectionType = 1;};
	case "spine2": {_selectionType = 1;};
	case "spine3": {_selectionType = 1;};
	
	case "rightupleg": {_selectionType = 2;};
	case "rightleg": {_selectionType = 2;};
	case "rightfoot": {_selectionType = 2;};
	
	case "leftupleg": {_selectionType = 3;};
	case "leftleg": {_selectionType = 3;};
	case "leftfoot": {_selectionType = 3;};
	
	case "rightarm": {_selectionType = 4;};
	case "rightforearm": {_selectionType = 4;};
	
	case "leftarm": {_selectionType = 5;};
	case "leftforearm": {_selectionType = 5;};
	
	default {_selectionType = 1;};
};

// Store hit selection
if (!(_dSide isEqualTo _vSide) and !(_dIsAI)) then 
{
	[_d, _selectionType, _dWeapon, _dVehicle] call SPY_bStats_fnc_saveHit;
};

// Save damager weapon and vehicle
_d setVariable [format ["SPY_bStats_%1", _v], [_dWeapon, _dVehicle], true];

// Save killer data and delete hit variable. Spawn runs out of frame so death is detected.
[_v, _vHitVar, _d] spawn
{
	_v = [_this, 0, objNull, [objNull]] call BIS_fnc_param;
	_vHitVar = [_this, 1, "", [""]] call BIS_fnc_param;
	_d = [_this, 2, objNull, [objNull]] call BIS_fnc_param;
	
	if ((!alive _v)) then
	{
		(_this select 0) setVariable ["SPY_bStats_killer", _d, true];
		(_this select 0) setVariable ["SPY_bStats_deathState", 3, true];
	};
	
	sleep 2;
	_v setVariable [_vHitVar, nil, false];
};

// Debug
_null = [[1, (format ["RH Inf: %1, %2, %3, SEL: '%4'", _v, _d, [_dWeapon, _dVehicle], _vSelection]), 0, ["SPY Systems", "Debug Log"], false], "SPY_core_fnc_bMessage", true, false, false] call BIS_fnc_MP;

true