/***************************************************************************
SPY INIT AND COMPILE (METHOD)
CREATED BY SPYDER
SPYDER@ARMALIVE.COM
***************************************************************************/

private ["_compile"];

_compile = [] execVM "SPY\SPY_fnc\SPY_compile.sqf";
waitUntil {scriptDone _compile};