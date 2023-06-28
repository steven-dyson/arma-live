/***************************************************************************
Pilot Ability
Created by Spyder & Goschie
spyder@armalive.com
****************************************************************************/

private ["_swName", "_ammoAction", "_kitName"];

_kitName = (_this select 0);

_swName = "PilotAbility";

while {(_kitName == ((call PLAYER_KIT) select 6))} do {

	waitUntil {sleep 0.1; ((_kitName == ((call PLAYER_KIT) select 6)))};

	player setVariable ["SPY_meSys_crewAuth_isPilot", true, false];

	waitUntil {sleep 0.1; ((_kitName != ((call PLAYER_KIT) select 6)))};

	player setVariable ["SPY_meSys_crewAuth_isPilot", false, false];

};