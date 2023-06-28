_refreshObject = (_this select 3) select 0;
_armStation = (_this select 3) select 1;

_vehicleType = typeOf _refreshObject;
_vehiclePos = getPos _refreshObject;
_vehiclePos set [2, ((_vehiclePos select 2) + 0)];
_vehicleDir = getDir _refreshObject;
_initLine = "";

_objectData = [_vehicleType, _vehiclePos, _vehicleDir, _initLine];
_args = [true, _refreshObject, _objectData, player, _armStation];
[_args, "[_this] spawn AmmoHolder_VehicleRefresh;", "SERVER"] spawn CAS_mpCB;
//publicVariable "DELETE_REARM_VEHICLE_AB";