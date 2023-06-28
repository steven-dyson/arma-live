/***************************************************************************
Check Score
Created by Spyder
spyder@armalive.com
****************************************************************************/



/***************************************************************************
Init
****************************************************************************/
private ["_teamOne", "_teamTwo"];

if ((SPY_SCORE_OPEN)) exitWith {};

SPY_SCORE_OPEN = true;

_teamOne = (SPY_container getVariable "SPY_bStats_missionInfo" select 0);
_teamTwo = (SPY_container getVariable "SPY_bStats_missionInfo" select 1);
/***************************************************************************
Init
****************************************************************************/



/***************************************************************************
Basic scoreboard info
****************************************************************************/
createDialog "DFS_bStatsDlg";

[] spawn 
{
	private ["_missionTime", "_wKills", "_wDeaths", "_eKills", "_eDeaths", "_armaliveOperation"];
	
	((findDisplay 201751) displayCtrl 2) ctrlSetText format ["SERVER NAME: %1", SPY_bStats_serverName];
	((findDisplay 201751) displayCtrl 4) ctrlSetText format ["MISSION NAME: %1", missionName];

	while {dialog} do 
	{
		_missionTime = ([time] call CAS_formatTime);

		_wKills = SPY_container getVariable "SPY_bStats_west_kills";
		_wDeaths = SPY_container getVariable "SPY_bStats_west_deaths";
		_eKills = SPY_container getVariable "SPY_bStats_east_kills";
		_eDeaths = SPY_container getVariable "SPY_bStats_east_deaths";

		_armaliveOperation = (SPY_container getVariable "ARMALIVE_MODE");

		((findDisplay 201751) displayCtrl 0) ctrlSetText format ["SPY Battle Statistics v%1", SPY_bStats_version];
		((findDisplay 201751) displayCtrl 1) ctrlSetText format ["ARMALIVE %1", _armaliveOperation];
		((findDisplay 201751) displayCtrl 3) ctrlSetText format ["GAME TIME: %1", _missionTime];
		((findDisplay 201751) displayCtrl 10) ctrlSetText format ["%1: %2 PLAYERS", (SPY_container getVariable "SPY_bStats_missionInfo" select 0), (count (SPY_container getVariable "SPY_bStats_players_blu"))];
		((findDisplay 201751) displayCtrl 20) ctrlSetText format ["%1: %2 PLAYERS", (SPY_container getVariable "SPY_bStats_missionInfo" select 1), (count (SPY_container getVariable "SPY_bStats_players_op"))];
		((findDisplay 201751) displayCtrl 11) ctrlSetText format ["SCORE: %1", 0];
		((findDisplay 201751) displayCtrl 12) ctrlSetText format ["KILLS: %1", _wKills];
		((findDisplay 201751) displayCtrl 13) ctrlSetText format ["DEATHS: %1", _wDeaths];
		((findDisplay 201751) displayCtrl 21) ctrlSetText format ["SCORE: %1", 0];
		((findDisplay 201751) displayCtrl 22) ctrlSetText format ["KILLS: %1", _eKills];
		((findDisplay 201751) displayCtrl 23) ctrlSetText format ["DEATHS: %1", _eDeaths];
		
		sleep 1;
	};
};
/***************************************************************************
Basic scoreboard info
****************************************************************************/


/***************************************************************************
Display player statistics
****************************************************************************/
{
	[_x] spawn 
	{
		private ["_sideData", "_playerList", "_idc"];
		
		_sideData = (_this select 0);
		_playerList = (_sideData select 0);
		_idc = (_sideData select 1);
	
		if ((count _playerList) == 0) then 
		{
			waitUntil {sleep 0.1; ((count _playerList) != 0)};
		};
		
		while {dialog} do 
		{
			{
				private ["_pUID", "_varName", "_pStats", "_pID", "_admin", "_name", "_score", "_kills", "_deaths", "_suicides", "_teamKills", "_vehKills", "_killAssists", "_acCrashes", "_civCas", "_row"];
				
				if ((!dialog)) exitWith {};
				
				_pUID = _x;
				_pID = SPY_container getVariable format ["SPY_id_%1", _pUID];
				
				_admin = serverCommandAvailable "#kick";
				
				if ((_admin) && !(_pID select 3)) then 
				{
					_name = ((_pID select 0) + " " + "*Admin*");	
				} 
				else 
				{
					if ((_pID select 3)) then
					{
						_name = ((_pID select 0) + " " + "*AI*");
					}
					else
					{
						_name = (_pID select 0);
					};
				};
				
				_scoreBattle = SPY_container getVariable format ["SPY_bStats_%1_sb", _pUID];
				_scoreTeamwork = SPY_container getVariable format ["SPY_bStats_%1_stw", _pUID];
				_score = _scoreBattle + _scoreTeamwork;
				_kills = SPY_container getVariable format ["SPY_bStats_%1_ki", _pUID];
				_deaths = SPY_container getVariable format ["SPY_bStats_%1_d", _pUID];
				_suicides = SPY_container getVariable format ["SPY_bStats_%1_s", _pUID];
				_teamkills = SPY_container getVariable format ["SPY_bStats_%1_tk", _pUID];
				_vehKills = SPY_container getVariable format ["SPY_bStats_%1_kv", _pUID];
				_killAssists = SPY_container getVariable format ["SPY_bStats_%1_ka", _pUID];
				_acCrashes = SPY_container getVariable format ["SPY_bStats_%1_acc", _pUID];
				_objectives = SPY_container getVariable format ["SPY_bStats_%1_obj", _pUID];
				
				if (!(isNil "_row")) then 
				{
					((findDisplay 201751) displayCtrl _idc) lnbDeleteRow _row;
				};
				
				_row = ((findDisplay 201751) displayCtrl _idc) lnbAddRow [_name, (str _score), (str _kills), (str _deaths), (str  _suicides), (str _teamKills), (str _vehKills), (str _killAssists), (str _acCrashes), (str _objectives)];
			
			} forEach _playerList;
			
			sleep 10;
			
			lnbClear ((findDisplay 201751) displayCtrl _idc);
		};
	};
} forEach [[(SPY_container getVariable "SPY_bStats_players_blu"), 14], [(SPY_container getVariable "SPY_bStats_players_op"), 24]];

// State dialog is now closed
waitUntil {!dialog};
SPY_score_open = false;
/***************************************************************************
Display player statistics
****************************************************************************/