/***************************************************************************
SPY_writeScore.sqf
Created by Spyder
23 MAY 2011
_null = [] spawn SPY_writeScore;
****************************************************************************/



/***************************************************************************
Init
****************************************************************************/
private ["_header", "_spacer", "_break", "_footer", "_missionName", "_missionNumber", "_teamOne", "_teamTwo", "_missionTime", "_wKills", "_wDeaths", "_eKills", "_eDeaths", "_allPlayers"];

_header = "########## START SPY BATTLE STATS ##########";
_spacer = "";
_break = "#########################################";
_footer = "########### END SPY BATTLE STATS ###########";

_missionName = (SPY_GAMELOGIC getVariable "SPY_MISSION_INFO" select 0);
_missionNumber = (SPY_GAMELOGIC getVariable "SPY_MISSION_INFO" select 1);
_teamOne = (SPY_GAMELOGIC getVariable "SPY_MISSION_INFO" select 2);
_teamTwo = (SPY_GAMELOGIC getVariable "SPY_MISSION_INFO" select 3);

_missionTime = ([(time)] call JDAM_formatTime);

_wKills = (SPY_GAMELOGIC getVariable "SPY_SIDE_SCORE" select 0);
_wDeaths = (SPY_GAMELOGIC getVariable "SPY_SIDE_SCORE" select 1);
_eKills = (SPY_GAMELOGIC getVariable "SPY_SIDE_SCORE" select 2);
_eDeaths = (SPY_GAMELOGIC getVariable "SPY_SIDE_SCORE" select 3);

_allPlayers = []; 
/***************************************************************************
End
****************************************************************************/



/***************************************************************************
Array of all players
****************************************************************************/
{ 

	{
	
		if (_x == player) then {_allPlayers set [(count _allPlayers), format ["SPY_bStats_%1", getPlayerUID _x]];};
		
	} forEach units _x;
  
} forEach allGroups;
/***************************************************************************
End
****************************************************************************/



/***************************************************************************
Top Spacer
****************************************************************************/
diag_log text _spacer;
diag_log text _spacer;
diag_log text _spacer;
diag_log text _spacer;
/***************************************************************************
End
****************************************************************************/



/***************************************************************************
Header
****************************************************************************/
diag_log text _header;
diag_log text format ["%1 - %2", _missionName, _missionNumber];
diag_log text format ["GAME TIME: %1", _missionTime];

diag_log text _break;
/***************************************************************************
End
****************************************************************************/



/***************************************************************************
Mission Scores
****************************************************************************/
diag_log text "MISSION SCORES";
diag_log text _spacer;

diag_log text format ["%1: %2", _teamOne, (_wKills - _wDeaths)];
diag_log text format ["%1: %2", _teamTwo, (_eKills - _eDeaths)];
if (_wKills > _eKills) then {diag_log text format ["WINNER = %1", _teamOne];};
if (_wKills < _eKills) then {diag_log text format ["WINNER = %1", _teamTwo];};
if (_wKills == _eKills) then {diag_log text "WINNER = NONE";};

diag_log text _break;
/***************************************************************************
End
****************************************************************************/



/***************************************************************************
Side Scores
****************************************************************************/
diag_log text "SIDE SCORES";
diag_log text _spacer;

diag_log text format ["%1 KILLS: %2", _teamOne, _wKills];
diag_log text format ["%1 DEATHS: %2", _teamOne, _wDeaths];
diag_log text format ["%1 KILLS: %2", _teamTwo, _eKills];
diag_log text format ["%1 DEATHS: %2", _teamTwo, _eDeaths];

diag_log text _break;
/***************************************************************************
End
****************************************************************************/



/***************************************************************************
Individual Player Scores (WEST)
****************************************************************************/
diag_log text format ["%1 PLAYER SCORES", _teamOne];
diag_log text _spacer;

{

	private ["_side", "_name", "_score", "_kills", "_deaths", "_suicides", "_teamKills", "_vehKills", "_killAssists", "_acCrashes", "_civCas"];

	_side = (SPY_GAMELOGIC getVariable _x select 2);

	if ((_side == west)) then {
		
		_name = (SPY_GAMELOGIC getVariable _x select 1);
		_score = (SPY_GAMELOGIC getVariable _x select 3);
		_kills = (SPY_GAMELOGIC getVariable _x select 4);
		_deaths = (SPY_GAMELOGIC getVariable _x select 5);
		_suicides = (SPY_GAMELOGIC getVariable _x select 6);
		_teamkills = (SPY_GAMELOGIC getVariable _x select 7);
		_vehKills = (SPY_GAMELOGIC getVariable _x select 8);
		_killAssists = (SPY_GAMELOGIC getVariable _x select 9);
		_acCrashes = (SPY_GAMELOGIC getVariable _x select 10);
		_civCas = (SPY_GAMELOGIC getVariable _x select 11);
		
		diag_log text format ["|%1| |SCORE: %2| |KILLS: %3| |DEATHS: %4| |SUICIDES: %5| |TKS: %6| |VEHICLE KILLS: %7| |KILL ASSISTS: %8| |AIRCRAFT CRASHES: %9| |CIVILIAN CASUALITIES: %10|", _name, _score, _kills, _deaths, _suicides, _teamkills, _vehKills, _killAssists, _acCrashes, _civCas];
		
	};

} forEach _allPlayers;

sleep 0.001;

diag_log text _break;
/***************************************************************************
End
****************************************************************************/



/***************************************************************************
Individual Player Scores (EAST)
****************************************************************************/
diag_log text format ["%1 PLAYER SCORES", _teamTwo];
diag_log text _spacer;

{

	private ["_side", "_name", "_score", "_kills", "_deaths", "_suicides", "_teamKills", "_vehKills", "_killAssists", "_acCrashes", "_civCas"];

	_side = (SPY_GAMELOGIC getVariable _x select 2);

	if ((_side == east)) then {
		
		_name = (SPY_GAMELOGIC getVariable _x select 1);
		_score = (SPY_GAMELOGIC getVariable _x select 3);
		_kills = (SPY_GAMELOGIC getVariable _x select 4);
		_deaths = (SPY_GAMELOGIC getVariable _x select 5);
		_suicides = (SPY_GAMELOGIC getVariable _x select 6);
		_teamkills = (SPY_GAMELOGIC getVariable _x select 7);
		_vehKills = (SPY_GAMELOGIC getVariable _x select 8);
		_killAssists = (SPY_GAMELOGIC getVariable _x select 9);
		_acCrashes = (SPY_GAMELOGIC getVariable _x select 10);
		_civCas = (SPY_GAMELOGIC getVariable _x select 11);
		
		diag_log text format ["|%1| |SCORE: %2| |KILLS: %3| |DEATHS: %4| |SUICIDES: %5| |TKS: %6| |VEHICLE KILLS: %7| |KILL ASSISTS: %8| |AIRCRAFT CRASHES: %9| |CIVILIAN CASUALITIES: %10|", _name, _score, _kills, _deaths, _suicides, _teamkills, _vehKills, _killAssists, _acCrashes, _civCas];
		
	};

} forEach _allPlayers;
/***************************************************************************
End
****************************************************************************/



/***************************************************************************
Bottom Spacer
****************************************************************************/
diag_log text _footer;
diag_log text _spacer;
diag_log text _spacer;
diag_log text _spacer;
diag_log text _spacer;
/***************************************************************************
End
****************************************************************************/