/*
	Author: Spyder (spyder@armalive.com)

	Description:
	Opens bStats scoreboard on player death.

	Parameter(s):
		none

	Returns:
	BOOL
*/

sleep 2;

if ((!(SPY_score_open)) && (SPY_bStats_sbEnabled) &&  (SPY_bStats_sbOnDeath)) then 
{
	_null = [] spawn SPY_bStats_fnc_displayScoreGUI;

	waitUntil { sleep 0.1; (alive player) };

	closeDialog 46;
};