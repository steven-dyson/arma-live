/***************************************************************************
ADD VEHICLE
CREATED BY SPYDER
SPYDER@ARMALIVE.COM
****************************************************************************/



/***************************************************************************
INIT
****************************************************************************/
private ["_vehicle", "_player", "_vehicleInfo", "_vehicleSide", "_playerInfo", "_playerSide", "_playerUID"];

_vehicle = _this select 0;
_player = _this select 1;

_vehicleInfo = (_vehicle getVariable "SPY_VEHICLE_INFO");
_vehicleSide = (_vehicleInfo select 0);

_playerInfo = (_player getVariable "SPY_PLAYER_INFO");
_playerSide = (_player getVariable "SPY_PLAYER_ID" select 2);
_playerUID = (_player getVariable "SPY_PLAYER_ID" select 0);
/***************************************************************************
END
****************************************************************************/



/***************************************************************************
SET PLAYER VEHICLE INFO
****************************************************************************/
_playerInfo set [3, true];
if (((driver _vehicle) == _player)) then {_playerInfo set [4, true];};
_playerInfo set [5, _vehicle];

_player setVariable ["SPY_PLAYER_INFO", _playerInfo, false];
/***************************************************************************
END
****************************************************************************/



/***************************************************************************
SET VEHICLE SIDE INFO & RESET DAMAGING UNIT
****************************************************************************/
_vehicleInfo set [0, _playerSide];
_vehicleInfo set [4, (crew _vehicle)];
_vehicleInfo set [9, _playerUID];

if ((_vehicleSide != _playerSide)) then {

	_vehicleInfo set [1, 0];
	_vehicleInfo set [2, objNull];
	_vehicleInfo set [3, ""];
	_vehicleInfo set [7, true];
	_vehicleInfo set [8, ""];
	
	sleep 10;
	
	_vehicleInfo set [7, false];

};

_vehicle setVariable ["SPY_VEHICLE_INFO", _vehicleInfo, true];
/***************************************************************************
END
****************************************************************************/