while {sleep 0.1; true} do {

	private ["_position", "_reset"];

	_unit = [_this, 0, objNull, [objNull]] call BIS_fnc_param;
	
	// Unit is alive
	waitUntil {sleep 0.1; (alive player)};
	
	// Initial vehicle & position
	_reset = false;
	_vehicle = vehicle player;
	_position = str (assignedVehicleRole player select 0);

	if ((isNil "_position")) then { _position = ""; };
	
	// Unit enters vehicle
	waitUntil {sleep 0.1; !(str (assignedVehicleRole player select 0) isEqualTo _position) or !(vehicle player isEqualTo _vehicle) or !(alive player)};
	
	if (!(alive player) and (_vehicle isEqualTo (vehicle player))) then { _reset = true; };
	
	if (!(_reset)) then
	{
		// Wait until unit and role have synced
		if (!(str (assignedVehicleRole player select 0) isEqualTo _position) && ((vehicle player) isEqualTo player)) then
		{
			waitUntil {sleep 0.1; !(vehicle player isEqualTo player)};
		};

		// Exec CEH
		_null = [[player, _vehicle, _position], "SPY_ceh_changedVehPos", 0, true] spawn SPY_core_fnc_cehExec;

		// Debug
		_null = [1, "Vehicle Position Change", 0, ["SPY Systems", "Debug Log"], false] spawn SPY_core_fnc_bMessage
	};
};