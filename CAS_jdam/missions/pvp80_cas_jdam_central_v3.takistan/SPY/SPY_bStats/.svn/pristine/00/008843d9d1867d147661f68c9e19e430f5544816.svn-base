/***************************************************************************
Add Vehicle
Created by Spyder
spyder@armalive.com
****************************************************************************/

private ["_vehicle", "_switched", "_vehicleSide", "_playerInfo", "_playerSide"];

_vehicle = (_this select 0);
_switched = (_this select 1);

// Wait until the vehicle has initialized
waitUntil { sleep 0.1; (!isNil {_vehicle getVariable "SPY_bStats_deathState"}) };

// Vehicle info
_vehicleSide = _vehicle getVariable "SPY_bStats_side";

// Player info
_pUID = player getVariable "SPY_id_uid";
_playerSide = (SPY_container getVariable format ["SPY_id_%1", _pUID] select 1);

if (((driver _vehicle) isEqualTo player) || (_switched)) then
{
	player setVariable ["SPY_bStats_isDriver", true, false];
};

// Save global variable of current vehicle on player
player setVariable ["SPY_bStats_vehicle", (vehicle player), true];

// Set vehicle info
_vehicle setVariable ["SPY_bStats_side", _playerSide, true];
_vehicle setVariable ["SPY_bStats_crew", (crew _vehicle), true];

// Change vehicle sides globally. Damage must now be reset from possible team fire
if (!(_vehicleSide isEqualTo _playerSide)) then
{
	_vehicle setVariable ["SPY_bStats_switchState", true, true]; // Change team in progress
	
	sleep 10; // Ensure ample time for missiles
	
	_vehicle setVariable ["SPY_bStats_switchState", false, true]; // Change team finished
};