/***************************************************************************
SPY Initialization and Compile (Method)
Created by Spyder
spyder@armalive.com
***************************************************************************/

private ["_compile"];

_compile = [] execVM "CAS\CAS_core\CAS_fnc\CAS_compile.sqf";
waitUntil {sleep 0.1; scriptDone _compile};