/***************************************************************************
AmmoAbility.sqf
Created by Spyder & Goschie
10 APRIL 2011
****************************************************************************/

private "_swName";
private "_ammoAction";
private "_kitName";
_swName = "AmmoAbility";
_ammoAction = "none";
_attachedBody = "none";
_kitName = _this select 0;

player setVariable ["JDAM_AMMO_RELOADED", true];

while {_kitName == ((call PLAYER_KIT) select 6)} do {

	waitUntil {(player getVariable "JDAM_AMMO_RELOADED") && ((_kitName == ((call PLAYER_KIT) select 6)))};
	
	if (_kitName == ((call PLAYER_KIT) select 6)) then {
	
		_attachedBody = player;
		_ammoAction = _attachedBody addAction ["Drop Ammo", "PLAYER_KITS\SPECIAL_WEAPONS\ACTIONS\AmmoActivity.sqf"];

	};

	waitUntil {(!(player getVariable "JDAM_AMMO_RELOADED")) || (!(_kitName == ((call PLAYER_KIT) select 6)))};

	if ((typeName _ammoAction) != "STRING") then {

		_attachedBody removeAction _ammoAction;
		_ammoAction = "none";
		player setVariable ["JDAM_AMMO_RELOADED", nil];

	};

};