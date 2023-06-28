/***************************************************************************
REVIEW KILL
CREATED BY SPYDER
SPYDER@ARMALIVE.COM
***************************************************************************/



/***************************************************************************
INIT
****************************************************************************/
private ["_player", "_killer", "_playerInfo", "_playerUID", "_pVarName", "_playerName", "_playerSide", "_inVehicle", "_driverVehicle", "_vehicle", "_vehicleReset", "_roadKill", "_damagingUnit", "_damagingUnitUID", "_dVarName", "_damagingUnitName", "_damagingUnitSide", "_assists", "_killerUID", "_kVarName", "_killerName", "_killerSide", "_vehicleCrew", "_kWeapon", "_dWeapon", "_ammo"];

_player = (_this select 0);
_killer = (_this select 1);

_playerUID = (_player getVariable "SPY_PLAYER_ID" select 0);
_playerName = (_player getVariable "SPY_PLAYER_ID" select 1);
_playerSide = (_player getVariable "SPY_PLAYER_ID" select 2);
_pVarName = (format ["SPY_bStats_%1", _playerUID]);
_playerInfo = (_player getVariable "SPY_PLAYER_INFO");
_inVehicle = (_playerInfo select 3);
_driverVehicle = (_playerInfo select 4);
_vehicle = (_playerInfo select 5);
_vehicleReset = (_vehicle getVariable "SPY_VEHICLE_INFO" select 7);

_damagingUnit = (_playerInfo select 1);
_damagingUnitUID = (_playerInfo select 2);
_dVarName = (format ["SPY_bStats_%1", _damagingUnitUID]);
_damagingUnitName = (_damagingUnit getVariable "SPY_PLAYER_ID" select 1);
_damagingUnitSide = (_damagingUnit getVariable "SPY_PLAYER_ID" select 2);

_assists = [];
/***************************************************************************
END
****************************************************************************/



/***************************************************************************
DEFINE CORRECT KILLER/ VEHICLE CREW
****************************************************************************/
if ((isNull _vehicle)) then {_vehicleCrew = [];} else {_vehicleCrew = (_vehicle getVariable "SPY_VEHICLE_INFO" select 4);};

_roadKill = ([_player] call SPY_detectRK);
if ((_roadKill select 0)) then {_killer = (_roadKill select 1);};
if (!(_killer isKindOf "Man") || ((_inVehicle) && (_killer in _vehicleCrew))) then {_killer = ([_inVehicle, _killer, _vehicle] call SPY_getUnit);};
if ((!(isNil "SPY_knifeKiller"))) then {_killer = SPY_knifeKiller;};
if ((!(isNil "SPY_gitKiller"))) then {_killer = SPY_gitKiller;};

_killerUID = (_killer getVariable "SPY_PLAYER_ID" select 0);
_killerName = (_killer getVariable "SPY_PLAYER_ID" select 1);
_killerSide = (_killer getVariable "SPY_PLAYER_ID" select 2);
_kVarName = (format ["SPY_bStats_%1", _killerUID]);

if ((isNil "_killerUID")) then {_killerUID = "";};

// DEBUG
// _null = [[_killer, _damagingUnit], "SPY_GAMELOGIC globalChat format ['PK %1, %2', _this select 0, _this select 1];", "CLIENT"] spawn JDAM_mpCB;
/***************************************************************************
END
****************************************************************************/



/***************************************************************************
RESET VARIABLES
****************************************************************************/
_null = [_playerUID] spawn SPY_reset;

[] spawn {

	sleep 2;

	if ((!(SPY_SCORE_OPEN)) && (SPY_bStats_scoreBoard)) then {
	
		_null = [] spawn SPY_checkScore;

		waitUntil {alive player};

		closeDialog 46;
	
	};
	
};
/***************************************************************************
END
****************************************************************************/
	
	
	
/***************************************************************************
DEATH TYPE CHECKS (W/O WEAPON CHECKS)
****************************************************************************/
// VALHALLA KNIFE KILL
if ((!(isNil "SPY_knifeKiller"))) exitWith {

	[[_killer, _killerName, _playerName, _killerUID, _playerUID, _killerSide, _kVarName, "Knife", 0, (getPos _killer), (getPos _player)], "[_this, '_this call SPY_kill;', SPY_bStats_delayMsgTime] call SPY_dQueueAdd", "SERVER"] call JDAM_mpCB_A;
	[["", "", "", _pVarName, _playerSide, false], "[_this, '_this call SPY_death;', SPY_bStats_delayMsgTime] call SPY_dQueueAdd", "SERVER"] call JDAM_mpCB_A;
	
};

