/***************************************************************************
GATHER LOADOUT
CREATED BY SPYDER
SPYDER@ARMALIVE.COM
***************************************************************************/



/***************************************************************************
OLD LOADOUT
***************************************************************************/
private ["_unit", "_loadout", "_oPrimary", "_oUgl", "_oSecondaries", "_oSidearm", "_oExplosives", "_cPrimary", "_cUgl", "_cSecondaries", "_cSidearm", "_cExplosives"];

_unit = (_this select 0);

// SET WEAPONS TO DEFAULT
if ((isNil {_unit getVariable "SPY_PLAYER_LOADOUT"})) then {_unit setVariable ["SPY_PLAYER_LOADOUT", ["", "", [], "", []]];};

// GATHER OLD LOADOUT
_loadout = (_unit getVariable "SPY_PLAYER_LOADOUT");

_oPrimary = (_loadout select 0);
_oUgl = (_loadout select 1);
_oSecondaries = (_loadout select 2);
_oSidearm = (_loadout select 3);
_oExplosives = (_loadout select 4);
/***************************************************************************
END
***************************************************************************/



/***************************************************************************
CURRENT LOADOUT
***************************************************************************/
// GATHER CURRENT PRIMARY
_cPrimary = (primaryWeapon _unit);
if ((isNil "_cPrimary")) then {_cPrimary = ""};

// GATHER CURRENT UGL
private ["_cPrimaryMuzzles"];

if ((_cPrimary != "")) then {_cPrimaryMuzzles = (getArray (configFile >> "cfgWeapons" >> _cPrimary >> "muzzles"));};
if ((!isNil {_cPrimaryMuzzles select 1})) then {_cUgl = (_cPrimaryMuzzles select 1)} else {_cUgl = "";};

// GATHER CURRENT SECONDARIES
if (!((secondaryWeapon _unit) in _oSecondaries)) then {

	_cSecondaries = _oSecondaries + [(secondaryWeapon _unit)];
	// _cSecondaries set [count _cSecondaries, ()];
	
} else {

	_cSecondaries = _oSecondaries;
	
};

// GATHER CURRENT SIDEARM
{

	private ["_muzzles", "_exceptions"];

	_muzzles = (getArray (configFile >> "cfgWeapons" >> _x >> "muzzles"));
	
	_exceptions = [_cPrimary, _cUgl, (secondaryWeapon _unit), "ItemGPS", "ItemRadio", "ItemWatch", "ItemCompass", "ItemMap", "NVGoggles", "Binocular", "Binocular_Vector", "Laserdesignator"];
	
	if ((!([_muzzles, []] call SPY_compareArray)) && (!(_x in _exceptions))) then {_cSidearm = _x};

} forEach (weapons _unit);

if ((isNil "_oSidearm")) then {_oSidearm = ""};

// GATHER CURRENT EXPLOSIVES
_cExplosives = _oExplosives;
{

	private ["_exp"];
	
	_exp = ["HandGrenade_West", "HandGrenade_East", "HandGrenade", "BAF_L109A1_HE", "PipeBomb", "TimeBomb", "Mine", "MineE", "SmokeShell", "SmokeShellGreen", "SmokeShellRed", "SmokeShellOrange", "SmokeShellYellow", "SmokeShellPurple", "SmokeShellBlue", "IR_Strobe_Target", "IR_Strobe_Marker"];
	if ((_x in _exp) && !(_x in _cExplosives)) then {_cExplosives = _cExplosives + [_x];};
	
} forEach (magazines player);
/***************************************************************************
END
***************************************************************************/



/***************************************************************************
UPDATE LOADOUT
***************************************************************************/
// IF OLD PRIMARY != NEW PRIMARY THEN CHANGE PRIMARY
if ((_oPrimary != _cPrimary)) then {_loadout set [0, _cPrimary];};

// IF OLD UGL != NEW UGL THEN CHANGE UGL
if ((_oUgl != _cUgl)) then {_loadout set [1, _cUgl];};

// IF OLD SECONDARIES != NEW SECONDARIES THEN CHANGE SECONDARIES

// player sideChat format ["%1, %2, %3", _oSecondaries, _cSecondaries, ([_oSecondaries, _cSecondaries] call SPY_compareArray)];

if (!([_oSecondaries, _cSecondaries] call SPY_compareArray) && !(isNil {secondaryWeapon _unit})) then {_loadout set [2, _cSecondaries];};

// IF OLD SIDEARM != NEW SIDEARM THEN CHANGE SIDEARM
if ((_oSidearm != _cSidearm)) then {_loadout set [3, _cSidearm];};

// IF OLD EXPLOSIVES != NEW EXPLOSIVES THEN CHANGE EXPLOSIVES
if (!([_oExplosives, _cExplosives] call SPY_compareArray)) then {_loadout set [4, _cExplosives];};

// STORE LOADOUT
_unit setVariable ["SPY_PLAYER_LOADOUT", _loadout, false];

//player sideChat format ["%1, %2, %3, %4, %5", _oPrimary, _oUgl, _oSecodaries, _oSidearm, _oExplosives];
//player sideChat format ["%1, %2, %3, %4, %5", _cPrimary, _cUgl, _cSecodaries, _cSidearm, _cExplosives];
/***************************************************************************
END
***************************************************************************/