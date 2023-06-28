/***************************************************************************
SIDE BALANCE
CREATED BY SPYDER
SPYDER@ARMALIVE.COM
****************************************************************************/

sleep 20;

while {true} do {

	waitUntil {sleep 0.5; (!([] call SPY_vMission))};

	for "_i" from 1 to 1 do {
	
		sleep 0.5;
		_null = [[], "SPY_GAMELOGIC globalChat '>>> BSTATS: WAITING FOR MORE PLAYERS <<<';", "CLIENT"] spawn JDAM_mpCB;
		SPY_bStats_ranked = false;
	
	};
	
	waitUntil {sleep 0.5; ([] call SPY_vMission)};
	
	for "_i" from 1 to 1 do {
	
		sleep 0.5;
		_null = [[], "SPY_GAMELOGIC globalChat '>>> BSTATS: STATS SAVING RE-ENABLED <<<';", "CLIENT"] spawn JDAM_mpCB;
		SPY_bStats_ranked = true;
	
	};
	
};