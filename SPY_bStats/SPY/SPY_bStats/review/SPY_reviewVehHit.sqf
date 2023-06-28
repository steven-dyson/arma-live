/***************************************************************************
REVIEW VEHICLE HIT
CREATED BY SPYDER
SPYDER@ARMALIVE.COM
***************************************************************************/



/***************************************************************************
INIT
***************************************************************************/
private ["_args", "_time", "_vehicle", "_damagingUnit", "_ammo", "_vehicleInfo", "_vehicleSide", "_vehicleCrew", "_start", "_damagingUnitUID", "_damagingUnitSide", "_hitVar", "_newDamage", "_oldDamage", "_oldDamagingUnit", "_waitTime"];

_args = (_this select 0);
_time = (_this select 1);

_vehicle = (_args select 0);
_damagingUnit = (_args select 3);
_ammo = (_args select 4);

_vehicleInfo = (_vehicle getVariable "SPY_VEHICLE_INFO");
_vehicleSide = (_vehicleInfo select 0);
_vehicleCrew = (_vehicleInfo select 4);

SPY_VD_RESET = true;
_start = false;
/***************************************************************************
END
***************************************************************************/



/***************************************************************************
DEFINE CORRECT DAMAGING UNIT
***************************************************************************/
// VEHICLE
if (!(_damagingUnit isKindOf "Man")) then {_damagingUnit = ([false, _damagingUnit, objNull] call SPY_getUnit);};

// NO UNIT OR SELF INFLICTED
if ((isNull _damagingUnit) || (_damagingUnit == _vehicle) || (_vehicleSide == CIVILIAN) || (_damagingUnit in _vehicleCrew)) exitWith {};
/***************************************************************************
END
***************************************************************************/



/***************************************************************************
GATHER DAMAGING UNIT INFO, FORMAT VARIABLE, DEFINE START
***************************************************************************/
_damagingUnitUID = (_damagingUnit getVariable "SPY_PLAYER_ID" select 0);
_damagingUnitSide = (_damagingUnit getVariable "SPY_PLAYER_ID" select 2);

_hitVar = (format ["SPY_%1_%2%3", _vehicle, round _time, round ((_time - floor _time) * 1000)]);

if ((isNil {_vehicle getVariable _hitVar})) then {

	_vehicle setVariable [_hitVar, [], false];
	_start = true;

};
/***************************************************************************
END
***************************************************************************/



/***************************************************************************
PROCESS HANDLE DAMAGE DATA
***************************************************************************/
// EXIT IF NOT INITAL SCRIPT
if (!(_start)) exitWith {};

// OLD DAMAGE INFO
_oldDamage = (_vehicle getVariable "SPY_VEHICLE_INFO" select 1);
_oldDamagingUnit = (_vehicle getVariable "SPY_VEHICLE_INFO" select 2);

// CALCULATE ADDED DAMAGE
_newDamage = ((damage _vehicle) - _oldDamage);

// COMBINE DAMAGE
if ((_oldDamagingUnit == _damagingUnit) && (_newDamage > 0.01)) then {_newDamage = (_newDamage + _oldDamage)};
/***************************************************************************
END
***************************************************************************/



/***************************************************************************
SEND & STORE DATA
***************************************************************************/
if ((_ammo != "")) then {_vehicleInfo set [8, _ammo];};
	
_vehicle setVariable ["SPY_VEHICLE_INFO", _vehicleInfo, true];

// STORE DAMAGE DATA
if ((alive _vehicle) && (_newDamage > _oldDamage) && (_newDamage > 0.01)) then {

	_vehicleInfo set [1, _newDamage];
	_vehicleInfo set [2, _damagingUnit];
	_vehicleInfo set [3, _damagingUnitUID];
	
	_vehicle setVariable ["SPY_VEHICLE_INFO", _vehicleInfo, true];

};

// SEND HIT SELECTION TO DAMAGING UNIT (UTILIZE SPY QUEUE LATER)
if ((_damagingUnitSide != _vehicleSide)) then {[[_damagingUnit, 4, _ammo], "_this call SPY_storeSelection;", _damagingUnitUID] call JDAM_mpCB_A;};

// DEBUG
// _null = [[_vehicle, _newDamage], "SPY_GAMELOGIC globalChat format ['VH: %1, %2', (_this select 0), (_this select 1)];", "CLIENT"] spawn JDAM_mpCB;
/***************************************************************************
END
***************************************************************************/



/***************************************************************************
RESET DAMAGE (5 MIN OR HEAL)
***************************************************************************/
if ((!(alive _vehicle))) then {_vehicle removeAllEventHandlers "HandleDamage";};

sleep 2;

SPY_VD_RESET = false;

_waitTime = (time + 300);

waitUntil {(SPY_VD_RESET) || (damage _vehicle == 0) || (time > _waitTime)};

if ((SPY_VD_RESET) || (!(alive _vehicle))) exitWith {};

_vehicleInfo = (_vehicle getVariable "SPY_VEHICLE_INFO");

_vehicleInfo set [1, 0];
_vehicleInfo set [2, objNull];
_vehicleInfo set [3, ""];

_vehicle setVariable ["SPY_VEHICLE_INFO", _vehicleInfo, true];
/***************************************************************************
END
***************************************************************************/