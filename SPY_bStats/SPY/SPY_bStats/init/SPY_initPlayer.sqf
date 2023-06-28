/***************************************************************************
INITILIZE PLAYER
CREATED BY SPYDER
SPYDER@ARMALIVE.COM
****************************************************************************/



/***************************************************************************
PLAYER INFO: 
[HIGHEST DAMAGE, HIGHEST DAMAGING UNIT, HIGHEST DAMAGING UNIT UID, IN VEHICLE, DRIVER OF VEHICLE, VEHICLE, [SHOTS, [HEAD, TORSO, ARM, LEG, VEHICLE]], KILLED AMMO]

PLAYER ID:
[UID, NAME, SIDE]

PLAYER SCORE: 
[BATTLE SCORE, TEAMWORK SCORE, TK PUNISH POINTS, KILLS, DEATHS, SUICIDES, TEAM KILLS, VEHICLE KILLS, KILL ASSISTS, AIRCRAFT CRASHES, CIVILIAN CASUALITIES]
****************************************************************************/
private ["_uid", "_varName"];

_uid = (getPlayerUID player);

// TESTING
// if (_uid == "1524806") then {_uid = (str (round (random 555555)));};

_varName = (format ["SPY_bStats_%1", _uid]);

// NEW PLAYER
if ((isNil {SPY_GAMELOGIC getVariable _varName})) then {

	// PLAYER SCORE VARIABLE
	SPY_GAMELOGIC setVariable [_varName, [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], true];
		
	// INITIAL JOIN MESSAGE
	if ((time > 30) && (SPY_JIP_CLIENT)) then {_null = [[(name player), ([playerSide] call SPY_displayName)], "SPY_GAMELOGIC globalChat format ['%1 JOINED THE %2 TEAM', (_this select 0), (_this select 1)];", "CLIENT"] spawn JDAM_mpCB;};

// PREVIOUS PLAYER
} else {
		
	// RE-JOIN MESSAGE
	if ((time > 30) && (SPY_JIP_CLIENT)) then {_null = [[(name player), ([playerSide] call SPY_displayName)], "SPY_GAMELOGIC globalChat format ['%1 RE-JOINED ON THE %2 TEAM', (_this select 0), (_this select 1)];", "CLIENT"] spawn JDAM_mpCB;};
		
};

// PLAYER INFO VARIABLE
player setVariable ["SPY_PLAYER_INFO", [0, player, _uid, false, false, objNull, [0, [0, 0, 0, 0, 0]], ""], false];

// PLAYER ID VARIABLE
player setVariable ["SPY_PLAYER_ID", [_uid, (name player), (playerSide), (faction player)], true];

// SPY DIALOG & ALIVE VARIABLE
SPY_SCORE_OPEN = false;
SPY_ALIVE_PLAYER = true;
/***************************************************************************
END
****************************************************************************/



/***************************************************************************
RETRIEVE PLAYER ID/SCORE VARIABLES
****************************************************************************/
if ((SPY_JIP_CLIENT)) then {_null = [] spawn SPY_updateRequest;};
/***************************************************************************
END
****************************************************************************/



/***************************************************************************
ADD PLAYER EVENT HANDLERS
****************************************************************************/
player addEventHandler ["Fired", {_null = [(_this select 0), (_this select 4), (_this select 5)] spawn SPY_storeShot;}];
player addEventHandler ["HandleDamage", {_null = [_this, time] spawn SPY_reviewHit; (_this select 2);}];
player addEventHandler ["Killed", {_null = [(_this select 0), (_this select 1)] spawn SPY_reviewKill;}];
/***************************************************************************
END
****************************************************************************/



/***************************************************************************
ADD PLAYER USER ACTION EVENT HANDELERS
****************************************************************************/
if ((SPY_bStats_scoreBoard)) then {

	waitUntil {sleep 0.1; (!(isNull(findDisplay 46)))};

	(findDisplay 46) displayAddEventHandler ["KeyDown", "if (([(_this select 1), 'NetworkStats'] call SPY_isKey)  && (!SPY_SCORE_OPEN)) then {_null = [] spawn SPY_checkScore;}; ([(_this select 1), 'NetworkStats'] call SPY_isKey);"];
	(findDisplay 46) displayAddEventHandler ["KeyUp", "if (([(_this select 1), 'NetworkStats'] call SPY_isKey) && (SPY_SCORE_OPEN)) then {closeDialog 46;}; ([(_this select 1), 'NetworkStats'] call SPY_isKey);"];

};
/***************************************************************************
END
****************************************************************************/



/***************************************************************************
CHECK SIDE BALANCE
****************************************************************************/
_null = [] execVM "SPY\SPY_bStats\balance\SPY_sideBalance.sqf";
/***************************************************************************
END
****************************************************************************/