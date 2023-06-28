/***************************************************************************
SPY INIT AND COMPILE (METHOD)
SPY AIROPS CLIENT
CREATED BY SPYDER
SPYDER001@COMCAST.NET
***************************************************************************/

if ((!(SPY_AIROPS_ENABLED))) exitWith {};

private ["_compile", "_settings"];

_compile = [] execVM "SPY\SPY_airOps\SPY_compile.sqf";
waitUntil {scriptDone _compile};

_settings = [] execVM "SPY\SPY_airOps\SPY_settings.sqf";
waitUntil {scriptDone _settings};