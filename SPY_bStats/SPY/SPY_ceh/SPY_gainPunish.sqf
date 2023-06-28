/***************************************************************************
SPY_GAINPUNISH.SQF
CREATED BY SPYDER
SPYDER@ARMALIVE.COM
****************************************************************************/



/***************************************************************************
INIT
****************************************************************************/
private ["_uid", "_varName", "_reset", "_events", "_punishTime", "_currentScore", "_penalty", "_disabledTime", "_pName", "_uplink", "_punishPoints", "_stackDelay"];

if (!(SPY_roePunish_enabled)) exitWith {};

_uid = (getPlayerUID player);
_varName = (format ["SPY_bStats_%1", _uid]);
_reset = 1;
/***************************************************************************
END
****************************************************************************/



/***************************************************************************
MONITOR
****************************************************************************/
while {true} do {
	
	// INITAL ROE VIOLATION
	waitUntil {sleep 0.1; ((SPY_GAMELOGIC getVariable _varName select 2) > 0)};
	
	_reset = 0;
	_events = 0;

	// WHILE MONITOR IS NOT RESET
	while {_reset == 0} do {
	
		_events = (_events + 1);
		_punishTime = (time + 300);
		_currentScore = (SPY_GAMELOGIC getVariable _varName);

		// ROE VIOLATION STACKING PENALTY
		if ((_events > 1)) then {		
			
			if ((time < _stackDelay)) exitWith {};
			
			_currentScore = (SPY_GAMELOGIC getVariable _varName);
			_penalty = ((_currentScore select 2) * 3);
			_currentScore set [2, _penalty];
			SPY_GAMELOGIC setVariable [_varName, _currentScore, true];
		
		};

		// EXCESSIVE ROE VIOLATIONS
		if ((((SPY_GAMELOGIC getVariable _varName) select 2) > 6) || (((SPY_GAMELOGIC getVariable _varName) select 0) < -50)) then {
		
			sleep 0.1;
		
			_currentScore = (SPY_GAMELOGIC getVariable _varName);
			_disabledTime = ((_currentScore select 2) * 10);
			_pName = (player getVariable "SPY_PLAYER_ID" select 1);
			
			if (((_currentScore select 0) < -50)) then {_disabledTime = ((_currentScore select 0) * -4)};
			
			_null = [[_pName], "SPY_GAMELOGIC globalChat format ['%1 IS FLAGGED FOR EXCESSIVE ROE VIOLATIONS', _this select 0];", "CLIENT"] spawn JDAM_mpCB;
			
			_uplink = (format ["bstats_roeflag (%1, %2)", _uid, time]);
			_null = [[_uplink], "_this call uplink_exec", "SERVER"] spawn JDAM_mpCB;
			
			disableUserInput true;
			
			while {_disabledTime > 0} do {
			
				titleText [format ["USER INPUT DISABLED FOR EXCESSIVE ROE VIOLATIONS (%1)", ([_disabledTime] call JDAM_formatTime)], "BLACK FADED", 999];
				sleep 1;
				_disabledTime = _disabledTime - 1;
			
			};
			
			titleText ["USER INPUT ENABLED, FOLLOW THE ROE", "BLACK IN", 15];
			
			disableUserInput false;
			
			_punishTime = (time + 300);
			
		};
		
		// SET FOR COMPARISON
		_punishPoints = ((SPY_GAMELOGIC getVariable _varName) select 2);
		_stackDelay = (time + 1);
		
		// WAIT FOR NEXT EVENT OR RESET CONDITIONS
		waitUntil {(((SPY_GAMELOGIC getVariable _varName) select 2) > _punishPoints) || (time > _punishTime)};
		
		// RESET AFTER PENALTY TIMER
		if ((time > _punishTime)) then {
		
			_reset = 1;
			_currentScore = (SPY_GAMELOGIC getVariable _varName);
			_currentScore set [2, 0];
			SPY_GAMELOGIC setVariable [_varName, _currentScore, true];
			
		};
		
	};
		
};
/***************************************************************************
END
****************************************************************************/