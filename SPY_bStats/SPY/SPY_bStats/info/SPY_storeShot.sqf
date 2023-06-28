/***************************************************************************
STORE SHOT
CREATED BY SPYDER
SPYDER@ARMALIVE.COM
****************************************************************************/



/***************************************************************************
Init
****************************************************************************/
private ["_player", "_ammoClass", "_magazine", "_explosives", "_weapon", "_playerInfo", "_wpnInfo", "_wpnShots", "_uplink"];

_player = (_this select 0);
_ammoClass = (_this select 1);
_magazine = (_this select 2);

_explosives = ["PipeBombMuzzle", "TimeBombMuzzle", "MineMuzzle", "MineEMuzzle", "HandGrenadeMuzzle", "IRStrobe", "SmokeShellMuzzle"];

if (((assignedVehicleRole _player select 0) == "Cargo")) exitWith {};

_weapon = ["", _ammoClass, "", ""] call SPY_sendWeapon;

if (((_weapon != (currentMuzzle _player)) && (_player == (vehicle _player))) || (!(_magazine in (magazines _player)) && (_weapon in _explosives))) then {

	_uplink = (format ["bstats_wpninfo (%1, %2, %3, 2, 1, 0, 0, 0, 0, 0)", (_player getVariable "SPY_PLAYER_ID" select 0), (str _weapon), time]);
	_null = [[_uplink], "_this call uplink_exec", "SERVER"] spawn JDAM_mpCB;
	
} else {

	_playerInfo = (_player getVariable "SPY_PLAYER_INFO");
	_wpnInfo = (_playerInfo select 6);
	_wpnShots = (_wpnInfo select 0);
/***************************************************************************
End
****************************************************************************/



/***************************************************************************
Store Shot
****************************************************************************/
	switch (_ammoClass) do {
	
		case "B_30mmA10_AP": {_wpnInfo set [0, (_wpnShots + 2)];};
		case "B_23mm_APHE": {_wpnInfo set [0, (_wpnShots + 2)];};
		case "B_762x51_3RndBurst": {_wpnInfo set [0, (_wpnShots + 3)];};
		default {_wpnInfo set [0, (_wpnShots + 1)];};
		
	};
	
	_playerInfo set [6, _wpnInfo];
	
	_player setVariable ["SPY_PLAYER_INFO", _playerInfo, false];

};
/***************************************************************************
End
****************************************************************************/