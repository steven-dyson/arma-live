/***************************************************************************
CAPTURE
CREATED BY SPYDER
SPYDER@ARMALIVE.COM
***************************************************************************/

private ["_player", "_uid", "_mission", "_obj", "_mission", "_playerSV", "_playerName", "_currentScore", "_score", "_addScore", "_award", "_fundsName"];

_player = (_this select 0);
_uid = (_this select 1);
_obj = (_this select 2);
_mission = (_this select 3);

_playerSV = (format ["SPY_bStats_%1", _uid]);
_playerName = (_player getVariable "SPY_PLAYER_ID" select 1);

// CURRENT SCORES
_currentScore = (SPY_GAMELOGIC getVariable _playerSV);

// ADD SCORE
_score = (["capture", objNull, 0] call SPY_scoreValue);
_addScore = ((_currentScore select 0) + _score);

// SET NEW SCORE
_currentScore set [0, _addScore];

// BROADCAST
SPY_GAMELOGIC setVariable [_playerSV, _currentScore, true];

// FORMAT/ SEND A2U INFO
[(format ["bstats_capture (%1, %2, %3, %4)", _uid, time, _score, (str _obj)])] call uplink_exec;

// PLAYER MESSAGE & AWARD (VALHALLA)
if ((SPY_bStats_valhalla)) then {

	_award = (_mission select 0);
	
	if ((!(_player getVariable "joied_ts"))) then {_award = (_award * Config_TS3FundsModifier);};

	if ((SPY_bStats_msgsEnabled)) then {
	
		_null = [[_obj, _award, _score], "SPY_GAMELOGIC globalChat format ['YOU CAPTURED %1 ($%2 & %3 POINTS)', (_this select 0), (_this select 1), (_this select 2)];", _uid] spawn JDAM_mpCB;

	};
	
	_fundsName = (format ["DAO_WF_Funds_%1", _playerName]); 
		
	DAO_WF_Logic setVariable [_fundsName, ((DAO_WF_Logic getVariable _fundsName) + _award), true];

} else {

	if ((SPY_bStats_msgsEnabled)) then {

		_null = [[_obj, _score], "SPY_GAMELOGIC globalChat format ['YOU CAPTURED %1 (%2 POINTS)', (_this select 0), (_this select 1)];", _uid] spawn JDAM_mpCB;

	};
	
};