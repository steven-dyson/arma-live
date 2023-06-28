/***************************************************************************
On Player Disconnected
Created by Spyder
spyder@armalive.com
****************************************************************************/

private ["_uid", "_playersBLU", "_playersOP", "_player", "_side"];

_uid = (_this select 0);

_playersBLU = (SPY_container getVariable "SPY_bStats_players_blu");
_playersOP = (SPY_container getVariable "SPY_bStats_players_op");
_side = "";

// Ghost player
if ((_uid == "")) exitWith {};

// Send player left to armalive
"armalive" callextension format ["playerleft1;%1;%2", (str _uid), time];

// Retrieve player information
{

	if ((_x == _uid)) then 
	{
		_uid = _x;
		_side = ((SPY_container getVariable ("SPY_id_" + _uid)) select 1);
	};
	
	// Player has been retrieved
	if (!(_side in [""])) exitWith 
	{
		// Determine side specific player list
		switch (_side) do 
		{
			case west: 
			{
				_playersBLU set [_forEachIndex, -1];
				_playersBLU = _playersBLU - [-1];
				SPY_container setVariable ["SPY_bStats_players_blu", _playersBLU, true];
			};
			
			case east: 
			{
				_playersOP set [_forEachIndex, -1];
				_playersOP = _playersOP - [-1];
				SPY_container setVariable ["SPY_bStats_players_op", _playersOP, true];
			};
		};
	};
}
forEach (_playersBLU + _playersOP);