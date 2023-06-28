/***************************************************************************
SPY INIT AND COMPILE (METHOD)
CREATED BY SPYDER
SPYDER@ARMALIVE.COM
***************************************************************************/

private ["_compile"];

_compile = [] execVM "JDAM\JDAM_mpcs\JDAM_compile.sqf";
waitUntil {sleep 0.1; scriptDone _compile};

_null = [] execVM "JDAM\JDAM_mpcs\JDAM_mpCEH.sqf";
_null = [] execVM "JDAM\JDAM_mpcs\JDAM_mpCEH_A.sqf";