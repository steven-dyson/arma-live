/***************************************************************************
ROADKILL
CREATED BY SPYDER
SPYDER@ARMALIVE.COM
***************************************************************************/

private ["_killer", "_killerName", "_playerName", "_killerUID", "_playerUID", "_kVarName", "_killerSide", "_playerSide", "_vehicle", "_victimPos", "_addValue", "_score", "_addScore", "_currentScore", "_award", "_fundsName"];

_killer = (_this select 0);
_killerName = (_this select 1);
_playerName = (_this select 2);
_killerUID = (_this select 3);
_playerUID = (_this select 4);
_kVarName = (_this select 5);
_killerSide = (_this select 6);
_playerSide = (_this select 7);
_vehicle = (_this select 8);
_victimPos = (_this select 9);

// Roadkill was done by teammate
if ((_playerSide == _killerSide)) exitWith {_null = [[_killerName, _playerName, _killerUID, _playerUID, _kVarName, (typeOf _vehicle), 0, _victimPos, _victimPos], "_null = _this spawn SPY_teamKill;", "SERVER"] spawn JDAM_mpCB;};

// Current value increased by 1
_addValue = ((SPY_GAMELOGIC getVariable _kVarName select 3) + 1);

// Add score
_score = (["kill", 1, 0] call SPY_scoreValue);
_addScore = ((SPY_GAMELOGIC getVariable _kVarName select 0) + _score);

// All current values in the array
_currentScore = (SPY_GAMELOGIC getVariable _kVarName);

// Set increased value in array
_currentScore set [0, _addScore];
_currentScore set [3, _addValue];

// Broadcast array
SPY_GAMELOGIC setVariable [_kVarName, _currentScore, true];

// BROADCAST SIDE SCORE
if ((_killerSide == WEST)) then {[0] call SPY_addSideScore;};
if ((_killerSide == EAST)) then {[2] call SPY_addSideScore;};

// Format/ Send A2U Info
[(format ["bstats_roadkill (%1, %2, %3, %4, %5, %6)", _playerUID, _killerUID, time, (str (typeOf _vehicle)), _score, (str str _victimPos)])] call uplink_exec;

// Player Message
if ((!(SPY_bStats_valhalla))) then {

	if ((SPY_bStats_msgsEnabled)) then {

		_null = [[_playerName, _killerName, ([_vehicle] call SPY_displayName)], "SPY_GAMELOGIC globalChat format ['%1 WAS RUN OVER BY %2 (%3)', (_this select 0), (_this select 1), (_this select 2)];", "CLIENT"] spawn JDAM_mpCB;

	};
	
// VALHALLA MONEY AWARD
} else {

	_fundsName = (format ["DAO_WF_Funds_%1", _killerName]); 
	_award = Config_AwardKillPlayerValue;
	
	if ((!(_killer getVariable "joied_ts"))) then {_award = (_award * Config_TS3FundsModifier);};
		
	DAO_WF_Logic setVariable [_fundsName, ((DAO_WF_Logic getVariable _fundsName) + _award), true];
	
	if ((SPY_bStats_msgsEnabled)) then {
	
		_null = [[_playerName, _killerName, _award], "SPY_GAMELOGIC globalChat format ['%1 WAS RUN OVER BY %2 ($%3)', (_this select 0), (_this select 1), (_this select 2)];", "CLIENT"] spawn JDAM_mpCB;

	};
	
};