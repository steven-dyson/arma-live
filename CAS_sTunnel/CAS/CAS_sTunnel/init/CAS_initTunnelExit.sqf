/***************************************************************************
INITILIZE TUNNEL EXIT
CREATED BY SPYDER
SPYDER001@COMCAST.NET
****************************************************************************/

// _null = [this, false] execVM "CAS/CAS_sTunnel/CAS_initTunnelExit.sqf";
private ["_object", "_isExit", "_entranceObject", "_startHeight", "_excessHeight", "_newHeight"];

_object = (_this select 0);
_isExit = (_this select 1);
_entranceObject = (_this select 2);

// OBJECT WONT ACCEPT DAMAGE
_object addEventHandler ["HandleDamage",{}];

// OBJECT IS A TUNNEL ENTRANCE (NOT IMPLEMENTED)
if ((_isExit)) then {

	_object addAction ["Exit Tunnel", "CAS\CAS_sTunnel\actions\CAS_exitTunnel.sqf", [_entranceObject]];	

};

// SET OBJECT HEIGHT USING ASL
_object setPosASL [(getPosASL _object select 0), (getPosASL _object select 1), 15000];

// ROTATE FLAT
_object setVectorUp [0, 0, 0.00001];