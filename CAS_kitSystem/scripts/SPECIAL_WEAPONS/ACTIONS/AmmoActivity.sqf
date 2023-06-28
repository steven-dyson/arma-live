/***************************************************************************
AmmoActivity.sqf
Created by Spyder
10 APRIL 2011
****************************************************************************/

private ["_playerPos", "_init"];

player setVariable ["JDAM_AMMO_RELOADED", false];

_playerPos = (getPos player);

player playMove "amovpknlmstpsraswrfldnon_gear";

sleep 2;

if ((alive player)) then {

	_init = "_null = [this, 0, 1, 0, [''], false] execVM 'AmmoHolder.sqf'; this setVariable ['R3F_LOG_Disabled', true, true];";
	_null = [["radio", _playerPos, 0, _init], "_null = [_this] spawn ServerBuildSystem_BuildObject", "SERVER"] spawn CAS_mpCB;
	
	SPY_GAMELOGIC globalChat "AMMO DROPPED";
	
	sleep 120;
	
	player setVariable ["JDAM_AMMO_RELOADED", true];
	
};