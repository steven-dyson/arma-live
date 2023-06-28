/***************************************************************************
INITILIZE TUNNEL ENTRANCE
CREATED BY SPYDER
SPYDER001@COMCAST.NET
****************************************************************************/

// _null = [this, false] execVM "CAS/CAS_sTunnel/CAS_initTunnelEntrance.sqf";

private ["_object", "_isExit", "_entranceObject"];

_object = (_this select 0);
_tunnelObject = (_this select 1);

_object addAction ["Enter Tunnel", "CAS\CAS_sTunnel\actions\CAS_enterTunnel.sqf", [_tunnelObject]];