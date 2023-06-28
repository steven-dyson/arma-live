/*
	Author: Spyder (spyder@armalive.com)

	Description:
	Takes info from BIS Killed EH and then checks variables and runs functions to better determine the killer. Also awards scores for kills and TKs.

	Parameter(s):
		0: OBJECT - victim
		1: OBJECT - killer (as reported by BIS Killed EH)

	Returns:
	BOOL
*/

scriptName "SPY_bStats_fnc_refineKill_inf";

private ["_k", "_d", "_vVehicleCrew", "_kWeapon"];

_v = [_this, 0, objNull, [objNull]] call BIS_fnc_param;
_k = [_this, 1, objNull, [objNull]] call BIS_fnc_param;

// Define victim info
_vUID = _v getVariable "SPY_id_uid";
_damagingUnits = _v getVariable "SPY_bStats_damagers";
_vIsDriver = _v getVariable "SPY_bStats_isDriver";
_vVehicle = _v getVariable "SPY_bStats_vehicle";
_vName = (SPY_container getVariable format ["SPY_id_%1", _vUID] select 0);
_vSide = (SPY_container getVariable format ["SPY_id_%1", _vUID] select 1);
_vIsAI = (SPY_container getVariable format ["SPY_id_%1", _vUID] select 3);
_vPos = getPosASL _v;
_vClass = typeOf _v;
_vVehicleCrew = [];

// Retrieve vehicle crew info if required
if (!(isNull _vVehicle)) then
{
	_vVehicleCrew = _vVehicle getVariable "SPY_bStats_crew";
};

// Wait for saveDmgState to finish
if ((_v getVariable "SPY_bStats_deathState" > 0)) then
{
	waitUntil { _v getVariable "SPY_bStats_deathState" > 1; };
};

// Wait until killed victim vehicle has processed if vehicle is destroyed
if ((!isNull _vVehicle) and (_vVehicle getVariable "SPY_bStats_deathState" > 0) and (!alive _vVehicle)) then
{
	waitUntil { sleep 0.1; (_vVehicle getVariable "SPY_bStats_deathState" isEqualTo 3) };
};

// Check for roadkill
_roadKill = ([_v] call SPY_bStats_fnc_detectRK);

// Use roadkill to retrieve killer
if ((_roadKill select 0)) then
{
	_k = (_roadKill select 1);
	_kWeapon = (_roadKill select 2);
	_kVehicle = (_roadKill select 2);
}
else
{
	// Killer was not a playable unit, run detection
	if (!(_k isKindOf "Man") or ((!isNull _vVehicle) and (_k in _vVehicleCrew))) then
	{
		sleep 0.1;
		_k = ([_k, _v, _vVehicle, "", true] call SPY_bStats_fnc_getUnit);
	};
};

// %NOTE% No idea on this one
_vVehicle = _v getVariable "SPY_bStats_vehicle";

// Retrieve main damaging unit info. If killer is not defined use damager, otherwise use victim.
if (!(count _damagingUnits isEqualTo 0)) then
{
	_d = [_damagingUnits select (count _damagingUnits - 1), 0, _v, [_v]] call BIS_fnc_param;
	
	// Use damaging unit as killer
	if (!(_k isKindOf "Man") or (_k isEqualTo _v) and (_d isKindOf "Man")) then
	{
		_k = _d;
		
		// Use victim as killer
		if (!(_k isKindOf "Man")) then
		{
			_k = _v;
		};
	};
};

// Retrieve killer weapon and vehicle if event wasnt roadkill
if ((isNil "_kWeapon")) then
{	
	[[_v, _k], "SPY_bStats_fnc_getWeaponUsed", [_k], false, true] call BIS_fnc_MP;

	waitUntil { !isNil {_v getVariable "SPY_bStats_killerWeapon"} };

	_kWeapon = (_v getVariable "SPY_bStats_killerWeapon" select 0);
	_kVehicle = (_v getVariable "SPY_bStats_killerWeapon" select 1);
	
	// Default weapon, mainly for testing
	if ((isNil "_kWeapon")) then { _kWeapon = "Unknown"; _kVehicle = objNull; };
};

// Open scoreboard on death if enabled and unit not AI
if (!(_vIsAI)) then
{
	[] spawn SPY_bStats_fnc_openSbOnDeath;
};

// Debug
_null = [[1, (format ["RKI %1, %2", _k, _v]), 0, ["SPY Systems", "Debug Log"], false], "SPY_core_fnc_bMessage", true, false, false] call BIS_fnc_MP;

// Retrieve killer info
_kUID = _k getVariable "SPY_id_uid";
_kVehicle = _k getVariable "SPY_bStats_vehicle";
_kName = (SPY_container getVariable format ["SPY_id_%1", _kUID] select 0);
_kSide = (SPY_container getVariable format ["SPY_id_%1", _kUID] select 1);
_kIsAI = (SPY_container getVariable format ["SPY_id_%1", _kUID] select 3);
_kPos = getPosASL _k;
_kClass = typeOf _k;

