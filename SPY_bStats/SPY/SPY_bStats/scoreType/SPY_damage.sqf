/***************************************************************************
SPY_DAMAGE.SQF
CREATED BY SPYDER
SPYDER@ARMALIVE.COM
****************************************************************************/

private ["_type", "_dVarName", "_playerUID", "_damagingUnitUID", "_weapon", "_distance", "_unitPos", "_damagingUnitPos", "_score", "_addScore",  "_currentScore", "_uplink"];

_type = (_this select 0);
_dVarName = (_this select 1);
_playerUID = (_this select 2);
_damagingUnitUID = (_this select 3);
_weapon = (_this select 4);
_distance = (_this select 5);
_unitPos = (_this select 6);
_damagingUnitPos = (_this select 7);

// CURRENT VALUES INCREASED BY 1
// _addPunish = ((SPY_GAMELOGIC getVariable _kVarName select 12) + 1);

// ADD SCORE
switch (_type) do {

	case "damageTeam": {
	
		_score = (["damageteam", objNull, 0] call SPY_scoreValue);
		_addScore = ((SPY_GAMELOGIC getVariable _dVarName select 0) + _score);
		
		// FORMAT/ SEND A2U INFO
		_uplink = format ["bstats_friendlydmg (%1, %2, %3, %4, %5, %6, %7, %8)", _playerUID, _damagingUnitUID, time, (str _weapon), _score, _distance, (str (str _unitPos)), (str (str _damagingUnitPos))];
		_null = [[_uplink], "_this call uplink_exec", "SERVER"] spawn JDAM_mpCB;
		
	};
	
	case "damageCiv": {
	
		_score = (["damageciv", objNull, 0] call SPY_scoreValue);
		_addScore = ((SPY_GAMELOGIC getVariable _dVarName select 0) + _score);
		
		// FORMAT/ SEND A2U INFO
		_uplink = format ["bstats_civdmg (nil, %1, %2, %3, %4, %5, %6, %7)", _damagingUnitUID, time, (str _weapon), _score, _distance, (str (str _unitPos)), (str (str _damagingUnitPos))];
		_null = [[_uplink], "_this call uplink_exec", "SERVER"] spawn JDAM_mpCB;
		
	};
	
};
	
// ALL CURRENT VALUES IN THE ARRAY
_currentScore = (SPY_GAMELOGIC getVariable _dVarName);

// SET INCREASED VALUE IN ARRAY
_currentScore set [0, _addScore];
// _currentScore set [12, _addPunish];

// BROADCAST ARRAY
SPY_GAMELOGIC setVariable [_dVarName, _currentScore, true];