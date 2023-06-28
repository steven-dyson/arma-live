/***************************************************************************
SPY_STORESELECTION.SQF
CREATED BY SPYDER
SPYDER@ARMALIVE.COM
****************************************************************************/



/***************************************************************************
INIT
****************************************************************************/
private ["_damagingUnit", "_selectionType", "_ammoClass", "_weapon", "_stats", "_damagingUnitInfo", "_wpnInfo", "_hitInfo", "_currentHits", "_uplink"];

_damagingUnit = (_this select 0);
_selectionType = (_this select 1);
_ammoClass = (_this select 2);

if ((_ammoClass == "")) exitWith {};

_weapon = ["", _ammoClass, "", ""] call SPY_sendWeapon;
_stats = [0, 0, 0, 0, 0];

if ((_weapon != (currentMuzzle _damagingUnit)) && (_damagingUnit == (vehicle _damagingUnit))) then {

	_stats set [_selectionType, 1];
	_uplink = (format ["bstats_wpninfo (%1, %2, %3, %4, %5, %6, %7, %8, %9, %10)", (_damagingUnit getVariable "SPY_PLAYER_ID" select 0), (str _weapon), time, 0, 0, (_stats select 0), (_stats select 1), (_stats select 2), (_stats select 3), (_stats select 4)]);
	_null = [[_uplink], "_this call uplink_exec", "SERVER"] spawn JDAM_mpCB;
	
} else {

	_damagingUnitInfo = (_damagingUnit getVariable "SPY_PLAYER_INFO");
	_wpnInfo = (_damagingUnitInfo select 6);
	_hitInfo = (_wpnInfo select 1);
	_currentHits = ((_hitInfo select _selectionType) + 1);
/***************************************************************************
END
****************************************************************************/



/***************************************************************************
STORE RECIEVED INFO FROM PLAYER
****************************************************************************/
	_hitInfo set [_selectionType, _currentHits];
	_wpnInfo set [1, _hitInfo];
	_damagingUnitInfo set [6, _wpnInfo];

	_damagingUnit setVariable ["SPY_PLAYER_INFO", _damagingUnitInfo, false];

};

// DEBUG MESSAGE
// _null = [[_damagingUnit, _currentHits], "SPY_GAMELOGIC globalChat format ['%1 HITS: %2', _this select 0, _this select 1];", "CLIENT"] spawn JDAM_mpCB;
/***************************************************************************
END
****************************************************************************/