/***************************************************************************
Remove Vehicle
Created by Spyder
spyder@armalive.com
****************************************************************************/

_vehicle = (_this select 0);
_switched = (_this select 1);

// If vehicle position changes because of death wait for respawn
waitUntil { sleep 2; alive player };

player setVariable ["SPY_bStats_isDriver", false, false];
player setVariable ["SPY_bStats_vehicle", objNull, true];

// Set and broadcast new vehicle crew %NOTE% This should be done on the server
_vehicle setVariable ["SPY_bStats_crew", (crew _vehicle), true];