// Get assists
_assists = [_vSide, _kUID, _v getVariable "SPY_bStats_damagers", _kVehicle getVariable "SPY_bStats_crew"] call SPY_bStats_fnc_getAssists;

// Road kill (team kill)
if ((_roadKill select 0) and (_kSide isEqualTo _vSide)) exitWith 
{
	[[_v, _k, _assists], "SPY_bStats_fnc_onTK_inf", false, false, true] call BIS_fnc_MP;
	_null = [_k, _kName, _kUID, _vName, _kIsAI] call SPY_roe_fnc_punish;
	_null = [[_v, _vUID, _vName, _vSide, _vPos, _vClass, _k, _kUID, _kName, _kSide, _kPos, _kClass, _kWeapon, _kVehicle, 0, _assists], "SPY_bStats_onTK_inf", 0, true] call SPY_core_fnc_cehExec;
	true
};

// Road kill (enemy)
if ((_roadKill select 0)) exitWith 
{
	[[_v, _k, _assists], "SPY_bStats_fnc_onRoadKill", false, false, true] call BIS_fnc_MP;
	_null = [[_v, _vUID, _vName, _vSide, _vPos, _vClass, _k, _kUID, _kName, _kSide, _kPos, _kClass, _kWeapon, _kVehicle, 0, _assists], "SPY_bStats_onRoadkill", 0, true] call SPY_core_fnc_cehExec;
	true
};

// Aircraft crash
if ((_vVehicle isKindOf "Air") and (!isNull _vVehicle) and (_vIsDriver) and ((!alive _vVehicle) or ((damage _vVehicle) >= 0.4)) and ((_vUID isEqualTo _kUID) or (isNull _k) and (_k in _vVehicleCrew)) and (!(_vVehicle isKindOf "ParachuteBase"))) exitWith 
{
	[[_v], "SPY_bStats_fnc_onCrash", false, false, true] call BIS_fnc_MP;
	_null = [_v, "Auto", _vUID, "Server", _vIsAI] call SPY_roe_fnc_punish;
	_null = [[_v, _vUID, _vName, _vSide, _vPos, _vClass, _vVehicle, (count _vVehicleCrew) - 1, 0], "SPY_bStats_onCrash", 0, true] call SPY_core_fnc_cehExec;
	true
};

// Player died with no killer or damaging unit
if (!(_k isKindOf "Man")) exitWith
{
	[[_v], "SPY_bStats_fnc_onDeath", false, false, true] call BIS_fnc_MP;
	_null = [[_v, _vUID, _vName, _vSide, _vPos, _vClass, 0], "SPY_bStats_onDeath", 0, true] call SPY_core_fnc_cehExec;
	true
};

// Drowning & suicide
if ((_kUID isEqualTo _vUID) and ((alive _vVehicle) or (isNull _vVehicle))) exitWith 
{
	// Was a drowning
	if ((getOxygenRemaining _v <= 0)) then 
	{
		[[_v], "SPY_bStats_fnc_onDrown", false, false, true] call BIS_fnc_MP;
		_null = [[_v, _vUID, _vName, _vSide, _vPos, _vClass, 0], "SPY_bStats_onDrown", 0, true] call SPY_core_fnc_cehExec;
	}
	// Was a suicide
	else 
	{
		[[_v], "SPY_bStats_fnc_onSuicide", false, false, true] call BIS_fnc_MP;
		_null = [[_v, _vUID, _vName, _vSide, _vPos, _vClass, 0], "SPY_bStats_onSuicide", 0, true] call SPY_core_fnc_cehExec;
	};
	true
};

// Team kill
if ((_kSide isEqualTo _vSide) and !(_k isEqualTo _v) and !(_k in _vVehicleCrew)) exitWith 
{
	[[_v, _k, _assists], "SPY_bStats_fnc_onTK_inf", false, false, true] call BIS_fnc_MP;
	_null = [_k, _kName, _kUID, _vName, _vIsAI] spawn SPY_roe_fnc_punish;
	_null = [[_v, _vUID, _vName, _vSide, _vPos, _vClass, _k, _kUID, _kName, _kSide, _kPos, _kClass, _kWeapon, _kVehicle, 0, _assists], "SPY_bStats_onTK_veh", 0, true] call SPY_core_fnc_cehExec;
	true
};

// Enemy kill
if (!(isNull _k) and !(_kSide isEqualTo _vSide)) exitWith 
{
	[[_v, _k, _assists], "SPY_bStats_fnc_onKill_inf", false, false, true] call BIS_fnc_MP;
	_null = [[_v, _vUID, _vName, _vSide, _vPos, _vClass, _k, _kUID, _kName, _kSide, _kPos, _kClass, _kWeapon, _kVehicle, 0, _assists], "SPY_bStats_onKill_inf", 0, true] call SPY_core_fnc_cehExec;
	true
};

// Error message
_null = [[2, "No kill defined refineKill_inf!", 0, ["SPY Systems", "Debug Log"], false], "SPY_core_fnc_bMessage", true, false, false] call BIS_fnc_MP;

false