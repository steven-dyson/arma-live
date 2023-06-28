/***************************************************************************
Review Hit
Created by Spyder
spyder@armalive.com
***************************************************************************/



/***************************************************************************
Init
***************************************************************************/
private ["_args", "_time", "_v", "_selection", "_csDamage", "_d", "_ammo", "_vInfo", "_damagingUnitsInfo", "_damagePrevious", "_vUID", "_vSide", "_start", "_previousEntry", "_roadKill", "_dUID", "_dSide", "_dVar", "_hitVar", "_hitInfo", "_damageInflicted", "_selectionType", "_waitTime", "_weapon"];

_args = (_this select 0);
_time = (_this select 1);

_v = (_args select 0);
_selection = (_args select 1);
_csDamage = (_args select 2);
_d = (_args select 3);
_ammo = (_args select 4);

_vInfo = (_v getVariable "SPY_player_info");

_start = false;
_previousEntry = false;
/***************************************************************************
Init
***************************************************************************/



/***************************************************************************
Define correct damaging unit
***************************************************************************/
// Roadkill
_roadKill = ([_v] call SPY_bStats_fnc_detectRK);

if ((_roadKill select 0)) then 
{
	_d = (_roadKill select 1);
	_weapon = (_roadKill select 2);
}
else
{
	// Vehicle
	if (!(_d isKindOf "Man")) then 
	{
		_d = ([false, _d, objNull] call SPY_bStats_fnc_getUnit);
	};
};

// No unit, self inflicted, dead, or in same vehicle
if ((isNull _d) || (_d isEqualTo _v) || (_d in (crew (vehicle _v)))) exitWith 
{
	// Victim ready for death processing
	if (!(alive _v)) then 
	{
		_vInfo set [6, "None"];
		_v setVariable ["SPY_bStats_deathState", 2, false];
	};
};

// Valid unit ammo stored
if (!(_ammo isEqualTo "")) then 
{
	_vInfo set [6, _ammo];
};
/***************************************************************************
Define correct damaging unit
***************************************************************************/



/***************************************************************************
Gather damaging unit info, format variable, define start
***************************************************************************/
_dUID = (_d getVariable "SPY_id_uid");
_dSide = (SPY_container getVariable ("SPY_id_" + _dUID) select 1);
_dVar = (format ["SPY_bStats_%1", _dUID]);

_hitVar = (format ["SPY_%1_%2%3", _v, (round _time), (round (_time - (round _time)))]);

if ((isNil {_v getVariable _hitVar})) then 
{
	_v setVariable [_hitVar, [], false];
	_start = true;
};
/***************************************************************************
Gather damaging unit info, format variable, define start
***************************************************************************/



/***************************************************************************
Process handle damage data
***************************************************************************/
// Gather current info
_hitInfo = (_v getVariable _hitVar);

// Set damage info
_hitInfo set [count _hitInfo, [_csDamage, _d, _dUID, _selection, _ammo]];

// Set unit variable info
_v setVariable [_hitVar, _hitInfo, false];

// Exit if not initial script
if (!(_start)) exitWith {};

// Gather additional victim info
_vUID = (_v getVariable "SPY_id_uid");
_vSide = (SPY_container getVariable ("SPY_id_" + _vUID) select 1);
_damagingUnitsInfo = (_vInfo select 0);
_damagePrevious = (_vInfo select 1);

// Change UID to "SERVER" if unit is AI
if ((SPY_container getVariable ("SPY_id_" + _vUID) select 3)) then
{
	_vUID = "SERVER";
};

// Ensure array in finished
sleep 0.2;

// Re-gather hit info
_hitInfo = (_v getVariable _hitVar);

// Order hit info array by highest damage
_hitInfo = [_hitInfo, 2, 0] call SPY_orderArrayA;

// Use only highest damage
_hitInfo = (_hitInfo select 0);

// Hit variable no longer required
_v setVariable [_hitVar, nil, false];

// Calculate new damage
_damageInflicted = ((damage _v) - _damagePrevious);
/***************************************************************************
Process handle damage data
***************************************************************************/



