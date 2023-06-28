/***************************************************************************
On Changed Vehicle Position
Created by Spyder
spyder@armalive.com
****************************************************************************/

private ["_pUID", "_position", "_playerIsDriver"];

_player = (_this select 0);

player sideChat "RUN";

// Retrieve player info
_pUID = player getVariable "SPY_id_uid";

// Player is in vehicle
if (!((vehicle player) isEqualTo player)) then 
{
	// Add vehicle info to player
	_null = [(vehicle player), false] call SPY_bStats_fnc_addVeh;

	// New vehicle
	_vehicle = (player getVariable "SPY_bStats_vehicle");
	
	// Save transport start location
	player setVariable ["SPY_bStats_transStart", (getPos player), false];
	
	// Players position in vehicle
	_position = (assignedVehicleRole player select 0);

	// If bStats is enabled and vehicle init hasnt run, run init
	if ((isNil {_vehicle getVariable "SPY_bStats_deathState"})) then 
	{
		[[_vehicle, (SPY_container getVariable ("SPY_id_" + _pUID) select 1)], "SPY_bStats_fnc_initVeh", nil, true] call BIS_fnc_MP;
	};
	
	// If vehicle fired EH has not been added, add EH
	if ((isNil {_vehicle getVariable "SPY_bStats_firedEH"})) then 
	{
		_ehFiredVeh = _vehicle addEventHandler ["Fired", {_null = [(_this select 0), (_this select 1), (_this select 4), (_this select 6)] call SPY_bStats_fnc_saveShot; }];
		_vehicle setVariable ["SPY_bStats_firedEH", _ehFiredVeh, false];
	};
	
// Player is not in vehicle
} 
else 
{
	// Old vehicle
	_vehicle = (player getVariable "SPY_bStats_vehicle");

	// Remove vehicle information from player and player information from vehicle
	_null = [_vehicle, false] call SPY_bStats_fnc_removeVeh;
	
	// Remove local fired EH from vehicle
	_vehicle removeEventHandler ["Fired", (_vehicle getVariable "SPY_bStats_firedEH")];
	
	// Define transport start and end location
	_transStart = (player getVariable "SPY_bStats_transStart");
	_playerPos = (getPos player);
	
	// Define distance from start and end of transport
	_distance = (_transStart distance _playerPos);
	
	// Player is driver
	_playerIsDriver = (player getVariable "SPY_bStats_isDriver");
	
	// Award transport points
	if ((_distance > 500) && !(_playerIsDriver)) then 
	{
		[driver _vehicle, _distance, _playerPos, _playerIsDriver, _vehicle] spawn 
		{
			_driver = (_this select 0);
			_distance = (_this select 1);
			_playerPos = (_this select 2);
			_playerIsDriver = (_this select 3);
			_vehicle = (_this select 4);
		
			sleep 15;
		
			if ((isNull _driver) or (!alive player) or !(_driver isEqualTo driver _vehicle) or (player in crew _vehicle)) exitWith {};
		
			[[player, player getVariable "SPY_id_uid", _vehicle, _distance, _playerPos], "SPY_bStats_fnc_onTrans", false, false, true] call BIS_fnc_MP;
		};
	};
	
	// Reset global variables
	player setVariable ["SPY_bStats_transStart", nil, false];
	_vehicle setVariable ["SPY_bStats_firedEH", nil, false];
};