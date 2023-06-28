/***************************************************************************
SPY INIT AND COMPILE (METHOD)
CREATED BY SPYDER
SPYDER@ARMALIVE.COM
***************************************************************************/

private ["_compile", "_bStats"];

if ((!(SPY_BSTATS_ENABLED))) exitWith {};

_compile = [] execVM "SPY\SPY_bStats\SPY_compile.sqf";
waitUntil {sleep 0.1; scriptDone _compile};

_bStats = [] execVM "SPY\SPY_bStats\init\SPY_initPlayer.sqf";
waitUntil {sleep 0.1; scriptDone _bStats};