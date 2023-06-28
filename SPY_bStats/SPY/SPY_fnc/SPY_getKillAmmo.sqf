/***************************************************************************
GET AMMO
CREATED BY SPYDER
SPYDER@ARMALIVE.COM
****************************************************************************/

private ["_unit", "_variable", "_index", "_ammo"];

_unit = (_this select 0);
_variable = (_this select 1);
_index = (_this select 2);

waitUntil {(_unit getVariable _variable select _index) != ""};

_ammo = (_unit getVariable _variable select _index);

_ammo