/***************************************************************************
DOOR BUNDLE
CREATED BY SPYDER
SPYDER001@COMCAST.NET
****************************************************************************/



/***************************************************************************
INIT
****************************************************************************/
private ["_ac", "_side", "_supplies", "_totalSupplies", "_crate", "_parachute"];

_ac = (_this select 0);

_side = (side driver _ac);
_supplies = ((_ac getVariable "SPY_SUPPLIES_READY" select 0) - 1);
_totalSupplies = (_ac getVariable "SPY_SUPPLIES_READY" select 1);
/***************************************************************************
END
****************************************************************************/



/***************************************************************************
CRATE DROPPING
****************************************************************************/
// STATE CRATE DROPPED
_ac setVariable ["SPY_SUPPLIES_READY", [_supplies, _totalSupplies], true];
SPY_GAMELOGIC globalChat format ["SUPPLY CRATE DROPPED, %1/%2 LEFT", _supplies, _totalSupplies];

// CREATE AMMO CRATE
_crate = SPY_AIROPS_C_DB_A createVehicle [0, 0, 0];

// MOVE CRATE UNDER AIRCRAFT
_crate setPosASL [(getPosASL (vehicle player) select 0), (getPosASL (vehicle player) select 1), ((getPosASL (vehicle player) select 2) - 10)];

// CREATE PARACHUTE
_parachute = SPY_AIROPS_C_DB_AP createVehicle [0, 0, 0];

// MOVE PARACHUTE UNDER AIRCRAFT
_parachute setPos (getPos _crate );

// ATTACH CRATE TO PARACHUTE
_crate attachTo [_parachute, [0, 0, -0.15]]; 

// ATTACH MARKER TO CRATE
_null = [_crate, _side, 'normal', 'Supply Crate', 'mil_box', 10] spawn SPY_marker;
/***************************************************************************
END
****************************************************************************/



/***************************************************************************
CRATE LANDED
****************************************************************************/
// WAIT UNTIL CRATE NEAR GROUND
waitUntil {(getPos _crate select 2) <= 0};

// DETACH CRATE FROM PARACHUTE
detach _crate;

// ENSURE CRATE IS NOT BURIED
_crate setPos [(getPos _crate select 0), (getPos _crate select 1), 0];

// DEPLOY SMOKE
_smoke = "SmokeShellBlue" createVehicle (getPos _crate );

// WAIT TIME UNTIL NEW CRATE READY
sleep SPY_AIROPS_VT_DB_A; // %NOTE% This may cause an issue if the client disconnects. Should probably run on server.

// STATE CRATE READY
_supplies = ((_ac getVariable "SPY_SUPPLIES_READY" select 0) + 1);
_ac setVariable ["SPY_SUPPLIES_READY", [_supplies, _totalSupplies], true];
if ((player in crew _ac)) then {SPY_GAMELOGIC globalChat format ["%1/%2 SUPPLY CRATES READY", _supplies, _totalSupplies];};
/***************************************************************************
END
****************************************************************************/