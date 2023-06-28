/***************************************************************************
Review Vehicle Hit
Created by Spyder
spyder@armalive.com
***************************************************************************/

private ["_args", "_vehicle", "_d", "_ammo", "_vehicleInfo", "_vehicleSide", "_damagingUnitsInfo", "_damagePrevious", "_vehicleCrew", "_vehicleDamage", "_start", "_previousEntry", "_dUID", "_dSide", "_hitVar", "_damageInflicted", "_waitTime"];

_args = (_this select 0);

_vehicle = (_args select 0);
_d = (_args select 3);
_ammo = (_args select 4);

_vehicleSide = (_vehicle getVariable "SPY_bStats_side");
_vehicleCrew = (_vehicle getVariable "SPY_bStats_crew");

// Vehicle
if (!(_d isKindOf "Man")) then 
{
	_d = ([false, _d, objNull] call SPY_bStats_fnc_getUnit);
};

// No unit or self inflicted
if ((isNull _d) || (_d isEqualTo _vehicle) || (_vehicleSide isEqualTo CIVILIAN) || (_d in _vehicleCrew)) exitWith
{
	if (!(alive _vehicle)) then
	{
		_vehicle setVariable ["SPY_bStats_deathState", 2, true];
	};
};

// Gather additional vehicle info
_damagingUnitsInfo = (_vehicle getVariable "SPY_bStats_damagers");
_damagePrevious = (_vehicle getVariable "SPY_bStats_lastDamage");
_previousEntry = false;

// Gather damaging unit info
_dUID = (_d getVariable "SPY_id_uid");
_dName = (SPY_container getVariable ("SPY_id_" + _dUID) select 0);
_dSide = (SPY_container getVariable ("SPY_id_" + _dUID) select 1);
_dIsAI = (SPY_container getVariable ("SPY_id_" + _dUID) select 3);

// Calculate damage inflicted by hit
_damageInflicted = ((damage _vehicle) - _damagePrevious);

// Send ammo info
if (!(_ammo isEqualTo "")) then 
{
	_vehicle setVariable ["SPY_bStats_damagerAmmo", _ammo, true];
}
else
{
	_vehicle setVariable ["SPY_bStats_damagerAmmo", "explosives", true];
};

// If damaging inflicted < 0.01 stop here.
if ((_damageInflicted < 0.01)) exitWith {};

// Update damage info
{
	// Clear dummy entry
	if ((isNull (_x select 0))) then 
	{
		_damagingUnitsInfo set [0, -1];
		_damagingUnitsInfo = (_damagingUnitsInfo - [-1]);
	};
			
	// Previous entry
	if (((_x select 0) isEqualTo _d)) then 
	{
		_damageInflicted = ((_x select 1) + _damageInflicted);
		_damagingUnitsInfo set [_forEachIndex, [_d, _damageInflicted, (time + 180), _dUID, _dName, _dSide]];
	
		_previousEntry = true;
	};
	
	if ((_previousEntry)) exitWith {};
}
forEach _damagingUnitsInfo;

// Add new entry to array
if ((!_previousEntry)) then 
{
	_damagingUnitsInfo = (_damagingUnitsInfo + [[_d, _damageInflicted, (time + 180), _dUID, _dName, _dSide]]);
};

// Broadcast new damagers info
_vehicle setVariable ["SPY_bStats_damagers", _damagingUnitsInfo, true];
_vehicle setVariable ["SPY_bStats_lastDamage", (damage _vehicle), true];

// Broadcast valid damaging unit if vehicle is dead
if ((!alive _vehicle)) then 
{
	_vehicle setVariable ["SPY_bStats_deathState", 2, true];
};

// Send hit selection to damaging unit (%NOTE% utilize spy queue later)
if (!(_dSide isEqualTo _vehicleSide) && (!_dIsAI)) then 
{
	[[_d, 4, _ammo], "_this call SPY_storeSelection;", _dUID] call CAS_mpCB_A;
};

// Debug
_null = [[1, (format ["VH: %1, %2, %3", _d, _ammo, _vehicle]), 0, ["SPY Systems", "Debug Log"], false], "SPY_core_fnc_bMessage", true, false, false] call BIS_fnc_MP;