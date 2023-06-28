/***************************************************************************
CURRENT WEAPON
CREATED BY SPYDER
SPYDER@ARMALIVE.COM
****************************************************************************/

private ["_unit", "_weapon"];

_unit = (_this select 0);

if ((vehicle _unit isKindOf "Man")) then {

	_weapon = (currentMuzzle _unit);
	
} else {

	_weapon = (typeOf vehicle _unit);
	
};

_weapon