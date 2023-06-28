/***************************************************************************
DEATH
CREATED BY SPYDER
SPYDER@ARMALIVE.COM
***************************************************************************/

private ["_victimUID", "_victimPos", "_victimName", "_victimSV", "_victimSide", "_xmit", "_addValue", "_currentScore", "_uplink"];

_victimUID = (_this select 0);
_victimPos = (_this select 1);
_victimName = (_this select 2);
_victimSV = (_this select 3);
_victimSide = (_this select 4);
_xmit = (_this select 5);

// CURRENT VALUE INCREASED BY 1
_addValue = ((SPY_GAMELOGIC getVariable _victimSV select 4) + 1);

// ALL CURRENT VALUES IN THE ARRAY
_currentScore = (SPY_GAMELOGIC getVariable _victimSV);

// SET INCREASED VALUE IN ARRAY
_currentScore set [4, _addValue];

// BROADCAST PLAYER SCORE
SPY_GAMELOGIC setVariable [_victimSV, _currentScore, true];

// BROADCAST SIDE SCORE
switch (_victimSide) do {

	case WEST: {[1] call SPY_addSideScore;};
	case EAST: {[3] call SPY_addSideScore;};
	
};

// PLAYER DEATH MESSAGE (IF NO OTHERS DISPLAYED)
if ((_xmit)) then {

	if ((SPY_bStats_msgsEnabled)) then {

		_null = [[_victimName], "SPY_GAMELOGIC globalChat format ['%1 HAS DIED', (_this select 0)];", "CLIENT"] spawn JDAM_mpCB;

	};
		
	// FORMAT/SEND TO A2U (IF NO OTHER SENT)
    _uplink = format ["bstats_death (%1, %2, %3, %4)", _victimUID, time, 0, (str str _victimPos)];
	_null = [_uplink] call uplink_exec;

};