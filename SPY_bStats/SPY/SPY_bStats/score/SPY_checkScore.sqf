/***************************************************************************
CHECK SCORE
CREATED BY SPYDER
SPYDER@ARMALIVE.COM

_null = [] spawn SPY_checkScore;
****************************************************************************/



/***************************************************************************
INIT
****************************************************************************/
private ["_serverName", "_missionName", "_missionTime", "_wKills", "_wDeaths", "_eKills", "_eDeaths", "_a2uOperation", "_a2uRanking"];

SPY_SCORE_OPEN = true;

_serverName = (SPY_GAMELOGIC getVariable "SPY_MISSION_INFO" select 0);
_missionName = (SPY_GAMELOGIC getVariable "SPY_MISSION_INFO" select 1);
_missionTime = ([time] call JDAM_formatTime);

_wKills = (SPY_GAMELOGIC getVariable "SPY_SIDE_SCORE" select 0);
_wDeaths = (SPY_GAMELOGIC getVariable "SPY_SIDE_SCORE" select 1);
_eKills = (SPY_GAMELOGIC getVariable "SPY_SIDE_SCORE" select 2);
_eDeaths = (SPY_GAMELOGIC getVariable "SPY_SIDE_SCORE" select 3);

_a2uOperation = (SPY_GAMELOGIC getVariable "MHJ_A2U_MODE" select 0);
_a2uRanking = (SPY_GAMELOGIC getVariable "MHJ_A2U_MODE" select 1);
/***************************************************************************
END
****************************************************************************/



/***************************************************************************
BASIC SCOREBOARD INFO
****************************************************************************/
createDialog "SPY_dlg_stats";

((findDisplay 201751) displayCtrl 1) ctrlSetText format ["ARMA 2 UPLINK %1 (%2)", _a2uOperation, _a2uRanking];
((findDisplay 201751) displayCtrl 2) ctrlSetText format ["SERVER NAME: %1", _serverName];
((findDisplay 201751) displayCtrl 3) ctrlSetText format ["GAME TIME: %1", _missionTime];
((findDisplay 201751) displayCtrl 4) ctrlSetText format ["MISSION NAME: %1", _missionName];

if ((SPY_bStats_valhalla)) then {

	((findDisplay 201751) displayCtrl 11) ctrlSetText format ["SCORE: %1", (Config_WestBaseFlag getVariable "score")];
	
} else {

	((findDisplay 201751) displayCtrl 11) ctrlSetText format ["SCORE: %1", (_wKills * 10)];
	
};

((findDisplay 201751) displayCtrl 12) ctrlSetText format ["KILLS: %1", _wKills];
((findDisplay 201751) displayCtrl 13) ctrlSetText format ["DEATHS: %1", _wDeaths];

if ((SPY_bStats_valhalla)) then {

	((findDisplay 201751) displayCtrl 21) ctrlSetText format ["SCORE: %1", (Config_EastBaseFlag getVariable "score")];
	
} else {

	((findDisplay 201751) displayCtrl 21) ctrlSetText format ["SCORE: %1", (_eKills * 10)];
	
};

((findDisplay 201751) displayCtrl 22) ctrlSetText format ["KILLS: %1", _eKills];
((findDisplay 201751) displayCtrl 23) ctrlSetText format ["DEATHS: %1", _eDeaths];
/***************************************************************************
END
****************************************************************************/



