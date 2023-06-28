/***************************************************************************
CHANGED MARKER RELATION SERVER
Created by Spyder
spyder@armalive.com
***************************************************************************/

scriptName "SPY ON CHANGE GRID STATUS SERVER";

private ["_grid", "_player", "_side", "_add", "_enemySide", "_valueWinSector", "_valueLostSector", "_sector", "_zone", "_bpDeployed", "_ownerGrid", "_ownerSector", "_currentEnemyPlayers"];

_grid = (_this select 0);
_player = (_this select 1);
_side = (_this select 2);
_add = (_this select 3);

if ((_side == WEST)) then {

	_enemySide = EAST;
	_valueWinSector = 1;
	_valueLostSector = -1;

} else {
	
	_enemySide = WEST;
	_valueWinSector = -1;
	_valueLostSector = 1;

};

_sector = (CAS_JDAM_tracker getVariable (format ["%1_sector", _grid]));
_zone = (CAS_JDAM_tracker getVariable (format ["%1_zone", _sector]));
_sectorList = (CAS_JDAM_tracker getVariable (format ["%1_sectorList", _zone]));

_varProgressFriendly = (format ["%1_progress%2", _zone, _side]);
_progressFriendly = (CAS_JDAM_tracker getVariable _varProgressFriendly);

_bpDeployed = (CAS_JDAM_tracker getVariable format ["%1_bpDeployed", _sector]);
_bpDeployedPrv = (CAS_JDAM_tracker getVariable format ["%1_bpDeployed", (_sectorList select _progressFriendly)]);

_ownerGrid = (CAS_JDAM_tracker getVariable (format ["%1_owner", _grid]));
_ownerSector = (CAS_JDAM_tracker getVariable (format ["%1_owner", _sector]));

_currentEnemyPlayers = (CAS_JDAM_tracker getVariable (format ["%1_%2Players", _grid, _enemySide]));

// DEBUG
player sideChat format ["IN GRID %1 (%2) (%3)", _grid, (_sectorList select (_progressFriendly)), _bpDeployedPrv];

if ((_add)) then {

	CAS_JDAM_tracker setVariable [(format ["%1_%2players", _grid, _side]), ((CAS_JDAM_tracker getVariable (format ["%1_%2players", _grid, _side])) + [_player]), false];

	if (((count _currentEnemyPlayers) == 0) && (_side != _ownerGrid) && (_side != _ownerSector) && (_bpDeployed == "") && (_bpDeployedPrv != "")) then {

		CAS_JDAM_tracker setVariable [format ["%1_owner", _grid], _side, false];
		
		_null = [_zone, _sector, _side] spawn CAS_obj_winSector_s;

	};

} else {

	CAS_JDAM_tracker setVariable [(format ["%1_%2players", _grid, _side]), ((CAS_JDAM_tracker getVariable (format ["%1_%2players", _grid, _side])) - [_player]), false];
	
	// %NOTE SET OWNER TO NEUTRAL OR ENEMY, NAME SCRIPT CHECK SECTOR LOSS

};

