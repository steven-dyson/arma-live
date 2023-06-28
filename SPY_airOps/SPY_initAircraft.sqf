/***************************************************************************
AIR OPERATIONS INITILIZATION
CREATED BY SPYDER
SPYDER001@COMCAST.NET

_null = [this] spawn SPY_initAircraft;
****************************************************************************/



/***************************************************************************
INIT
****************************************************************************/
private ["_ac"];

_ac = _this select 0;

// SERVER ONLY (TEST THE CARGO)
if ((isServer)) then {

	_ac setVariable ["SPY_SUPPLIES_READY", [5, 5], true];
	
	clearWeaponCargo _ac;
	clearMagazineCargo _ac;

};
/***************************************************************************
END
****************************************************************************/



/***************************************************************************
AIRCRAFT ADDACIONS
****************************************************************************/
if ((isDedicated)) exitWith {};

waitUntil {(!(isNil {_ac getVariable "SPY_SUPPLIES_READY"}))};

// DROP DOOR BUNDLE (HELICOPTER & CARGO PLANE) [ALL]
_ac addAction ["<t color=""#0000ff"">Drop Supply Crate", "SPY\SPY_airOps\SPY_doorBundle.sqf", [], -98, false, true, "", "(_this in crew _target) && (_this == driver _target) && ((getPos _target select 2) > 150) && ((_target getVariable 'SPY_SUPPLIES_READY' select 0) > 0)"];

// TAKE/DROP PARACHUTES (HELICOPTERS & CARGO PLANE) [ACE]
if ((SPY_ACE_ENABLED)) then {

	_ac addAction ["<t color=""#0000ff"">Take T10D", "SPY\SPY_airOps\SPY_takeObject.sqf", ["T10D"], -92, false, true, "", "!('ACE_ParachuteRoundPack' in (weapons player)) && !(player == driver vehicle player)"];
	_ac addAction ["<t color=""#0000ff"">Take MC-5", "SPY\SPY_airOps\SPY_takeObject.sqf", ["MC5"], -93, false, true, "", "!('ACE_ParachutePack' in (weapons player)) && !(player == driver vehicle player)"];
	_ac addAction ["<t color=""#0000ff"">Drop Parachute", "SPY\SPY_airOps\SPY_dropChute.sqf", [], -94, false, true, "", "(('ACE_ParachuteRoundPack' in (weapons player)) || ('ACE_ParachutePack' in (weapons player))) && !(player == driver vehicle player)"];

};

// BIS HALO (HELICOPTERS & CARGO PLANE) [STOCK]
if (!(SPY_ACE_ENABLED)) then {

	_ac addaction ["<t color=""#0000ff"">HALO", "SPY\SPY_airOps\SPY_bisHalo.sqf", [], -95, false, true, "", "!(player == driver vehicle player) && (vehicle player != player) && (getPos player select 2 > 300)"];
	
};

// TAKE/DROP FAST ROPES (HELICOPTERS)
if ((SPY_ACE_ENABLED) && (_ac isKindOf "Helicopter")) exitWith {

	_ac addAction ["<t color=""#336600"">Take Rope", "SPY\SPY_airOps\SPY_takeObject.sqf", ["Rope"], -96, false, true, "", "!('ACE_Rope_M_120' in (magazines player)) && !(player == driver vehicle player)"];
	_ac addAction ["<t color=""#336600"">Drop Rope", "SPY\SPY_airOps\SPY_dropRope.sqf", [], -97, false, true, "", "('ACE_Rope_M_120' in (magazines player)) && !(player == driver vehicle player) && (_target getVariable 'SPY_DOORBUNDLE_READY')"];

};
	
// DEPLOY CHALKS (CARGO PLANE)
if ((_ac isKindOf "Plane")) exitWith {

	_ac addAction ["<t color=""#990000"">Deploy Chalk", "SPY\SPY_airOps\SPY_deployChalk.sqf", ['group'], -99, false, true, "", "(player in _target) && (leader player == player) && ((getPos _target select 2) > 150)"]; 
	_ac addAction ["<t color=""#990000"">Deploy All Chalks", "SPY\SPY_airOps\SPY_deployChalk.sqf", ['all'], -100, false, true, "", "(player in _target) && (player == driver vehicle player) && ((getPos _target select 2) > 150)"];

};
/***************************************************************************
END
****************************************************************************/