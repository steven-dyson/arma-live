/***************************************************************************
SWITCH WEAPON EVENT HANDLER
CREATED BY SPYDER
SPYDER@ARMALIVE.COM
****************************************************************************/



/***************************************************************************
INIT
****************************************************************************/
private ["_uid", "_wpn", "_wpnVehicle", "_update", "_startTime", "_wpnInfo", "_wpnShots", "_wpnHits", "_endTime", "_wpnTime", "_uplink", "_playerInfo"];
SPY_BSTATS_DISCONNECT = false;
_uid = (getPlayerUID player);

_null = [] spawn {

	while {true} do {
	
		sleep 20;

		// UPDATE LOADOUT
		_null = [player] call SPY_getLoadout;
	
	};
	
};

while {true} do {
	
	// PLAYER HAS WEAPON
	waitUntil {sleep 0.1; (([player, [], ""] call SPY_currentWeapon) != "") && (alive player)};
	
	// INIT WEAPON INFO
	_wpn = ([player, [], ""] call SPY_currentWeapon);
	_wpnVehicle = ((vehicle player) != player);
	_update = (time + 300);
	
	// UPDATE LOADOUT
	_null = [player] call SPY_getLoadout;
/***************************************************************************
END
****************************************************************************/



/***************************************************************************
MONITOR WEAPON TIME
****************************************************************************/	
	// WEAPON START TIME
	_startTime = time;
	
	// PLAYER IS GAINING WEAPON TIME
	while {sleep 0.1; (alive player) && (([player, [], ""] call SPY_currentWeapon) == _wpn)} do {

		// Retrieve weapon info
		_wpnInfo = (player getVariable "SPY_PLAYER_INFO" select 6);
		_wpnShots = (_wpnInfo select 0);
		_wpnHits = (_wpnInfo select 1);
		
		// DEBUG MESSAGE
		// player sideChat format ["WPN: %1", _wpnInfo];
		
		// ENSURE NUMBERS DONT GET TOO HIGH
		if ((time >= _update) || (_wpnShots >= 200)) exitWith {};
		
	};
	
	// END WEAPON TIME
	_endTime = time;
/***************************************************************************
END
****************************************************************************/



/***************************************************************************
SEND WEAPON TIME
****************************************************************************/
	// DEFINE WEAPON TIME
	_wpnTime = (floor (_endTime - _startTime));
	
	// FORMAT/ SEND A2U INFO
	if ((_wpnTime >= 2)) then {
	
		// WEAPON IS VEHICLE
		if ((_wpnVehicle)) then {	
			
			_uplink = (format ["bstats_vehinfo (%1, %2, %3, %4, %5, %6, %7, %8, %9, %10)", _uid, (str _wpn), time, _wpnTime, _wpnShots, (_wpnHits select 0), (_wpnHits select 1), (_wpnHits select 2), (_wpnHits select 3), (_wpnHits select 4)]);
			_null = [[_uplink], "_this call uplink_exec", "SERVER"] spawn JDAM_mpCB;
		
		// WEAPON IS HANDHELD
		} else {
				
			_uplink = (format ["bstats_wpninfo (%1, %2, %3, %4, %5, %6, %7, %8, %9, %10)", _uid, (str _wpn), time, _wpnTime, _wpnShots, (_wpnHits select 0), (_wpnHits select 1), (_wpnHits select 2), (_wpnHits select 3), (_wpnHits select 4)]);
			_null = [[_uplink], "_this call uplink_exec", "SERVER"] spawn JDAM_mpCB;
			
		};
	
	};

	// DEBUG MESSAGE
	// _null = [[_wpnTime, _wpnInfo], "SPY_GAMELOGIC globalChat format ['SW EH: %1, %2', _this select 0, _this select 1];", "CLIENT"] spawn JDAM_mpCB;
/***************************************************************************
END
****************************************************************************/



/***************************************************************************
RESET WEAPON INFO
****************************************************************************/
	// RESET WEAPON INFO
	_playerInfo = (player getVariable "SPY_PLAYER_INFO");
	_playerInfo set [6, [0, [0, 0, 0, 0, 0]]];
	player setVariable ["SPY_PLAYER_INFO", _playerInfo, false];
	_wpn = "";
	
};
/***************************************************************************
END
****************************************************************************/