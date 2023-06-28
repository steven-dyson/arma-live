/***************************************************************************
AIRCRAFT CRASH
CREATED BY SPYDER
SPYDER@ARMALIVE.COM
***************************************************************************/

private ["_playerName", "_playerUID", "_playerScoreVar", "_vehicle", "_playerPos", "_crewNumber", "_addValue", "_addPunish", "_score", "_addScore", "_currentScore"];

_playerName = (_this select 0);
_playerUID = (_this select 1);
_playerScoreVar = (_this select 2);
_vehicle = (_this select 3);
_playerPos = (_this select 4);

// NUMBER OF PLAYERS IN VEHICLE (MINUS PILOT)
_crewNumber = ((count (_vehicle getVariable "SPY_VEHICLE_INFO" select 4)) - 1);

// AIRCRAFT NOT INITILIZED
if ((isNil "_crewNumber")) then {_crewNumber = 0;};

// CURRENT VALUE INCREASED BY 1
_addValue = ((SPY_GAMELOGIC getVariable _playerScoreVar select 9) + 1);
_addPunish = ((SPY_GAMELOGIC getVariable _playerScoreVar select 2) + 1);

//ADD SCORE
_score = (["accrash", objNull, _crewNumber] call SPY_scoreValue);
_addScore = ((SPY_GAMELOGIC getVariable _playerScoreVar select 0) + _score);

// ALL CURRENT VALUES IN THE ARRAY
_currentScore = (SPY_GAMELOGIC getVariable _playerScoreVar);

// SET INCREASED VALUE IN ARRAY
_currentScore set [0, _addScore];
_currentScore set [9, _addValue];
_currentScore set [2, _addPunish];

// BROADCAST ARRAY
SPY_GAMELOGIC setVariable [_playerScoreVar, _currentScore, true];

// FORMAT/ SEND A2U INFO
[(format ["bstats_accrash (%1, %2, %3, %4, %5)", _playerUID, time, _crewNumber, _score, (str (str _playerPos))])] call uplink_exec;

// PLAYER MESSAGE
if ((SPY_bStats_msgsEnabled)) then {

	_null = [[_playerName, ([_vehicle] call SPY_displayName), _crewNumber], "SPY_GAMELOGIC globalChat format ['%1 CRASHED A %2 WITH %3 PASSENGERS', _this select 0, _this select 1, _this select 2];", "CLIENT"] spawn JDAM_mpCB;

};