/***************************************************************************
VEHICLE KILL
CREATED BY SPYDER
SPYDER@ARMALIVE.COM
****************************************************************************/

private ["_killer", "_killerName", "_killerUID", "_kVarName", "_weapon", "_distance", "_killerPos", "_vehiclePos", "_assists", "_vehicle", "_addValue", "_weaponType", "_score", "_addScore", "_currentScore", "_award", "_fundsName"];

_killer = (_this select 0);
_killerName = (_this select 1);
_killerUID = (_this select 2);
_kVarName = (_this select 3);
_vehicle = (_this select 4);
_weapon = (_this select 5);
_distance = (_this select 6);
_killerPos = (_this select 7);
_vehiclePos = (_this select 8);
_assists = (_this select 9);

// FAIL SAFE, NEED TO FIGURE OUT WHY THIS IS NEEDED
if ((_kVarName == "")) then {_kVarName = (format ["SPY_bStats_%1", _killerUID]);};

// CURRENT VALUE INCREASED BY 1
_addValue = ((SPY_GAMELOGIC getVariable _kVarName select 7) + 1);

// DETERMINE WEAPON TYPE OF SCORING
if ((_weapon isKindOf "AllVehicles")) then {_weaponType = 2;} else {_weaponType = 1;};

// ADD SCORE
_score = (["vehkill", [_weaponType, _vehicle], _distance] call SPY_scoreValue);
_addScore = ((SPY_GAMELOGIC getVariable _kVarName select 0) + _score);

// ALL CURRENT VALUES IN THE ARRAY
_currentScore = (SPY_GAMELOGIC getVariable _kVarName);

// SET INCREASED VALUE IN ARRAY
_currentScore set [0, _addScore];
_currentScore set [7, _addValue];

// BROADCAST ARRAY
SPY_GAMELOGIC setVariable [_kVarName, _currentScore, true];

// FORMAT/ SEND A2U INFO
[(format ["bstats_vehkill (%1, %2, %3, %4, %5, %6, %7, %8)", (str (typeOf _vehicle)), _killerUID, time, (str _weapon), _score, _distance, (str (str _vehiclePos)), (str (str _killerPos))])] call uplink_exec;

// PLAYER MESSAGE
if ((!(SPY_bStats_valhalla))) then {

	if ((SPY_bStats_msgsEnabled)) then {

		_null = [[_killerName, ([_vehicle] call SPY_displayName), ([_weapon] call SPY_displayName)], "SPY_GAMELOGIC globalChat format ['%1 KILLED A %2 (%3)', (_this select 0), (_this select 1), (_this select 2)];", "CLIENT"] spawn JDAM_mpCB;

	};
	
// VALHALLA MONEY AWARD
} else {

	_fundsName = (format ["DAO_WF_Funds_%1", _killerName]); 
	_award = (_vehicle getVariable "kill_award");
	
	if ((!(_killer getVariable "joied_ts"))) then {_award = (_award * Config_TS3FundsModifier);};
		
	DAO_WF_Logic setVariable [_fundsName, ((DAO_WF_Logic getVariable _fundsName) + _award), true];
	
	if ((SPY_bStats_msgsEnabled)) then {
	
		_null = [[_killerName, ([_vehicle] call SPY_displayName), _award], "SPY_GAMELOGIC globalChat format ['%1 KILLED A %2 ($%3)', (_this select 0), (_this select 1), (_this select 2)];", "CLIENT"] spawn JDAM_mpCB;

	};
	
};

// KILL ASSISTS
{

	[[_x, (_x getVariable "SPY_PLAYER_ID" select 0), (_x getVariable "SPY_PLAYER_ID" select 1)], "_this call SPY_killAssist;", SPY_bStats_delayMsgTime] call SPY_dQueueAdd;

} forEach _assists;