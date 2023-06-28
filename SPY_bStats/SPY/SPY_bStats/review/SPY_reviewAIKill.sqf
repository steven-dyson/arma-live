/***************************************************************************
REVIEW AI KILL
CREATED BY SPYDER
SPYDER@ARMALIVE.COM
****************************************************************************/



/***************************************************************************
INIT
****************************************************************************/
private ["_ai", "_killer", "_killerUID", "_kVarName", "_killerName", "_roadKill", "_weapon", "_ammo", "_hitAmmoV"];

_ai = (_this select 0);
_killer = (_this select 1);

_roadKill = ([_ai] call SPY_detectRK);
/***************************************************************************
END
****************************************************************************/



/***************************************************************************
DEFINE CORRECT KILLER/ VEHICLE CREW
****************************************************************************/
// ROADKILL
if ((_roadKill select 0)) then {_killer = (_roadKill select 1);};

// VEHICLE
if (!(_killer isKindOf "Man")) then {_killer = ([false, _killer, objNull] call SPY_getUnit);};
/***************************************************************************
END
****************************************************************************/

	
	
/***************************************************************************
GATHER KILLER INFO
***************************************************************************/
_killerUID = (_killer getVariable "SPY_PLAYER_ID" select 0);
_killerName = (_killer getVariable "SPY_PLAYER_ID" select 1);
_kVarName = (format ["SPY_bStats_%1", _killerUID]);
/***************************************************************************
END
****************************************************************************/



/***************************************************************************
RETRIEVE WEAPONS & HIT AMMO
****************************************************************************/
if (!(_roadkill select 0)) then {

	_hitAmmoV = (format ["SPY_hitAmmo_%1", _ai]);

	waitUntil {!(isNil {_ai getVariable _hitAmmoV})};

	_ammo = (_ai getVariable _hitAmmoV);
	_ai setVariable [_hitAmmoV, nil, false];

};

// WEAPON
_weapon = ([_killer, "SERVER", _killerUID, _ammo] call SPY_getWeapon);

// DEBUG
// _null = [[_killer, _weapon, _ammo], "SPY_GAMELOGIC globalChat format ['AIK %1, %2, %3', (_this select 0), (_this select 1), (_this select 2)];", "CLIENT"] spawn JDAM_mpCB;
/***************************************************************************
END
****************************************************************************/



/***************************************************************************
CHECK EVENT & SEND DATA
****************************************************************************/
// EXIT IF KILLER NOT DEFINED OR SELF INFLICTED
if (!(_killer isKindOf "Man") || (_killer == _ai)) exitWith {};

// CIVILIAN CASULALITY
if ((side _ai == civilian) && (count weapons _ai == 0) && (count magazines _ai == 0)) then {

	[[_killerName, _killerUID, _kVarName, _weapon, (_killer distance _ai), (getPos _ai), (getPos _killer)], "[_this, '_this call SPY_civCas;'] call SPY_iQueueAdd", "SERVER"] call JDAM_mpCB_A;
	
};
/***************************************************************************
END
****************************************************************************/