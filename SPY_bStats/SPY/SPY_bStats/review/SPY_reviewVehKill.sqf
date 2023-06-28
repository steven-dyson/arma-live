/***************************************************************************
SPY REVIEW VEHICLE KILL
CREATED BY SPYDER
SPYDER@ARMALIVE.COM
***************************************************************************/



/***************************************************************************
INIT
***************************************************************************/
private ["_vehicle", "_killer", "_vehicleInfo", "_vehicleSide", "_vehicleCrew", "_vehicleReset", "_damagingUnit", "_damagingUnitUID", "_dVarName", "_damagingUnitName", "_damagingUnitSide", "_assists", "_killerUID", "_kVarName", "_killerName", "_killerSide", "_kWeapon", "_dWeapon", "_ammo"];

_vehicle = (_this select 0);
_killer = (_this select 1);

_vehicleInfo = (_vehicle getVariable "SPY_VEHICLE_INFO");
_vehicleSide = (_vehicleInfo select 0);
_vehicleCrew = (_vehicleInfo select 4);
_vehicleReset = (_vehicleInfo select 7);

_damagingUnit = (_vehicleInfo select 2);
_damagingUnitUID = (_damagingUnit getVariable "SPY_PLAYER_ID" select 0);
_damagingUnitName = (_damagingUnit getVariable "SPY_PLAYER_ID" select 1);
_damagingUnitSide = (_damagingUnit getVariable "SPY_PLAYER_ID" select 2);
_dVarName = (format ["SPY_bStats_%1", _damagingUnitUID]);

_assists = [];

// NO SCORE FOR CIVILIAN (EMPTY) VEHICLES
if ((_vehicleSide == CIVILIAN)) exitWith {};
/***************************************************************************
END
***************************************************************************/



/***************************************************************************
DEFINE CORRECT KILLER
***************************************************************************/
// VEHICLE
if (!(_killer isKindOf "Man")) then {_killer = [false, _killer, objNull] call SPY_getUnit;};

_killerUID = (_killer getVariable "SPY_PLAYER_ID" select 0);
_killerName = (_killer getVariable "SPY_PLAYER_ID" select 1);
_killerSide = (_killer getVariable "SPY_PLAYER_ID" select 2);
_kVarName = (format ["SPY_bStats_%1", _killerUID]);

// STORE VEHICLE'S KILLER
if ((_killer in _vehicleCrew) || !(_killer isKindOf "Man")) then {_vehicleInfo set [5, _damagingUnit];} else {_vehicleInfo set [5, _killer];};

_vehicleInfo set [6, true];
_vehicle setVariable ["SPY_VEHICLE_INFO", _vehicleInfo, true];

// DEBUG
// _null = [[_killer, _damagingUnit], "SPY_GAMELOGIC globalChat format ['VK: %1, %2', (_this select 0), (_this select 1)];", "CLIENT"] spawn JDAM_mpCB;
/***************************************************************************
END
***************************************************************************/



/***************************************************************************
DEATH TYPE CHECKS
***************************************************************************/
// TEAM VEHICLE KILL CHECK (INSTANT)
if ((_killerSide == _vehicleSide) && !(isNull _killer) && !(_killer in _vehicleCrew)) exitWith {

	// RETRIEVE HIT AMMO & WEAPON USED
	_ammo = [_vehicle, "SPY_VEHICLE_INFO", 8] call SPY_getKillAmmo;
	_kWeapon = ([_killer, "SERVER", _killerUID, _ammo] call SPY_getWeapon);
	_dWeapon = ([_damagingUnit, "SERVER", _damagingUnitUID, _ammo] call SPY_getWeapon);

	[[_killerName, _killerUID, _kVarName, _vehicle, _kWeapon, (_killer distance _vehicle), (getPos _killer), (getPos _vehicle)], '_this call SPY_vehTK;'] call SPY_iQueueAdd;

};

