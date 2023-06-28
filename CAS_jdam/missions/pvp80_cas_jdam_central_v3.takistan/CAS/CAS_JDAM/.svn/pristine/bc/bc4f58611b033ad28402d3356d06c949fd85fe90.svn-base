/***************************************************************************
Destroy Client
Created by Spyder
spyder@armalive.com
***************************************************************************/

scriptName "CAS JDAM BP Destroy Client";

private ["_bp", "_player"];

_bp = (_this select 0);
_player = (_this select 1);

[[_bp, _player], "_this spawn CAS_JDAM_bp_destroy_s;", "SERVER"] call SPY_iQueueAdd;