/***************************************************************************
Send & store data
***************************************************************************/
// Team damage
if ((_dSide isEqualTo _vSide) && (_damageInflicted > 0.01) && (alive _v)) then 
{
	if ((isNil "_weapon")) then
	{
		_weapon = ([_d, _vUID, _dUID, _ammo, 0] call SPY_getWeapon);
	};
	
	// Send out team damage event. Don't waste bandwidth on AI.
	if ((SPY_container getVariable ("SPY_id_" + _dUID) select 3)) then
	{
		["damageTeam", _dVar, _vUID, _dUID, _weapon, (_d distance _v), (getPos _v), (getPos _d)] call SPY_damage;
	}
	else
	{
		[["damageTeam", _dVar, _vUID, _dUID, _weapon, (_d distance _v), (getPos _v), (getPos _d)], "_this call SPY_damage;", "SERVER"] call CAS_mpCB;
	};

	// Warning message, do not send to AI
	if ((SPY_bStats_msgsEnabled) && !(SPY_container getVariable ("SPY_id_" + _dUID) select 3)) then 
	{
		_null = [[1, "CHECK FIRE! YOU ARE HITTING FRIENDLIES!", 0, ["SPY ROE", "Event Log"], false], "SPY_core_fnc_bMessage", _d, false] call BIS_fnc_MP;
	};
};

// Update damage info
_dUID = (_d getVariable "SPY_id_uid");
_dName = (SPY_container getVariable ("SPY_id_" + _dUID) select 0);
_dSide = (SPY_container getVariable ("SPY_id_" + _dUID) select 1);
_dIsAI = (SPY_container getVariable ("SPY_id_" + _dUID) select 3);

{
	// Previous entry
	if (((_x select 0) isEqualTo _d)) exitWith 
	{
		_damageInflicted = ((_x select 1) + _damageInflicted);
		_damagingUnitsInfo set [_forEachIndex, [_d, _damageInflicted, (time + 180), _dUID, _dName, _dSide, _dIsAI]];
		_vInfo set [0, _damagingUnitsInfo];
		
		_previousEntry = true;
		
		if ((_previousEntry)) exitWith {};
	};
	
} forEach _damagingUnitsInfo;

// Clear dummy entry and replace with new entry
if (_v in (_damagingUnitsInfo select 0)) then 
{
	_damagingUnitsInfo set [0, [_d, _damageInflicted, (time + 180), _dUID, _dName, _dSide, _dIsAI]];
	_vInfo set [0, _damagingUnitsInfo];
}
// Add entry to array with previous entries
else
{
	if ((!_previousEntry)) then 
	{
		_damagingUnitsInfo = (_damagingUnitsInfo + [[_d, _damageInflicted, (time + 180), _dUID, _dName, _dSide, _dIsAI]]);
		_vInfo set [0, _damagingUnitsInfo];
	};
};

// Overall victim damage
_vInfo set [1, (damage _v)];

// Victim ready for death processing
if (!(alive _v)) then 
{
	_v setVariable ["SPY_bStats_deathState", 2, false];
}
else
{
	_v setVariable ["SPY_bStats_deathState", 0, false];
};

// Format selection
switch (_hitInfo select 3) do 
{
	case "head": {_selectionType = 0;};
	case "body": {_selectionType = 1;};
	case "hands": {_selectionType = 2;};
	case "hand_l": {_selectionType = 2;};
	case "hand_r": {_selectionType = 2;};
	case "legs": {_selectionType = 3;};
	case "leg_l": {_selectionType = 3;};
	case "leg_r": {_selectionType = 3;};
	default {_selectionType = 1;};
};

// Send hit selection to damaging unit, do not send to AI (utilize spy queue later)
if ((_dSide != _vSide) && !(_dIsAI)) then 
{
	[[_d, _selectionType, _ammo], "_this call SPY_storeSelection;", _dUID] call CAS_mpCB_A;
};

// Debug
_null = [[1, (format ["PH: %1, %2, %3", _v, _d, (_hitInfo select 3)]), 0, ["SPY Systems", "Debug Log"], false], "SPY_core_fnc_bMessage", true, false, false] call BIS_fnc_MP;
/***************************************************************************
Send & store data
***************************************************************************/