// VALHALLA GRENADE IN TANK KILL
if ((!(isNil "SPY_gitKiller"))) exitWith {

	[[_killer, _killerName, _playerName, _killerUID, _playerUID, _killerSide, _kVarName, "HandGrenadeMuzzle2", 0, (getPos _killer), (getPos _player)], "[_this, '_this call SPY_kill;', SPY_bStats_delayMsgTime] call SPY_dQueueAdd", "SERVER"] call JDAM_mpCB_A;
	[["", "", "", _pVarName, _playerSide, false], "[_this, '_this call SPY_death;', SPY_bStats_delayMsgTime] call SPY_dQueueAdd", "SERVER"] call JDAM_mpCB_A;
	
};

// ROAD KILL
if ((_roadKill select 0)) exitWith {

	[[_killer, _killerName, _playerName, _killerUID, _playerUID, _kVarName, _killerSide, _playerSide, (vehicle _killer), (getPos _player)], "[_this, '_this call SPY_roadKill;', SPY_bStats_delayMsgTime] call SPY_dQueueAdd", "SERVER"] call JDAM_mpCB_A;
	[["", "", "", _pVarName, _playerSide, false], "[_this, '_this call SPY_death;', SPY_bStats_delayMsgTime] call SPY_dQueueAdd", "SERVER"] call JDAM_mpCB_A;
	
};

// AIRCRAFT CRASH
if ((_vehicle isKindOf "Air") && (_inVehicle) && (_driverVehicle) && (!alive _vehicle) && ((_playerUID == _killerUID) || (isNull _killer) || (_killer in _vehicleCrew)) && ((_damagingUnitUID == _playerUID) || (isNull _damagingUnit) || (_damagingUnit in _vehicleCrew)) && ((typeOf _vehicle) != "ParachuteC")) exitWith {

	[[_playerName, _playerUID, _pVarName, _vehicle, (getPos _player)], "[_this, '_this call SPY_acCrash;'] call SPY_iQueueAdd", "SERVER"] call JDAM_mpCB_A;
	[["", "", "", _pVarName, _playerSide, false], "[_this, '_this call SPY_death;'] call SPY_iQueueAdd", "SERVER"] call JDAM_mpCB_A;
	
};

// SUICIDE CHECK
if ((_killerUID == _playerUID) && (_damagingUnitUID == _playerUID) && ((alive _vehicle) || (isNull _vehicle))) exitWith {

	[[_playerName, _playerUID, _pVarName, (getPos _player)], "[_this, '_this call SPY_suicide;'] call SPY_iQueueAdd", "SERVER"] call JDAM_mpCB_A;
	[["", "", "", _pVarName, _playerSide, false], "[_this, '_this call SPY_death;'] call SPY_iQueueAdd", "SERVER"] call JDAM_mpCB_A;
	
};
/***************************************************************************
END
****************************************************************************/



/***************************************************************************
DEATH TYPE CHECKS (WITH WEAPON CHECKS)
****************************************************************************/
// TEAM KILL CHECK (INSTANT)
if ((_killerSide == _playerSide) && (_killer != _player) && (!(_killer in _vehicleCrew))) exitWith {

	// RETRIEVE HIT AMMO & WEAPON USED
	_ammo = [_player, "SPY_PLAYER_INFO", 7] call SPY_getKillAmmo;
	_kWeapon = ([_killer, _playerUID, _killerUID, _ammo] call SPY_getWeapon);
	_dWeapon = ([_damagingUnit, _playerUID, _damagingUnitUID, _ammo] call SPY_getWeapon);
	
	// SEND DATA TO SERVER
	[[_killerName, _playerName, _killerUID, _playerUID, _kVarName, _kWeapon, (_killer distance _player), (getPos _killer), (getPos _player)], "[_this, '_this call SPY_teamKill;'] call SPY_iQueueAdd", "SERVER"] call JDAM_mpCB_A;
	
};

