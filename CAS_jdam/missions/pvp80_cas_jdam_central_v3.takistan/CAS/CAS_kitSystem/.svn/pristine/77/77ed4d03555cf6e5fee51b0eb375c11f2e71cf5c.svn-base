/***************************************************************************
AmmoAbility.sqf
Created by Spyder & Goschie
10 APRIL 2011
****************************************************************************/

private ["_swName", "_ammoAction", "_kitName"];

_kitName = _this select 0;

_swName = "CrewmanAbility";
_attachedBody = "none";

while {_kitName == ((call PLAYER_KIT) select 6)} do {

	waitUntil {((_kitName == ((call PLAYER_KIT) select 6)))};
	
	if (_kitName == ((call PLAYER_KIT) select 6)) then {
	
		player setVariable ["SPY_VEHICLE_AUTHS", [true, false], false];

	};

	waitUntil {(!(_kitName == ((call PLAYER_KIT) select 6)))};
	
	player setVariable ["SPY_VEHICLE_AUTHS", nil];

};