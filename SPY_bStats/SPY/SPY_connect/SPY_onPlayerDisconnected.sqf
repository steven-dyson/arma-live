/***************************************************************************
ON PLAYER DISCONNECTED
CREATED BY SPYDER
SPYDER@ARMALIVE.COM
****************************************************************************/

private ["_uid"];

_uid = (_this select 0);

[(format ["bstats_player_left (%1, %2)", _uid, time])] call uplink_exec;