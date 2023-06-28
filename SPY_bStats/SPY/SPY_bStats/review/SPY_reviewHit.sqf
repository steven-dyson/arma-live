/***************************************************************************
REVIEW HIT
CREATED BY SPYDER
SPYDER@ARMALIVE.COM
***************************************************************************/



/***************************************************************************
INIT
***************************************************************************/
private ["_args", "_time", "_victim", "_selection", "_csDamage", "_damagingUnit", "_ammo", "_victimInfo", "_victimUID", "_victimSide", "_roadKill", "_start", "_damagingUnitUID", "_damagingUnitScoreVar", "_damagingUnitSide", "_hitVar", "_hitInfo", "_newDamage", "_oldDamage", "_oldDamagingUnit", "_selectionType", "_waitTime"];

_args = (_this select 0);
_time = (_this select 1);

_victim = (_args select 0);
_selection = (_args select 1);
_csDamage = (_args select 2);
_damagingUnit = (_args select 3);
_ammo = (_args select 4);

_victimInfo = (_victim getVariable "SPY_PLAYER_INFO");
_victimUID = (_victim getVariable "SPY_PLAYER_ID" select 0);
_victimSide = (_victim getVariable "SPY_PLAYER_ID" select 2);

SPY_PD_RESET = false;
_start = false;
/***************************************************************************
END
***************************************************************************/



/***************************************************************************
DEFINE CORRECT DAMAGING UNIT
***************************************************************************/
// ROADKILL
_roadKill = ([_victim] call SPY_detectRK);
if ((_roadKill select 0)) then {_damagingUnit = (_roadKill select 1);};

// VEHICLE
if (!(_damagingUnit isKindOf "Man")) then {_damagingUnit = ([false, _damagingUnit, objNull] call SPY_getUnit);};

// NO UNIT OR SELF INFLICTED
if ((isNull _damagingUnit) || (_damagingUnit == _victim)) exitWith {};
/***************************************************************************
END
***************************************************************************/



/***************************************************************************
GATHER DAMAGING UNIT INFO, FORMAT VARIABLE, DEFINE START
***************************************************************************/
_damagingUnitUID = (_damagingUnit getVariable "SPY_PLAYER_ID" select 0);
_damagingUnitSide = (_damagingUnit getVariable "SPY_PLAYER_ID" select 2);
_damagingUnitScoreVar = (format ["SPY_bStats_%1", _damagingUnitUID]);

_hitVar = (format ["SPY_%1_%2%3", _victim, round _time, round ((_time - round _time) * 1000)]);

if ((isNil {_victim getVariable _hitVar})) then {

	_victim setVariable [_hitVar, [], false];
	_start = true;

};
/***************************************************************************
END
***************************************************************************/



/***************************************************************************
PROCESS HANDLE DAMAGE DATA
***************************************************************************/
// GATHER CURRENT INFO
_hitInfo = (_victim getVariable _hitVar);

// SET DAMAGE INFO
_hitInfo set [count _hitInfo, [_csDamage, _damagingUnit, _damagingUnitUID, _selection, _ammo]];

// SET UNIT VARIABLE INFO
_victim setVariable [_hitVar, _hitInfo, false];

// EXIT IF NOT INITAL SCRIPT
if (!(_start)) exitWith {};

// ENSURE ARRAY IN FINISHED
sleep 0.2;

// RE-GATHER HIT INFO
_hitInfo = (_victim getVariable _hitVar);

// ORDER HIT INFO ARRAY BY HIGHEST DAMAGE
_hitInfo = [_hitInfo, 2, 0] call SPY_orderArrayA;

// USE ONLY HIGHEST DAMAGE
_hitInfo = (_hitInfo select 0);

// HIT VARIABLE NO LONGER REQUIRED
_victim setVariable [_hitVar, nil, false];

// OLD DAMAGE INFO
_oldDamage = (_victim getVariable "SPY_PLAYER_INFO" select 0);
_oldDamagingUnit = (_victim getVariable "SPY_PLAYER_INFO" select 1);

// CALCULATE NEW DAMAGE
_newDamage = ((damage _victim) - _oldDamage);

// COMBINE DAMAGE
if ((_oldDamagingUnit == _damagingUnit) && (_newDamage > 0.01)) then {_newDamage = (_newDamage + _oldDamage)};
/***************************************************************************
END
***************************************************************************/



/***************************************************************************
SEND & STORE DATA
***************************************************************************/
// TEAM DAMAGE
if ((alive _victim) && (_damagingUnitSide == _victimSide) && (_newDamage > 0.01)) then {
	
	[["damageTeam", _damagingUnitScoreVar, _victimUID, _damagingUnitUID, ([_damagingUnit, _damagingUnitUID, _victimUID, _ammo] call SPY_getWeapon), (_damagingUnit distance _victim), (getPos _victim), (getPos _damagingUnit)], "[_this, '_this call SPY_damage;'] call SPY_iQueueAdd", "SERVER"] call JDAM_mpCB_A;
	
	if ((SPY_bStats_msgsEnabled)) then {
	
		_null = [[], "SPY_GAMELOGIC globalChat 'CHECK FIRE! YOU ARE HITTING FRIENDLIES!';", _damagingUnitUID] spawn JDAM_mpCB;
	
	};
	
};

if ((_ammo != "")) then {_victimInfo set [7, _ammo];};
	
_victim setVariable ["SPY_PLAYER_INFO", _victimInfo, false];

// STORE DAMAGE DATA
if ((alive _victim) && (_newDamage > _oldDamage) && (_newDamage > 0.01)) then {

	_victimInfo set [0, _newDamage];
	_victimInfo set [1, _damagingUnit];
	_victimInfo set [2, _damagingUnitUID];
	
	_victim setVariable ["SPY_PLAYER_INFO", _victimInfo, false];
	
};

// FORMAT SELECTION
switch (_hitInfo select 3) do {

	case "head_hit": {_selectionType = 0;};
	case "body": {_selectionType = 1;};
	case "hands": {_selectionType = 2;};
	case "legs": {_selectionType = 3;};
	default {_selectionType = 1;};
	
};

// SEND HIT SELECTION TO DAMAGING UNIT (UTILIZE SPY QUEUE LATER)
if ((_damagingUnitSide != _victimSide) && (SPY_ALIVE_PLAYER)) then {[[_damagingUnit, _selectionType, _ammo], "_this call SPY_storeSelection;", _damagingUnitUID] call JDAM_mpCB_A;};

// DEBUG
// _null = [[_hitInfo, _ammo], "SPY_GAMELOGIC globalChat format ['PH: %1', _this select 0];", "CLIENT"] spawn JDAM_mpCB;
/***************************************************************************
END
***************************************************************************/



/***************************************************************************
SET DEAD / RESET DAMAGE (5 MIN OR HEAL)
***************************************************************************/
if ((!(alive _victim))) then {SPY_ALIVE_PLAYER = false;};

sleep 2;

SPY_PD_RESET = false;

_waitTime = time + 300;

waitUntil {(SPY_PD_RESET) || (damage _victim == 0) || (time > _waitTime)};

if ((SPY_PD_RESET) || (!(alive _victim))) exitWith {};

_victimInfo = (_victim getVariable "SPY_PLAYER_INFO");

_victimInfo set [0, 0];
_victimInfo set [1, objNull];
_victimInfo set [2, ""];

_victim setVariable ["SPY_PLAYER_INFO", _victimInfo, false];
/***************************************************************************
END
***************************************************************************/