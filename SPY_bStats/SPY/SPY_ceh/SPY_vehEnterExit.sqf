/***************************************************************************
SPY_VEHENTEREXIT.SQF
CREATED BY SPYDER
SPYDER@ARMALIVE.COM
****************************************************************************/

private ["_vehicle", "_position", "_entryLoc", "_firedEH", "_driver", "_exitLoc", "_distance", "_playerDriver"];

while {true} do {

	// PLAYER ENTERS VEHICLE
	waitUntil {sleep 0.1; ((vehicle player) != player)};

	_vehicle = (vehicle player);
	_position = (assignedVehicleRole player select 0);
	_entryLoc = (getPos player);

	if ((SPY_CREWAUTH_ENABLED)) then {_null = [_vehicle, _position, player] spawn SPY_crewAuth;};
	
	if ((SPY_BSTATS_ENABLED) && (isNil {_vehicle getVariable "SPY_VEHICLE_INFO"})) then {_null = [[_vehicle, (player getVariable "SPY_PLAYER_ID" select 2)], "_null = _this spawn SPY_initVehicle", (getPlayerUID player)] spawn JDAM_mpCB};
	
	_null = [_vehicle, player] spawn SPY_addVeh;
	_firedEH = _vehicle addEventHandler ["Fired", "_null = [player, (_this select 4), (_this select 5)] spawn SPY_storeShot"];
	
	// PLAYER EXITS VEHICLE
	waitUntil {sleep 0.1; ((vehicle player) == player)};
	
	_driver = (driver _vehicle);
	
	_null = [_vehicle, player] spawn SPY_removeVeh;
	_vehicle removeEventHandler ["Fired", _firedEH];
	
	_exitLoc = (getPos player);
	_distance = (_entryLoc distance _exitLoc);
	
	// AWARD DRIVER TRANSPORT POINTS
	if ((_distance > 500)) then {
	
		_playerDriver = (player getVariable "SPY_PLAYER_INFO" select 4);
	
		[_playerDriver, _driver, _vehicle, _distance, _exitLoc] spawn {
	
			private ["_playerDriver", "_driver", "_vehicle", "_distance", "_exitLoc"];
	
			_playerDriver = (_this select 0);
			_driver = (_this select 1);
			_vehicle = (_this select 2);
			_distance = (_this select 3);
			_exitLoc = (_this select 4);
		
			_playerDriver = false;
		
			sleep 15;
		
			if ((_playerDriver) || (isNull (_driver)) || (!(alive player)) || (_driver != driver _vehicle) || (player in crew _vehicle)) exitWith {};
		
			[[(_driver getVariable "SPY_PLAYER_ID" select 1), (getPlayerUID _driver), _vehicle, _distance, _exitLoc], "[_this, '_this call SPY_trans;'] call SPY_iQueueAdd", "SERVER"] call JDAM_mpCB_A;
	
		};
	
	};
	
};