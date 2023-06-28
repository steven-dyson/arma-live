/***************************************************************************
SIDE BALANCE
CREATED BY SPYDER
SPYDER@ARMALIVE.COM
****************************************************************************/



/***************************************************************************
COUNT SIDES
****************************************************************************/
private ["_bluforCount", "_opforCount", "_friendlyCount", "_enemyCount"];

_bluforCount = 0;
_opforCount = 0;

{ 

	{
	
		// ACTUAL PLAYER, NOT AI
		if (((getPlayerUID _x) != "")) then {
		
			// ADD TO BLUFOR COUNT
			// if ((side (group _x) == WEST)) then {
			if (((_x getVariable "SPY_PLAYER_ID" select 2) == WEST)) then {
			// if (((_x getVariable "praa_side") == WEST)) then {
			
				_bluforCount = (_bluforCount + 1);
			
			// ADD TO OPFOR COUNT
			} else {
			
				_opforCount = (_opforCount + 1);
			
			};
			
		};
		
	} forEach units _x;
  
} forEach allGroups;
/***************************************************************************
END
****************************************************************************/



/***************************************************************************
DEFINE FRIENDLY & ENEMY
****************************************************************************/
if ((playerSide == WEST)) then {

	_friendlyCount = _bluforCount;
	_enemyCount = _opforCount;
	
} else {

	_friendlyCount = _opforCount;
	_enemyCount = _bluforCount;

};
/***************************************************************************
END
****************************************************************************/



/***************************************************************************
BALANCE PLAYER
****************************************************************************/
if (((_friendlyCount - _enemyCount) > SPY_bStats_balanceNum)) then {

	player enableSimulation false;
	titleText ["YOUR SIDE IS FULL, CHANGING TEAMS...", "BLACK FADED", 999];
	
	sleep 10;
	
	endMission "END6";

};
/***************************************************************************
END
****************************************************************************/