/***************************************************************************
Crew Authorization
Created by Spyder
spyder@armalive.com
***************************************************************************/



/***************************************************************************
Init
***************************************************************************/
private ["_vehicle", "_position", "_pilot", "_crewman"];

if (((vehicle player) == player)) exitWith {};

_vehicle = (vehicle player);
_position = (assignedVehicleRole player select 0);

_pilot = (player getVariable "SPY_meSys_crewAuth_isPilot");
_crewman = (player getVariable "SPY_meSys_crewAuth_isCrewman");

// Debug
_null = [1, (format ["Crew Auth: %1, %2, %3, %4", _vehicle, _position, _pilot, _crewman]), "LOCAL", false] spawn SPY_core_fnc_bMessage;
/***************************************************************************
Init
***************************************************************************/



/***************************************************************************
Pilot Check
***************************************************************************/
if ((_vehicle isKindOf "Air") && (_position in ["Driver"]) && !(_pilot)) then {

	unassignVehicle player;
	player action ["GetOut", _vehicle];
	_null = [3, "You need a pilot kit", "LOCAL", false, 2] spawn SPY_core_fnc_bMessage;

};
/***************************************************************************
Pilot Check
***************************************************************************/



/***************************************************************************
Crewman Check
***************************************************************************/
if ((_vehicle isKindOf "Tank") && !(_position in ["Cargo"]) && !(_crewman)) then {

	unassignVehicle player;
	player action ["GetOut", _vehicle];
	_null = [3, "You need a crewman kit", "LOCAL", false, 2] spawn SPY_core_fnc_bMessage;

};
/***************************************************************************
Crewman Check
***************************************************************************/