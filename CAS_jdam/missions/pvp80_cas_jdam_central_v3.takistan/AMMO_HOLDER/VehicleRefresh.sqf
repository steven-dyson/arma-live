private "_armData";
private "_vehicle";
private "_objectData";
private "_player";
private "_delay";
private "_armDistance";
private "_armStation";
private "_SERVER_BUILD_OBJECT";
private "_vehicleName";
private "_i";
_armData = _this select 0;
				
_vehicle = _armData select 1;
_objectData = _armData select 2;
_player = _armData select 3;
_armStation = _armData select 4;
	
if (!(isNil {(_armData select 1) getVariable "VEHICLE_IS_REARMING"})) exitWith {};
(_armData select 1) setVariable ["VEHICLE_IS_REARMING", true];
			
_delay = _armStation getVariable "ARM_STATION_DELAY";
_armDistance = _armStation getVariable "ARM_STATION_DISTANCE";

if ((_armStation getVariable "ARM_STATION_AMMO_CHARGES") < 1) exitWith 	{_vehicle setVariable ["VEHICLE_IS_REARMING", nil];};
_armStation setVariable ["ARM_STATION_AMMO_CHARGES", ((_armStation getVariable "ARM_STATION_AMMO_CHARGES") - 1), true];				

_null = [[_vehicle], format ["(_this select 0) vehicleChat 'Rearming this is going to take %1 seconds...';", _delay], "CLIENT"] spawn CAS_mpCB;
_i = (time + (parseNumber _delay));
waitUntil {(time > _i) || (!alive _vehicle) || ((_vehicle distance _armStation) > _armDistance)};


if ((alive _vehicle) && ((_vehicle distance _armStation) <= _armDistance)) then {

	[[_vehicle], "[_this select 0] spawn AmmoHolder_NewReload;", "CLIENT"] spawn CAS_mpCB;
	sleep 1;
	_null = [[_vehicle], "(_this select 0) vehicleChat 'Done rearming!';", "CLIENT"] spawn CAS_mpCB;
	
} else {

	_null = [[_vehicle], "(_this select 0) vehicleChat 'Can no longer rearm...';" , "CLIENT"] spawn CAS_mpCB;
	
};

_vehicle setVariable ["VEHICLE_IS_REARMING", nil];