// TEAM VEHICLE KILL CHECK (DAMAGE)
if ((_damagingUnitSide == _vehicleSide) && !(_damagingUnit in _vehicleCrew) && !(_vehicleReset)) exitWith {

	// RETRIEVE HIT AMMO & WEAPON USED
	_ammo = [_vehicle, "SPY_VEHICLE_INFO", 8] call SPY_getKillAmmo;
	_kWeapon = ([_killer, "SERVER", _killerUID, _ammo] call SPY_getWeapon);
	_dWeapon = ([_damagingUnit, "SERVER", _damagingUnitUID, _ammo] call SPY_getWeapon);

	[[_damagingUnitName, _damagingUnitUID, _dVarName, _vehicle, _dWeapon, (_damagingUnit distance _vehicle), (getPos _damagingUnit), (getPos _vehicle)], '_this call SPY_vehTK;'] call SPY_iQueueAdd;

};

// ENEMY VEHICLE KILL (INSTANT)
if (!(isNull _killer) && !(_killer in _vehicleCrew)) exitWith {

	// RETRIEVE HIT AMMO & WEAPON USED
	_ammo = [_vehicle, "SPY_VEHICLE_INFO", 8] call SPY_getKillAmmo;
	_kWeapon = ([_killer, "SERVER", _killerUID, _ammo] call SPY_getWeapon);
	_dWeapon = ([_damagingUnit, "SERVER", _damagingUnitUID, _ammo] call SPY_getWeapon);
	
	// DEFINE ASSIST (DAMAGING UNIT)
	if ((_damagingUnit != _vehicle) && (_damagingUnit != _killer) && (!(isNull _damagingUnit)) && (_damagingUnitSide != _vehicleSide)) then {

		_assists = (_assists + [_damagingUnit]);
		
	};
	
	// DEFINE ASSISTS (CREW)
	{
	
		if ((assignedVehicleRole _x select 0 != "CARGO") && (_x != _killer) && (_x != _damagingUnit)) then {
		
			_assists = (_assists + [_x]);
			
		};
	
	} forEach (crew (vehicle _killer));
	
	// SEND KILL & KILL ASSIST DATA
	[[_killer, _killerName, _killerUID, _kVarName, _vehicle, _kWeapon, (_killer distance _vehicle), (getPos _killer), (getPos _vehicle), _assists], '_this call SPY_vehKill;', SPY_bStats_delayMsgTime] call SPY_dQueueAdd;
	
};

// ENEMY VEHICLE KILL CHECK (DAMAGE)
if ((_vehicle != _damagingUnit) && (_damagingUnitSide != _vehicleSide) && !(isNull _damagingUnit) && !(_damagingUnit in _vehicleCrew)) exitWith {

	// RETRIEVE HIT AMMO & WEAPON USED
	_ammo = [_vehicle, "SPY_VEHICLE_INFO", 8] call SPY_getKillAmmo;
	_kWeapon = ([_killer, "SERVER", _killerUID, _ammo] call SPY_getWeapon);
	_dWeapon = ([_damagingUnit, "SERVER", _damagingUnitUID, _ammo] call SPY_getWeapon);
	
	// DEFINE ASSISTS (CREW)
	{
	
		if ((assignedVehicleRole _x select 0 != "CARGO") && (_x != _damagingUnit)) then {
		
			_assists = (_assists + [_x]);
			
		};
	
	} forEach (crew (vehicle _damagingUnit));
	
	// SEND KILL & KILL ASSIST DATA
	[[_damagingUnit, _damagingUnitName, _damagingUnitUID, _dVarName, _vehicle, _dWeapon, (_damagingUnit distance _vehicle), (getPos _killer), (getPos _vehicle), _assists], '_this call SPY_vehKill;', SPY_bStats_delayMsgTime] call SPY_dQueueAdd;
	
};
/***************************************************************************
END
***************************************************************************/