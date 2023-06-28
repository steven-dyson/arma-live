/***************************************************************************
TEAM KILL
CREATED BY SPYDER
SPYDER@ARMALIVE.COM
***************************************************************************/

private ["_killerName", "_playerName", "_killerUID", "_playerUID", "_kVarName", "_weapon", "_distance", "_killerPos", "_victimPos", "_addValue", "_addPunish", "_score", "_addScore", "_currentScore", "_award", "_fundsName"];

_killerName = (_this select 0);
_playerName =  (_this select 1);
_killerUID = (_this select 2);
_playerUID = (_this select 3);
_kVarName = (_this select 4);
_weapon = (_this select 5);
_distance = (_this select 6);
_killerPos = (_this select 7);
_victimPos = (_this select 8);

// Current values increased by 1
_addValue = ((SPY_GAMELOGIC getVariable _kVarName select 6) + 1);
_addPunish = ((SPY_GAMELOGIC getVariable _kVarName select 2) + 1);

// Add score
_score = (["teamkill", objNull, _addValue] call SPY_scoreValue);
_addScore = ((SPY_GAMELOGIC getVariable _kVarName select 0) + _score);

// All current values in the array
_currentScore = (SPY_GAMELOGIC getVariable _kVarName);

// Set increased value in array
_currentScore set [0, _addScore];
_currentScore set [6, _addValue];
_currentScore set [2, _addPunish];

// Broadcast array
SPY_GAMELOGIC setVariable [_kVarName, _currentScore, true];

// Format/ Send A2U Info
[(format ["bstats_tk (%1, %2, %3, %4, %5, %6, %7, %8)", _playerUID, _killerUID, time, (str _weapon), _score, _distance, (str str _victimPos), (str str _killerPos)])] call uplink_exec;

// Player Message
if ((!(SPY_bStats_valhalla))) then {

	if ((SPY_bStats_msgsEnabled)) then {

		_null = [[_killerName, _playerName, ([_weapon] call SPY_displayName)], "SPY_GAMELOGIC globalChat format ['%1 TEAM KILLED %2 (%3)', (_this select 0), (_this select 1), (_this select 2)];", "CLIENT"] spawn JDAM_mpCB;

	};
	
// VALHALLA MONEY AWARD
} else {

	_fundsName = (format ["DAO_WF_Funds_%1", _killerName]); 
	_award = (- (Config_AwardKillPlayerValue * 2));
		
	DAO_WF_Logic setVariable [_fundsName, ((DAO_WF_Logic getVariable _fundsName) + _award), true];

	if ((SPY_bStats_msgsEnabled)) then {
	
		_null = [[_killerName, _playerName, _award], "SPY_GAMELOGIC globalChat format ['%1 TEAMKILLED %2 ($%3)', (_this select 0), (_this select 1), (_this select 2)];", "CLIENT"] spawn JDAM_mpCB;

	};
	
};