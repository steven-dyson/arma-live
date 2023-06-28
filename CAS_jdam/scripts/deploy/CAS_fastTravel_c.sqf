/***************************************************************************
Fast Travel Client
Created by Spyder
spyder@armalive.com

Local:
this addAction ["<t color=""#0000ff"">Deploy to Location", "CAS\CAS_JDAM\deploy\CAS_fastTravel_c.sqf", [player, "marker"], -98, false, true, "", ""];
***************************************************************************/

scriptName "CAS JDAM Deploy Fast Travel Client";

private ["_args", "_player", "_targetMarker"];

_player = (_this select 1);
_args = (_this select 3);

_targetMarker = (_args select 0);

_null = ["You are being deployed...", "LOCAL", 2, 2] spawn SPY_bInfoScreen;

preloadCamera (getMarkerPos _targetMarker);

sleep 2;

_player setPos (getMarkerPos _targetMarker);