/***************************************************************************
BLUFOR PLAYER STATS
****************************************************************************/
[] spawn {

	private ["_teamOne", "_bluforPlayers"];

	_teamOne = (SPY_GAMELOGIC getVariable "SPY_MISSION_INFO" select 2);
	_bluforPlayers = [];

	{ 

		{
		
			private ["_uid", "_side", "_varName"];
		
			_uid = (_x getVariable "SPY_PLAYER_ID" select 0);
			_side = (_x getVariable "SPY_PLAYER_ID" select 2);
			_varName = (format ["SPY_bStats_%1", _uid]);
		
			if ((_uid != "") && (_side == west)) then {
			
				_bluforPlayers set [(count _bluforPlayers), _x];
				
			};
			
		} forEach units _x;
	  
	} forEach allGroups;
	
	((findDisplay 201751) displayCtrl 10) ctrlSetText format ["%1: %2 PLAYERS", _teamOne, (count _bluforPlayers)];

	_bluforPlayers = [_bluforPlayers, SPY_GAMELOGIC, 0, 2] call SPY_orderArrayP;

	{

		private ["_uid", "_varName", "_name", "_score", "_kills", "_deaths", "_suicides", "_teamKills", "_vehKills", "_killAssists", "_acCrashes", "_civCas"];
		
		_uid = (_x getVariable "SPY_PLAYER_ID" select 0);
		_varName = (format ["SPY_bStats_%1", (_x getVariable "SPY_PLAYER_ID" select 0)]);
		
		_name = (_x getVariable "SPY_PLAYER_ID" select 1);
		_score = (SPY_GAMELOGIC getVariable _varName select 0);
		_kills = (SPY_GAMELOGIC getVariable _varName select 3);
		_deaths = (SPY_GAMELOGIC getVariable _varName select 4);
		_suicides = (SPY_GAMELOGIC getVariable _varName select 5);
		_teamkills = (SPY_GAMELOGIC getVariable _varName select 6);
		_vehKills = (SPY_GAMELOGIC getVariable _varName select 7);
		_killAssists = (SPY_GAMELOGIC getVariable _varName select 8);
		_acCrashes = (SPY_GAMELOGIC getVariable _varName select 9);
		_civCas = (SPY_GAMELOGIC getVariable _varName select 10);
		
		((findDisplay 201751) displayCtrl 14) lnbAddRow [_name, (str _score), (str _kills), (str _deaths), (str  _suicides), (str _teamKills), (str _vehKills), (str _killAssists), (str _acCrashes), (str _civCas)];
		
	} forEach _bluforPlayers;
	
};
/***************************************************************************
END
****************************************************************************/



/***************************************************************************
OPFOR PLAYER STATS
****************************************************************************/
[] spawn {

	private ["_teamTwo", "_opforPlayers"];

	_teamTwo = (SPY_GAMELOGIC getVariable "SPY_MISSION_INFO" select 3);
	_opforPlayers = []; 

	{ 

		{
		
			private ["_uid", "_side", "_varName"];
		
			_uid = (_x getVariable "SPY_PLAYER_ID" select 0);
			_side = (_x getVariable "SPY_PLAYER_ID" select 2);
			_varName = (format ["SPY_bStats_%1", _uid]);
			
			if ((_uid != "") && (_side == east)) then {
			
				_opforPlayers set [(count _opforPlayers), _x];
			
			};
			
		} forEach units _x;
	  
	} forEach allGroups;

	((findDisplay 201751) displayCtrl 20) ctrlSetText format ["%1: %2 PLAYERS", _teamTwo, (count _opforPlayers)];
	
	_opforPlayers = [_opforPlayers, SPY_GAMELOGIC, 0, 2] call SPY_orderArrayP;

	{

		private ["_uid", "_varName", "_name", "_score", "_kills", "_deaths", "_suicides", "_teamKills", "_vehKills", "_killAssists", "_acCrashes", "_civCas"];
		
		_uid = (_x getVariable "SPY_PLAYER_ID" select 0);
		_varName = (format ["SPY_bStats_%1", _uid]);
		
		_name = (_x getVariable "SPY_PLAYER_ID" select 1);
		_score = (SPY_GAMELOGIC getVariable _varName select 0);
		_kills = (SPY_GAMELOGIC getVariable _varName select 3);
		_deaths = (SPY_GAMELOGIC getVariable _varName select 4);
		_suicides = (SPY_GAMELOGIC getVariable _varName select 5);
		_teamkills = (SPY_GAMELOGIC getVariable _varName select 6);
		_vehKills = (SPY_GAMELOGIC getVariable _varName select 7);
		_killAssists = (SPY_GAMELOGIC getVariable _varName select 8);
		_acCrashes = (SPY_GAMELOGIC getVariable _varName select 9);
		_civCas = (SPY_GAMELOGIC getVariable _varName select 10);
		
		((findDisplay 201751) displayCtrl 24) lnbAddRow [_name, (str _score), (str _kills), (str _deaths), (str  _suicides), (str _teamKills), (str _vehKills), (str _killAssists), (str _acCrashes), (str _civCas)];
		
	} forEach _opforPlayers;

};
/***************************************************************************
END
****************************************************************************/



/***************************************************************************
UPDATING MISSION TIME
****************************************************************************/
while {dialog} do {

	_missionTime = ([(time)] call JDAM_formatTime);
	((findDisplay 201751) displayCtrl 3) ctrlSetText format ["GAME TIME: %1", _missionTime];

};
/***************************************************************************
END
****************************************************************************/



/***************************************************************************
STATE DIALOG IS NOW CLOSED
****************************************************************************/
waitUntil {!dialog};

SPY_SCORE_OPEN = false;
/***************************************************************************
END
****************************************************************************/