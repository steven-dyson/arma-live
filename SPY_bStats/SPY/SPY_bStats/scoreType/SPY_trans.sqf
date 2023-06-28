/***************************************************************************
TRANSPORTATION
CREATED BY SPYDER
SPYDER@ARMALIVE.COM
****************************************************************************/

private ["_playerName", "_playerUID", "_vehicle", "_distance", "_vehiclePos", "_pVarName", "_score", "_addScore", "_currentScore"];

_playerName = (_this select 0);
_playerUID = (_this select 1);
_vehicle = (_this select 2);
_distance = (_this select 3);
_vehiclePos = (_this select 4);

// TESTING
// if ((_playerUID == "1524806")) then {_playerUID = (BLU1 getVariable "SPY_PLAYER_ID" select 0);};

_pVarName = (format ["SPY_bStats_%1", _playerUID]);

// ADD SCORE
_score = (["trans", _vehicle, 0] call SPY_scoreValue);
_addScore = ((SPY_GAMELOGIC getVariable _pVarName select 0) + _score);

// ALL CURRENT VALUES IN THE ARRAY
_currentScore = (SPY_GAMELOGIC getVariable _pVarName);

// SET INCREASED VALUE IN ARRAY
_currentScore set [0, _addScore];

// BROADCAST ARRAY
SPY_GAMELOGIC setVariable [_pVarName, _currentScore, true];

// FORMAT/ SEND A2U INFO
[(format ["bstats_trans (%1, %2, %3, %4, %5, %6)", _playerUID, time, (str (typeOf _vehicle)), _distance, _score, (str str _vehiclePos)])] call uplink_exec;

// PLAYER MESSAGE
if ((SPY_bStats_msgsEnabled)) then {

	_null = [[floor _distance], "SPY_GAMELOGIC globalChat format ['YOU DROPPED OFF A PASSANGER (%1 M)',(_this select 0)];", _playerUID] spawn JDAM_mpCB;
	
};