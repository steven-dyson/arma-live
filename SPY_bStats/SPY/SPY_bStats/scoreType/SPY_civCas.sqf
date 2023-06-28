/***************************************************************************
SPY_CIVCAS.SQF
CREATED BY SPYDER
SPYDER@ARMALIVE.COM
****************************************************************************/

private ["_killerName", "_killerUID", "_kVarName", "_weapon", "_distance", "_victimPos", "_killerPos", "_addValue", "_addPunish", "_score", "_addScore", "_currentScore"];

_killerName = (_this select 0);
_killerUID = (_this select 1);
_kVarName = (_this select 2);
_weapon = (_this select 3);
_distance = (_this select 4);
_victimPos = (_this select 5);
_killerPos = (_this select 6);

// Current values increased by 1
_addValue = ((SPY_GAMELOGIC getVariable _kVarName select 10) + 1);
_addPunish = ((SPY_GAMELOGIC getVariable _kVarName select 2) + 1);

// Add score
_score = (["civcas", objNull, _addValue] call SPY_scoreValue);
_addScore = ((SPY_GAMELOGIC getVariable _kVarName select 0) + _score);

// All current values in the array
_currentScore = (SPY_GAMELOGIC getVariable _kVarName);

// Set increased values in array
_currentScore set [0, _addScore];
_currentScore set [10, _addValue];
_currentScore set [2, _addPunish];

// Broadcast array
SPY_GAMELOGIC setVariable [_kVarName, _currentScore, true];

// Format/ Send A2U Info
[(format ["bstats_civcas (nil, %1, %2, %3, %4, %5, %6, %7)", _killerUID, time, str _weapon, _score, _distance, (str (str _victimPos)), (str (str _killerPos))])] call uplink_exec;

// PLAYER MESSAGE
if ((SPY_bStats_msgsEnabled)) then {
	
	_null = [[_killerName, ([_weapon] call SPY_displayName)], "SPY_GAMELOGIC globalChat format ['%1 KILLED A CIVILIAN (%2)', _this select 0, _this select 1];", "CLIENT"] spawn JDAM_mpCB;

};