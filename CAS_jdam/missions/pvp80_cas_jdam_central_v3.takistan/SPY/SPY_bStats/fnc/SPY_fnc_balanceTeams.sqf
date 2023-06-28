/*
	Author: Spyder (spyder@armalive.com)

	Description:
	Determines the amount of players sides are over numbers and then balances teams by sending players back to the lobby.

	Parameter(s):
		0: NONE

	Returns:
	NONE 
*/

scriptName "SPY_bStats_eh_balanceChanged";

private ["_balance", "_playersBLU", "_playersOP", "_playersList", "_amountOver", "_waitTime", "_uid"];

_balance = false;

waitUntil {sleep 0.1; SPY_server_initialized};

while {sleep 0.1; true} do {

	_playersBLU = (SPY_container getVariable "SPY_bStats_players_blu");
	_playersOP = (SPY_container getVariable "SPY_bStats_players_op");

	if (((count _playersBLU) - (count _playersOP)) > SPY_connect_balanceNum) then {
	
		_balance = true;
		_playersList = _playersBLU;
		_amountOver = ((count _playersBLU) - (count _playersOP));
	
	} else {
	
		if (((count _playersOP) - (count _playersBLU)) > SPY_connect_balanceNum) then {
		
			_balance = true;
			_playersList = _playersOP;
			_amountOver = ((count _playersOP) - (count _playersBLU));
		
		};
	
	};
	
	if ((_balance)) then {
	
		for "_i" from 0 to _amountOver do {
		
			_uid = (_playersList select (count _playersList - 1));
			
			[[_uid, "Server", (format ["Over %1 Players", ((_amountOver - _i) + 1)]), "auto-balanced"], "SPY_connect_fnc_clientKick", true, false] call BIS_fnc_MP;
			
		};
		
	} else {
	
		_null = [[3, (format ["Teams are balanced (%1 to %2)", (count _playersBLU), (count _playersOP)]), 0, ["SPY bStats", "Event Log"], false], "SPY_core_fnc_bMessage", true, false, false] call BIS_fnc_MP;
	
	};
	
	sleep 5;
	
	_null = [[3, (format ["Checking team balance in %1 seconds", SPY_connect_balanceTimer]), 0, ["SPY bStats", "Event Log"], false], "SPY_core_fnc_bMessage", true, false, false] call BIS_fnc_MP;
	
	_waitTime = (time + SPY_connect_balanceTimer);
	
	waitUntil {sleep 0.1; (time >= _waitTime)};
	
};
	

/***************************************************************************
END
****************************************************************************/