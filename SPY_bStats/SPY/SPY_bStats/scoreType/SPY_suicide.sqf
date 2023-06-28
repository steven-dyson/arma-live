/***************************************************************************
SUICIDE
CREATED BY SPYDER
SPYDER@ARMALIVE.COM
***************************************************************************/

private ["_playerName", "_playerUID", "_playerScoreVar", "_playerPos", "_addValue", "_score", "_addScore", "_currentScore"];

_playerName = (_this select 0);
_playerUID = (_this select 1);
_playerScoreVar = (_this select 2);
_playerPos = (_this select 3);

// Current value increased by 1
_addValue = ((SPY_GAMELOGIC getVariable _playerScoreVar select 5) + 1);

// Add score
_score = (["accrash", objNull, 0] call SPY_scoreValue);
_addScore = ((SPY_GAMELOGIC getVariable _playerScoreVar select 0) + _score);

// All current values in the array
_currentScore = (SPY_GAMELOGIC getVariable _playerScoreVar);

// Set increased value in array
_currentScore set [0, _addScore];
_currentScore set [5, _addValue];

// Broadcast array
SPY_GAMELOGIC setVariable [_playerScoreVar, _currentScore, true];

// Format/ Send A2U Info
[(format ["bstats_suicide (%1, %2, %3, %4)", _playerUID, time, _score, (str (str _playerPos))])] call uplink_exec;

// PLAYER MESSAGE
if ((SPY_bStats_msgsEnabled)) then {

	_null = [[_playerName], "SPY_GAMELOGIC globalChat format ['%1 COMMITED SUICIDE', _this select 0];", "CLIENT"] spawn JDAM_mpCB;
	
};