// TEAM KILL CHECK (DAMAGE)
if ((_damagingUnitSide == _playerSide) && (_killerUID != _playerUID) && (!(_damagingUnit in _vehicleCrew)) && !(_vehicleReset)) exitWith {

	// RETRIEVE HIT AMMO & WEAPON USED
	_ammo = [_player, "SPY_PLAYER_INFO", 7] call SPY_getKillAmmo;
	_kWeapon = ([_killer, _playerUID, _killerUID, _ammo] call SPY_getWeapon);
	_dWeapon = ([_damagingUnit, _playerUID, _damagingUnitUID, _ammo] call SPY_getWeapon);

	// SEND DATA TO SERVER
	[[_damagingUnitName, _playerName, _damagingUnitUID, _playerUID, _dVarName, _dWeapon, (_damagingUnit distance _player), (getPos _damagingUnit), (getPos _player)], "[_this, '_this call SPY_teamKill;'] call SPY_iQueueAdd", "SERVER"] call JDAM_mpCB_A;
	
};

// ENEMY KILL (INSTANT)
if (!(isNull _killer) && (_killerUID != _playerUID) && (_killerSide != _playerSide)) exitWith {

	// RETRIEVE HIT AMMO & WEAPON USED
	_ammo = [_player, "SPY_PLAYER_INFO", 7] call SPY_getKillAmmo;
	_kWeapon = ([_killer, _playerUID, _killerUID, _ammo] call SPY_getWeapon);
	_dWeapon = ([_damagingUnit, _playerUID, _damagingUnitUID, _ammo] call SPY_getWeapon);
	
	// DEFINE ASSIST (DAMAGING UNIT)
	if ((_damagingUnitUID != _playerUID) && (_damagingUnitUID != _killerUID) && (!(isNull _damagingUnit)) && (_killerUID != _playerUID) && (_damagingUnitSide != _playerSide)) then {

		_assists = (_assists + [_damagingUnit]);

	};
	
	// DEFINE ASSISTS (CREW)
	{
	
		if ((assignedVehicleRole _x select 0 != "CARGO") && (_x != _killer) && (_x != _damagingUnit)) then {
		
			_assists = (_assists + [_x]);
			
		};
	
	} forEach (crew (vehicle _killer));
	
	// SEND KILL, DEATH & KILL ASSIST DATA
	[[_killer, _killerName, _playerName, _killerUID, _playerUID, _killerSide, _kVarName, _kWeapon, (_killer distance _player), (getPos _killer), (getPos _player), _assists], "[_this, '_this call SPY_kill;', SPY_bStats_delayMsgTime] call SPY_dQueueAdd", "SERVER"] call JDAM_mpCB_A;
	[["", "", "", _pVarName, _playerSide, false], "[_this, '_this call SPY_death;', SPY_bStats_delayMsgTime] call SPY_dQueueAdd", "SERVER"] call JDAM_mpCB_A;
	
};

// ENEMY KILL CHECK (DAMAGE)
if ((_killerUID == _playerUID) && (_damagingUnitSide != _playerSide) && !(isNull _damagingUnit)) exitWith {

	// RETRIEVE HIT AMMO & WEAPON USED
	_ammo = [_player, "SPY_PLAYER_INFO", 7] call SPY_getKillAmmo;
	_kWeapon = ([_killer, _playerUID, _killerUID, _ammo] call SPY_getWeapon);
	_dWeapon = ([_damagingUnit, _playerUID, _damagingUnitUID, _ammo] call SPY_getWeapon);
	
	// DEFINE ASSISTS (CREW)
	{
	
		if (((assignedVehicleRole _x select 0) != "CARGO") && (_x != _damagingUnit)) then {
		
			_assists = (_assists + [_x]);
			
		};
	
	} forEach (crew (vehicle _damagingUnit));
	
	// SEND KILL, DEATH & KILL ASSIST DATA
	[[_damagingUnit, _damagingUnitName, _playerName, _damagingUnitUID, _playerUID, _killerSide, _dVarName, _dWeapon, (_damagingUnit distance _player), (getPos _damagingUnit), (getPos _player), _assists], "[_this, '_this call SPY_kill;', SPY_bStats_delayMsgTime] call SPY_dQueueAdd", "SERVER"] call JDAM_mpCB_A;
	[["", "", "", _pVarName, _playerSide, false], "[_this, '_this call SPY_death;', SPY_bStats_delayMsgTime] call SPY_dQueueAdd", "SERVER"] call JDAM_mpCB_A;
	
};

// PLAYER DEATH (DEFAULT)
[[_playerUID, (getPos _player), _playerName, _pVarName, _playerSide, true], "[_this, '_this call SPY_death;', SPY_bStats_delayMsgTime] call SPY_dQueueAdd", "SERVER"] call JDAM_mpCB_A;
/***************************************************************************
END
****************************************************************************/