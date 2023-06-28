/***************************************************************************
INTERSECTION FLOOR
CREATED BY SPYDER
SPYDER001@COMCAST.NET
****************************************************************************/

private ["_object"];

_object = (_this select 0);

// OBJECT WONT ACCEPT DAMAGE
_object addEventHandler ["HandleDamage",{}];

// SET OBJECT HEIGHT USING ASL
_object setPosASL [(getPosASL _object select 0), (getPosASL _object select 1), 14998.5];

// ROTATE FLAT
_object setVectorUp [0, 0, 0.00001];