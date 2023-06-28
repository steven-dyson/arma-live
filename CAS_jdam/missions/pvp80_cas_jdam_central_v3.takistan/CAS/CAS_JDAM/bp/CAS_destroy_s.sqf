/***************************************************************************
Destroy Server
Created by Spyder
spyder@armalive.com
***************************************************************************/

scriptName "CAS JDAM BP Destroy Server";

private ["_bp", "_player", "_playerUID", "_detTime", "_sector", "_sideBP", "_bpObjects", "_enemySide", "_valueLostSector", "_animation", "_pos", "_satchel"];

_bp = (_this select 0);
_player = (_this select 1);

// Exit if already destroyed or charge already set
if ((!alive _bp) || (_bp getVariable "CAS_JDAM_chargeSet")) exitWith {};

_playerUID = (_player getVariable "SPY_id_player" select 0);

_detTime = (time + 60);

_sector = (_bp getVariable "CAS_JDAM_sector");
_sideBP = (_bp getVariable "CAS_JDAM_side"); // USE SPY ID
_bpObjects = (_bp getVariable "CAS_JDAM_bpObjects");

if ((_sideBP == WEST)) then {

	_enemySide = EAST;
	_valueLostSector = -1;

} else {
	
	_enemySide = WEST;
	_valueLostSector = 1;

};

// Add variables
_bp setVariable ["CAS_JDAM_chargeSet", true, true];

// Animation
_animation = "(_this select 0) playMove 'amovpercmstpsraswrfldnon_amovpknlmstpslowwrfldnon';";
_null = [[_player], _animation, "CLIENT"] spawn CAS_mpCB;

// Place satchel
_pos = (_bp modelToWorld [0, -0.5, -0.575]);
_satchel = "DemoCharge_Remote_Ammo" createVehicle _pos;
// _null = [[_satchel, ((getDir _bp) - 90), (vectorUp _bp)], "_this spawn CAS_bpDemoSet_c;", "CLIENT"] spawn CAS_mpCB;
_satchel setDir ((getDir _bp) - 90);
_satchel setVectorUp (vectorUp _bp);

// Charge set message
_null = [3, "Charge set, get clear, get clear, 60 seconds!", _playerUID, false] spawn SPY_bMessage;

// Charge set sound
_null = [[(_bpObjects select 1), _bp], "_this spawn CAS_JDAM_bp_playDemoAlarm_c", "CLIENT"] spawn CAS_mpCB;

// Charge disarmed or charge set off
waitUntil {sleep 0.1; !(_bp getVariable "CAS_JDAM_chargeSet") || (time >= _detTime)};

// Charge went off
if ((time >= _detTime)) then {

	private ["_explosion", "_zone", "_sectorList", "varProgressFriendly", "_varProgressEnemy", "_progressFriendly", "_progressEnemy"]; 

	_explosion = "M_AT" createVehicle (getPos _satchel);

	waitUntil {sleep 0.1; isNull _explosion};
	
	CAS_JDAM_tracker setVariable [(format ["%1_bpDeployed", _sector]), "", false];
	
	if ((count (CAS_JDAM_tracker getVariable (format ["%1_grids", _sector])) > 0)) then {

		_zone = (CAS_JDAM_tracker getVariable (format ["%1_zone", _sector]));
		_sectorList = (CAS_JDAM_tracker getVariable (format ["%1_sectorList", _zone]));
		
		_varProgressFriendly = (format ["%1_progress%2", _zone, _sideBP]);
		_varProgressEnemy = (format ["%1_progress%2", _zone, _enemySide]);
		
		_progressFriendly = (CAS_JDAM_tracker getVariable _varProgressFriendly);
		_progressEnemy = (CAS_JDAM_tracker getVariable _varProgressEnemy);
		
		CAS_JDAM_tracker setVariable [_varProgressFriendly, (_progressFriendly + _valueLostSector), false];
		
		_null = [_sector, civilian, false] spawn CAS_JDAM_ownerChangeSector_s;
		_null = [_sector, _zone, west, false] spawn CAS_JDAM_init_grids_s;
		_null = [_sector, _zone, east, true] spawn CAS_JDAM_init_grids_s;
		
		(_sectorList select _progressEnemy) setMarkerBrush "Horizontal";
		
	};

	// Destroy and hide objects
	{
	
		if ((_x != _bp)) then {
		
			deleteVehicle _x;
		
		} else {
		
			_x removeAllEventHandlers "HandleDamage";
			_x setDamage 1;
		
		};

	} forEach _bpObjects;
	
	// _satchel attachTo [(_bpObjects select 2), [0, 0, -5000]];
	deleteVehicle _satchel;
	
	// Side messages
	_null = [3, "Enemy battle position destroyed!", _enemySide, false, 1] spawn SPY_bMessage;
	_null = [3, "Your battle position was destroyed!", _sideBP, false, 1] spawn SPY_bMessage;

// Charge defused
} else {
	
	deleteVehicle _satchel;

};