/***************************************************************************
On Player Connected
Created by Spyder
spyder@armalive.com
****************************************************************************/

private ["_uid", "_player"];

_uid = (_this select 0);

_player = nil;

// Ghost player
if ((_uid == "")) exitWith {};

// Retrieve player from UID
while {sleep 0.1; isNil "_player"} do 
{
	{
		{
			if ((getPlayerUID _x == _uid)) then 
			{
				_player = _x;
			};
		} forEach units _x;
	} forEach allGroups;
};

waitUntil { sleep 0.1; SPY_server_initialized };

// State new player in armalive
"armalive" callExtension format
[
	"newplayer1;%1;%2;%3;%4", 
	_uid, 
	side _player, 
	time, 
	name _player
];