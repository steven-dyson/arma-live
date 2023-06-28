/***************************************************************************
SPY INIT AND COMPILE (METHOD)
CREATED BY SPYDER
SPYDER@ARMALIVE.COM
***************************************************************************/

private ["_compile"];

if ((!(SPY_CONNECT_ENABLED))) exitWith {};

_compile = [] execVM "SPY\SPY_connect\SPY_compile.sqf";
waitUntil {sleep 0.1; scriptDone _compile};