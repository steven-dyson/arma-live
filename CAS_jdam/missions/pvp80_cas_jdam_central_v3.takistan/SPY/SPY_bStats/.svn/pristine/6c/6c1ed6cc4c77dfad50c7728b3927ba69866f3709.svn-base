/*
	Author: Spyder (spyder@armalive.com)

	Description:
	Add bStats score to unit

	Parameter(s):
		0: STRING - unit UID
		1: STRING - score type
		2: NUMBER - value to add to previous score

	Returns:
	BOOLEAN
*/

scriptName "SPY_bStats_fnc_addScoreUnit";

_uid = [_this, 0, "", [""]] call BIS_fnc_param;
_type = [_this, 1, "", [""]] call BIS_fnc_param;
_score = [_this, 2, 0, [0]] call BIS_fnc_param;

_scoreVar = format ["SPY_bStats_%1_%2", _uid, _type];
_currentScore = SPY_container getVariable _scoreVar;
SPY_container setVariable [_scoreVar, _currentScore + _score, true];

true