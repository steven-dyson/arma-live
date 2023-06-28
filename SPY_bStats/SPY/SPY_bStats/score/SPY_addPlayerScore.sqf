/***************************************************************************
SPY_addPlayerScore.sqf
Created by Spyder
14 JUN 2011
****************************************************************************/

private ["_pVarName", "_type", "_vehicle", "_crewNumber", "_newScore", "_currentScore"];

_pVarName = (_this select 0);
_type = (_this select 1);
_vehicle = (_this select 2);
_crewNumber = (_this select 3);

// Current value & score increased by 1
_newScore = ((SPY_GAMELOGIC getVariable _pVarName select 0) + ([_type, _vehicle, _crewNumber] call SPY_scoreValue));

// All current values & score in the array, set increased value in array
_currentScore = (SPY_GAMELOGIC getVariable _pVarName);
_currentScore set [0, _newScore];

// Broadcast array
SPY_GAMELOGIC setVariable [_pVarName, _currentScore, true];