/***************************************************************************
SPY INIT AND COMPILE (METHOD)
CREATED BY SPYDER
SPYDER@ARMALIVE.COM
***************************************************************************/

private ["_process"];

if ((!(SPY_CONNECT_ENABLED))) exitWith {};

_process = [] execVM "SPY\SPY_connect\SPY_processUID.sqf";
waitUntil {sleep 0.1; scriptDone _process};