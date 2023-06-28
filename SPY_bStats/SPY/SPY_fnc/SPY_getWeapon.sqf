/***************************************************************************
GET WEAPON
CREATED BY SPYDER
SPYDER@ARMALIVE.COM
****************************************************************************/

private ["_unit", "_victimUID", "_unitUID", "_ammoClass", "_wpnVar", "_weapon"];

_unit = (_this select 0);
_victimUID = (_this select 1);
_unitUID = (_this select 2);
_ammoClass = (_this select 3);

if ((isNil "_unitUID") || (_ammoClass == "")) exitWith {""};

_wpnVar = (format ["SPY_WPN_%1", (random 10000)]);

// DEBUG
// player sideChat format ["GET WEAPON: %1, %2, %3, %4", _victimUID, _unitUID, _ammoClass, _wpnVar];

_null = [[_unit, _ammoClass, _victimUID, _wpnVar], "_null = _this spawn SPY_sendWeapon;", _unitUID] spawn JDAM_mpCB;

waitUntil {!(isNil {_unit getVariable _wpnVar})};

_weapon = (_unit getVariable _wpnVar);

_unit setVariable [_wpnVar, nil, false];

_weapon