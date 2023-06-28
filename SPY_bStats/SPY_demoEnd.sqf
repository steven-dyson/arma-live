/***************************************************************************
SPY_DEMOEND.SQF
CREATED BY SPYDER
SPYDER@ARMALIVE.COM
****************************************************************************/

private ["_wKills", "_eKills"];

waitUntil {((SPY_GAMELOGIC getVariable "SPY_SIDE_SCORE" select 0) >= 50) || ((SPY_GAMELOGIC getVariable "SPY_SIDE_SCORE" select 2) >= 50) || (time >= 3600)};

_wKills = (SPY_GAMELOGIC getVariable "SPY_SIDE_SCORE" select 0);
_eKills = (SPY_GAMELOGIC getVariable "SPY_SIDE_SCORE" select 2);

// BLUFOR KILLS > 50
if ((_wKills > 50)) exitWith {

	_null = [[], "player enableSimulation false;", "CLIENT"] spawn JDAM_mpCB;
	_null = [[], "_null = [] spawn SPY_checkScore;", "CLIENT"] spawn JDAM_mpCB;
	_null = [[], "player addEventHandler ['HandleDamage', {false}];", "CLIENT"] spawn JDAM_mpCB;
	_null = [[], "SPY_GAMELOGIC globalChat 'BLUFOR WON THE MATCH ... PLEASE WAIT';", "CLIENT"] spawn JDAM_mpCB;
	_null = [[(format ["bstats_endsession (%1, 'BLUFOR')", time])], "_this call uplink_exec;", "SERVER"] spawn JDAM_mpCB;
	sleep 30;
	endMission "END1";

};

// OPFOR KILLS > 50
if ((_eKills > 50)) exitWith {

	_null = [[], "player enableSimulation false;", "CLIENT"] spawn JDAM_mpCB;
	_null = [[], "_null = [] spawn SPY_checkScore;", "CLIENT"] spawn JDAM_mpCB;
	_null = [[], "player addEventHandler ['HandleDamage', {false}];", "CLIENT"] spawn JDAM_mpCB;
	_null = [[], "SPY_GAMELOGIC globalChat 'OPFOR WON THE MATCH ... PLEASE WAIT';", "CLIENT"] spawn JDAM_mpCB;
	_null = [[(format ["bstats_endsession (%1, 'OPFOR')", time])], "_this call uplink_exec;", "SERVER"] spawn JDAM_mpCB;
	sleep 30;
	endMission "END2";

};

// BLUFOR KILLS > OPFOR KILL & TIME REACHED
if ((_wKills > _eKills)) exitWith {

	_null = [[], "player enableSimulation false;", "CLIENT"] spawn JDAM_mpCB;
	_null = [[], "_null = [] spawn SPY_checkScore;", "CLIENT"] spawn JDAM_mpCB;
	_null = [[], "player addEventHandler ['HandleDamage', {false}];", "CLIENT"] spawn JDAM_mpCB;
	_null = [[], "SPY_GAMELOGIC globalChat 'BLUFOR WON THE MATCH ... PLEASE WAIT';", "CLIENT"] spawn JDAM_mpCB;
	_null = [[(format ["bstats_endsession (%1, 'BLUFOR')", time])], "_this call uplink_exec;", "SERVER"] spawn JDAM_mpCB;
	sleep 30;
	endMission "END3";

};

// BLUFOR KILLS < OPFOR KILL & TIME REACHED
if ((_eKills > _wKills)) exitWith {

	_null = [[], "player enableSimulation false;", "CLIENT"] spawn JDAM_mpCB;
	_null = [[], "_null = [] spawn SPY_checkScore;", "CLIENT"] spawn JDAM_mpCB;
	_null = [[], "player addEventHandler ['HandleDamage', {false}];", "CLIENT"] spawn JDAM_mpCB;
	_null = [[], "SPY_GAMELOGIC globalChat 'OPFOR WON THE MATCH ... PLEASE WAIT';", "CLIENT"] spawn JDAM_mpCB;
	_null = [[(format ["bstats_endsession (%1, 'OPFOR')", time])], "_this call uplink_exec;", "SERVER"] spawn JDAM_mpCB;
	sleep 30;
	endMission "END4";

};

// TIE
if ((_wKills == _eKills)) exitWith {

	_null = [[], "player enableSimulation false;", "CLIENT"] spawn JDAM_mpCB;
	_null = [[], "_null = [] spawn SPY_checkScore;", "CLIENT"] spawn JDAM_mpCB;
	_null = [[], "player addEventHandler ['HandleDamage', {false}];", "CLIENT"] spawn JDAM_mpCB;
	_null = [[], "SPY_GAMELOGIC globalChat 'MISSION TIED ... PLEASE WAIT';", "CLIENT"] spawn JDAM_mpCB;
	_null = [[(format ["bstats_endsession (%1, 'TIE')", time])], "_this call uplink_exec;", "SERVER"] spawn JDAM_mpCB;
	sleep 30;
	endMission "END5";

};