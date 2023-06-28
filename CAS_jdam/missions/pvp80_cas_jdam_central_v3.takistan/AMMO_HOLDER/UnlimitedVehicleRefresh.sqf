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
if (!(isNil {(_armData select 1) getVariable "VEHICLE_IS_REARMING"})) exitWith {};
(_armData select 1) setVariable ["VEHICLE_IS_REARMING", true];
				
_vehicle = _armData select 1;
_objectData = _armData select 2;
_player = _armData select 3;
_armStation = _armData select 4;
			
_delay = _armStation getVariable "ARM_STATION_DELAY";
_armDistance = _armStation getVariable "ARM_STATION_DISTANCE";

if ((!alive _object) || (_object isKindOf "ParachuteBase")) exitWith {_vehicle setVariable ["VEHICLE_IS_REARMING", nil];};
		
_null = [[], format ["player globalChat 'VEHICLE WORKER: Wait until ready, %1 seconds...';", _delay], (getPlayerUID _player)] spawn CAS_mpCB;				
_i = (time + (parseNumber _delay));
waitUntil {(time > _i) || (!alive _vehicle) || ((_vehicle distance _armStation) > _armDistance)};
			
if ((alive _vehicle) && ((_vehicle distance _armStation) <= _armDistance)) then
{
	_null = [_vehicle] call AmmoHolder_NewReload;
}
else
{
	_null = [[], "player globalChat 'VEHICLE WORKER: We cant work on your vehicle...';", (getPlayerUID _player)] spawn CAS_mpCB;
};

_vehicle setVariable ["VEHICLE_IS_REARMING", nil];		