/*
	Author: Spyder (spyder@armalive.com)

	Description:
	Add score (kill or death) to a specific side

	Parameter(s):
		0: ARRAY - of sides; select 0 will always be side with new death; select 1 will be side with new kill if present.
		1: BOOLEAN - true for kill and death; false for only a death

	Returns:
	BOOL 
*/

scriptName "SPY_bStats_fnc_addSideScore";

_sides = [_this, 0, [CIVILIAN], [CIVILIAN]] call BIS_fnc_param;
_isKill = [_this, 1, false, [false]] call BIS_fnc_param;

// Add a death
_varDeath = format ["SPY_bStats_%1_deaths", _sides select 0];
_newDeaths = (SPY_container getVariable _varDeath) + 1;
SPY_container setVariable [_varDeath, _newDeaths, true];

// Add a kill to the side if required
if ((_isKill)) then
{
	_varKill = format ["SPY_bStats_%1_kills", _sides select 1];
	_newKills = (SPY_container getVariable _varKill) + 1;
	SPY_container setVariable [_varKill, _newKills, true];
};

true