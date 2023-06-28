/***************************************************************************
ON PLAYER CONNECTED
CREATED BY SPYDER
SPYDER@ARMALIVE.COM
****************************************************************************/

private ["_uid", "_player", "_side", "_name", "_faction", "_uplink"];

_uid = (_this select 0);

if ((_uid == "")) exitWith {};

waitUntil {(!(isNil "uplink_exec"))};

while {isNil "_player"} do {

	sleep 0.1;

	{

		{

			if ((getPlayerUID _x == _uid)) then {_player = _x};
			
		} forEach units _x;
		
	} forEach allGroups;

};

_side = (str str (side _player));
_name = (str (name _player));
_faction = (str (faction _player));

_uplink = (format ["bstats_newplayer (%1, %2, %3, %4, %5)", _uid, _side, time, _name, _faction]);

[_uplink] call uplink_exec;