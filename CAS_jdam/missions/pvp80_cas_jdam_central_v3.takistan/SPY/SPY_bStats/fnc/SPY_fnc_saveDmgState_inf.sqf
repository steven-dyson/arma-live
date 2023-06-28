/*
	Author: Spyder (spyder@armalive.com)

	Description:
	Checks for valid hits based on damage amount and damager. If hit is valid damager is stored in array. Local variable prefixes are _v = victim and _d = damager.

	Parameter(s):
		0: OBJECT - unit who was injured
		1: NUMBER - damage to selection
		2: OBJECT - damager
		3: STRING - ammo used by damager

	Returns:
	BOOL
*/

scriptName "SPY_bStats_fnc_saveDmgState_inf";

private ["_d", "_vVehicleCrew", "_damagers", "_previousEntry"];

_v = [_this, 0, objNull, [objNull]] call BIS_fnc_param;
_selDmg = [_this, 2, 0, [0]] call BIS_fnc_param;
_d = [_this, 3, objNull, [objNull]] call BIS_fnc_param;
_dAmmo = [_this, 4, "", [""]] call BIS_fnc_param;

// Exit if unit is dead
if ((!alive _v)) exitWith { false };

// Retrieve all victim and damage info
_vUID = _v getVariable "SPY_id_uid";
_vSide = SPY_container getVariable format ["SPY_id_%1", _vUID] select 1;
_vVehicle = _v getVariable "SPY_bStats_vehicle";
_damagers = _v getVariable "SPY_bStats_damagers";

// Retrieve victim vehicle crew if applicable
if (!(isNull _vVehicle)) then 
{
	_vVehicleCrew = _vVehicle getVariable "SPY_bStats_crew";
}
else
{
	_vVehicleCrew = [];
};

// HandleDamage runs multiple times per hit, only run one time
_vHitVar = format ["SPY_bStats_hit_%1", [diag_tickTime, 1] call BIS_fnc_cutDecimals];

// Exit if one handle damage already with a valid damager, damager is null, self inflicted, or lack of significant damage
if ((!isNil {_v getVariable _vHitVar}) or (isNull _d) or (_d isEqualTo _v) or (_d in _vVehicleCrew) or (_selDmg < 0.01)) exitWith { false };

// Create variable
_v setVariable [_vHitVar, 1, false];

// Detect roadkill
_roadKill = ([_v] call SPY_bStats_fnc_detectRK);

// Use roadkill result if hit was from vehicle
if ((_roadKill select 0)) then 
{
	_d = (_roadKill select 1);
}
else
{
	// Killer was not type of man, run detection
	if (!(_d isKindOf "Man")) then 
	{
		_d = ([_d, _v, objNull, _dAmmo, false] call SPY_bStats_fnc_getUnit);
	};
};

// No damager found
if ((isNull _d)) exitWith { false };

// Lock death state at 1
if ((_vVehicle getVariable "SPY_bStats_deathState" isEqualTo 0)) then
{
	_vVehicle setVariable ["SPY_bStats_deathState", 1, true];
};

// For each saved damager, check against new damager. If found update selection.
{
	if (((_x select 0) isEqualTo _d)) exitWith 
	{
		_damagers set [_forEachIndex, [_d, ((_x select 1) + _selDmg), (time + 180)]];
		_previousEntry = true;
		if ((_previousEntry)) exitWith {};
	};
	
} forEach _damagers;

// Damager was not in list, add a new entry
if ((isNil "_previousEntry")) then 
{
	_damagers pushBack [_d, _selDmg, (time + 180)];
};

// Retrieve damager info
_dUID = (_d getVariable "SPY_id_uid");
_dSide = (SPY_container getVariable ("SPY_id_" + _dUID) select 1);

// Team damage
if ((_dSide isEqualTo _vSide) and (alive _v)) then 
{
	// Send out team damage event
	[[_d, _v], "_this call SPY_bStats_fnc_onTeamDmg;", "SERVER"] call CAS_mpCB;

	// Warning message, do not send to AI
	if ((SPY_bStats_msgsEnabled)) then 
	{
		[1, "Check fire! You are hitting friendlies!", 0, ["SPY ROE", "Event Log"], false] spawn SPY_core_fnc_bMessage;
	};
};

// Update death state and killer. Must run out of frame.
[_v, _d] spawn
{
	if ((!alive (_this select 0))) then
	{
		(_this select 0) setVariable ["SPY_bStats_killer", (_this select 1), true];
		(_this select 0) setVariable ["SPY_bStats_deathState", 2, true];
	};
	
	if ((alive (_this select 0)) and ((_this select 0) getVariable "SPY_bStats_deathState" isEqualTo 1)) then
	{
		(_this select 0) setVariable ["SPY_bStats_deathState", 0, true];
	};
};

// Debug
_null = [[1, (format ["SDSI: %1, %2", _v, _d]), 0, ["SPY Systems", "Debug Log"], false], "SPY_core_fnc_bMessage", true, false, false] call BIS_fnc_MP;

true