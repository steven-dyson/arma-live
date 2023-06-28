/***************************************************************************
KILL ASSIST
CREATED BY SPYDER
SPYDER@ARMALIVE.COM
***************************************************************************/

private ["_damagingUnit", "_damagingUnitUID", "_damagingUnitName", "_dVarName", "_addValue", "_score", "_addScore", "_currentScore", "_award", "_fundsName"];

_damagingUnit = (_this select 0);
_damagingUnitUID = (_this select 1);
_damagingUnitName = (_this select 2);

_dVarName = (format ["SPY_bStats_%1", _damagingUnitUID]);

// Current value increased by 1
_addValue = ((SPY_GAMELOGIC getVariable _dVarName select 8) + 1);

// Add score
_score = (["killassist", objNull, 0] call SPY_scoreValue);
_addScore = ((SPY_GAMELOGIC getVariable _dVarName select 0) + _score);

// All current values in the array
_currentScore = (SPY_GAMELOGIC getVariable _dVarName);

// Set increased value in array
_currentScore set [0, _addScore];
_currentScore set [8, _addValue];

// Broadcast array
SPY_GAMELOGIC setVariable [_dVarName, _currentScore, true];

// Format/ Send A2U Info
[(format ["bstats_killassist (%1, %2, %3)", _damagingUnitUID, time, _score])] call uplink_exec;

// Player Message
if ((!(SPY_bStats_valhalla))) then {

	if ((SPY_bStats_msgsEnabled)) then {

		_null = [[], "SPY_GAMELOGIC globalChat 'YOU GOT A KILL ASSIST';", _damagingUnitUID] spawn JDAM_mpCB;

	};
	
// VALHALLA MONEY AWARD
} else {

	_fundsName = (format ["DAO_WF_Funds_%1", _damagingUnitName]); 
	_award = (Config_AwardKillPlayerValue / 2);
	
	if ((!(_damagingUnit getVariable "joied_ts"))) then {_award = (_award * Config_TS3FundsModifier);};
		
	DAO_WF_Logic setVariable [_fundsName, ((DAO_WF_Logic getVariable _fundsName) + _award), true];
	
	if ((SPY_bStats_msgsEnabled)) then {
	
		_null = [[_award], "SPY_GAMELOGIC globalChat format ['YOU GOT A KILL ASSIST ($%1)', (_this select 0)];", _damagingUnitUID] spawn JDAM_mpCB;
	
	};
	
};