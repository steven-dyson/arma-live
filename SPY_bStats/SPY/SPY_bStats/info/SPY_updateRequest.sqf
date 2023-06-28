/***************************************************************************
UPDATE REQUEST
CREATED BY SPYDER
SPYDER@ARMALIVE.COM
****************************************************************************/

{ 

	{

		if ((getPlayerUID _x != "")) then {

			_null = [[], "_null = _this spawn SPY_updateSend;", getPlayerUID _x] spawn JDAM_mpCB;

		};

	} forEach units _x;

} forEach allGroups;