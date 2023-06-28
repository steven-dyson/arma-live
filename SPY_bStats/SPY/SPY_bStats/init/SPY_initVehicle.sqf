/***************************************************************************
INITILIZE VEHICLE
CREATED BY SPYDER
SPYDER@ARMALIVE.COM
****************************************************************************/



/***************************************************************************
ADD VEHICLE EVENT HANDLERS

VEHICLE INFO: [VEHICLE SIDE, DAMAGE, DAMAGING UNIT, DAMAGING UNIT UID, CREW, KILLER, VALID KILLER, SIDE SWITCH, KILLED AMMO]
****************************************************************************/
private ["_vehicle", "_side"];

_vehicle = (_this select 0);
_side = (_this select 1);

if ((isNil {_vehicle getVariable "SPY_VEHICLE_INFO"})) then {

	_vehicle setVariable ["SPY_VEHICLE_INFO", [_side, 0, objNull, "", (crew _vehicle), objNull, false, false, ""], true];
	
};

_vehicle addEventHandler ["HandleDamage", {_null = [_this, time] spawn SPY_reviewVehHit; _this select 2;}];
_vehicle addEventHandler ["Killed", {_null = [[(_this select 0), (_this select 1)], "_null = _this spawn SPY_reviewVehKill", "SERVER"] spawn JDAM_mpCB}];

// DEBUG
// _null = [[_vehicle, _side], "player sideChat format ['IV: %1, %2', (_this select 0), (_this select 1)];", "CLIENT"] spawn JDAM_mpCB;
/***************************************************************************
END
****************************************************************************/