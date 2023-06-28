/***************************************************************************
KILL
CREATED BY SPYDER
SPYDER@ARMALIVE.COM
***************************************************************************/

private ["_killer", "_killerName", "_playerName", "_killerUID", "_playerUID", "_killerSide", "_kVarName", "_weapon", "_distance", "_killerPos", "_victimPos", "_assists", "_addValue", "_weaponType", "_score", "_addScore", "_currentScore", "_award", "_fundsName"];

_killer = (_this select 0);
_killerName = (_this select 1);
_playerName = (_this select 2);
_killerUID = (_this select 3);
_playerUID = (_this select 4);
_killerSide = (_this select 5);
_kVarName = (_this select 6);
_weapon = (_this select 7);
_distance = (_this select 8);
_killerPos = (_this select 9);
_victimPos = (_this select 10);
_assists = (_this select 11);

// CURRENT VALUE INCREASED BY 1
_addValue = ((SPY_GAMELOGIC getVariable _kVarName select 3) + 1);

// DETERMINE WEAPON TYPE OF SCORING
if ((_weapon isKindOf "AllVehicles")) then {_weaponType = 2;} else {_weaponType = 1;};

// ADD SCORE
_score = (["kill", _weaponType, _distance] call SPY_scoreValue);
_addScore = ((SPY_GAMELOGIC getVariable _kVarName select 0) + _score);

// ALL CURRENT VALUES IN THE ARRAY
_currentScore = (SPY_GAMELOGIC getVariable _kVarName);

// SET INCREASED VALUE IN ARRAY
_currentScore set [0, _addScore];
_currentScore set [3, _addValue];

// BROADCAST SCORE
SPY_GAMELOGIC setVariable [_kVarName, _currentScore, true];

// BROADCAST SIDE SCORE
switch (_killerSide) do {

	case WEST: {[0] call SPY_addSideScore;};
	case EAST: {[2] call SPY_addSideScore;};
	
};

// FORMAT/ SEND A2U INFO
[(format ["bstats_kill (%1, %2, %3, %4, %5, %6, %7, %8)", _playerUID, _killerUID, time, (str _weapon), _score, _distance, (str (str _victimPos)), (str (str _killerPos))])] call uplink_exec;

// PLAYER MESSAGE
if ((!(SPY_bStats_valhalla))) then {

	if ((SPY_bStats_msgsEnabled)) then {

		_null = [[_playerName, _killerName, ([_weapon] call SPY_displayName)], "SPY_GAMELOGIC globalChat format ['%1 WAS KILLED BY %2 (%3)', (_this select 0), (_this select 1), (_this select 2)];", "CLIENT"] spawn JDAM_mpCB;

	};
	
// VALHALLA MONEY AWARD
} else {

	_fundsName = (format ["DAO_WF_Funds_%1", _killerName]); 
	_award = Config_AwardKillPlayerValue;
	
	if ((_weapon == "Knife") || (_weapon == "HandGrenadeMuzzle2")) then {_award = _award * 3;};
	
	if ((!(_killer getVariable "joied_ts"))) then {_award = (_award * Config_TS3FundsModifier);};
	
	DAO_WF_Logic setVariable [_fundsName, ((DAO_WF_Logic getVariable _fundsName) + _award), true];
	
	if ((SPY_bStats_msgsEnabled)) then {
	
		_null = [[_playerName, _killerName, (_award)], "SPY_GAMELOGIC globalChat format ['%1 WAS KILLED BY %2 ($%3)', (_this select 0), (_this select 1), (_this select 2)];", "CLIENT"] spawn JDAM_mpCB;

	};
		
};

// KILL ASSISTS
{

	[[_x, (_x getVariable "SPY_PLAYER_ID" select 0), (_x getVariable "SPY_PLAYER_ID" select 1)], "_this call SPY_killAssist;", SPY_bStats_delayMsgTime] call SPY_dQueueAdd;

} forEach _assists;