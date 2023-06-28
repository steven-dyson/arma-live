/***************************************************************************
SPY_addSideScore.sqf
Created by Spyder
21 FEB 2011
****************************************************************************/

private ["_scoreType", "_addValue", "_currentScore"];

// Selection in array defined in script
_scoreType = _this select 0;

// Current value increased by 1
_addValue = (SPY_GAMELOGIC getVariable "SPY_SIDE_SCORE" select _scoreType) + 1;

// All current values in the array
_currentScore = SPY_GAMELOGIC getVariable "SPY_SIDE_SCORE";

// Set increased value in array
_currentScore set [_scoreType, _addValue];

// Broadcast array
SPY_GAMELOGIC setVariable ["SPY_SIDE_SCORE", _currentScore, true];

/* if (!(SPY_DEBUG_ENABLED)) exitWith {};

switch (_scoreType) do {

	case 0: {_null = [[_addValue], "SPY_GAMELOGIC globalChat format ['WEST KILLS: %1', _this select 0];", "CLIENT"] spawn JDAM_mpCB;};
	case 1: {_null = [[_addValue], "SPY_GAMELOGIC globalChat format ['WEST DEATHS: %1', _this select 0];", "CLIENT"] spawn JDAM_mpCB;};
	case 2: {_null = [[_addValue], "SPY_GAMELOGIC globalChat format ['EAST KILLS: %1', _this select 0];", "CLIENT"] spawn JDAM_mpCB;};
	case 3: {_null = [[_addValue], "SPY_GAMELOGIC globalChat format ['EAST DEATHS: %1', _this select 0];", "CLIENT"] spawn JDAM_mpCB;};

}; */