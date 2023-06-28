/***************************************************************************
Client Kick
Created by Spyder
spyder@armalive.com

Description:
Removes a player from a game and attempts to kick and/or ban a player if a player admin is connected

Parameter(s):
_this select 0: Player UID or player object (String/Object)

_this select 1: Admin who issued the removal (String)

_this select 2: The reason the player was removed (String)

_this select 3: The type of removal issued. This can be anything. (String)
	"kicked": The #kick command will be attempted on an administrator client
	"banned": The # exec ban command will be attempted on an administrator client

Examples:

Kick player for abusive language
[[player, "Server", "Abusive Language Detected", "banned"], "SPY_connect_fnc_clientKick", true, false] call BIS_fnc_MP;
***************************************************************************/

private ["_violator", "_admin", "_kickReason", "_kickType", "_uName"];

_violator = (_this select 0);
_admin = (_this select 1);
_kickReason = (_this select 2);
_kickType = (_this select 3);

// Run on violator
if ((_violator isEqualTo player)) then
{
	// Enable simulation to false to ensure message is displayed
	player enableSimulation false;

	// Inform violator of message
	_null = [(format ["You were %1 by %2 (%3)", _kickType, _admin, _kickReason]), 999, 3, false] spawn SPY_core_fnc_bInfoScreen;

	sleep 10;

	// Send player to lobby
	endMission "END6";

// Run on everyone else
}
else
{
	_uName = (SPY_container getVariable ("SPY_id_" + _violator) select 0);
	_null = [4, (format ["%1 was %2 by %3 (%4)", _uName, _kickType, _admin, _kickReason]), 0, ["SPY Systems", "Debug Log"], false] spawn SPY_core_fnc_bMessage;

	// Run on admin
	if ((serverCommandAvailable "#kick")) then
	{
		switch (_kickType) do
		{
			case "kicked":
			{
				serverCommand (format ["#kick %1", _id]);
			};
			
			case "banned":
			{
				serverCommand (format ["#exec ban %1", _id]);
				serverCommand (format ["#kick %1", _id]);
			};
		};
	};
};