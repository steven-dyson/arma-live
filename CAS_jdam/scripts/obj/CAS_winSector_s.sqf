/***************************************************************************
WIN SECTOR SERVER
Created by Spyder
spyder@armalive.com
***************************************************************************/

private ["_zone", "_sector", "_side", "_enemySide", "_markerColor", "_markerLocChangeFriendly", "_MarkerLocChangeEnemy", "_valueWinSector", "_valueLostSector", "_sectorList", "_sectorGrids", "_ownedGridsFriendly", "_varProgressFriendly", "_varProgressEnemy", "_progressFriendly", "_progressEnemy"];

/*
_null = [] spawn {{player setPos (getMarkerPos "CAS_JDAM_ao1_z1_g1_west"); sleep 3; player setPos (getMarkerPos "CAS_JDAM_ao1_z1_g2_west"); sleep 3; player setPos (getMarkerPos "CAS_JDAM_ao1_z1_g3_west");sleep 3;} forEach [1, 2, 3];};
_null = [] spawn {{player setPos (getMarkerPos "CAS_JDAM_ao1_z1_g1_east"); sleep 3; player setPos (getMarkerPos "CAS_JDAM_ao1_z1_g4_east"); sleep 3; player setPos (getMarkerPos "CAS_JDAM_ao1_z1_g3_east");sleep 3;} forEach [1];};
*/

_zone = (_this select 0);
_sector = (_this select 1);
_side = (_this select 2);

if ((_side == WEST)) then {

	_enemySide = EAST;
	_markerColor = "ColorBLUFOR";
	_valueWinSector = 1;
	_valueLostSector = -1;

} else {
	
	_enemySide = WEST;
	_markerColor = "ColorOPFOR";
	_valueWinSector = -1;
	_valueLostSector = 1;

};

_sectorList = (CAS_JDAM_tracker getVariable (format ["%1_sectorList", _zone]));
_sectorGrids = (CAS_JDAM_tracker getVariable (format ["%1_grids", _sector]));

_ownedGridsFriendly = 0;

_varProgressFriendly = (format ["%1_progress%2", _zone, _side]);
_varProgressEnemy = (format ["%1_progress%2", _zone, _enemySide]);

_progressFriendly = (CAS_JDAM_tracker getVariable _varProgressFriendly);
_progressEnemy = (CAS_JDAM_tracker getVariable _varProgressEnemy);

{
	
	if ((CAS_JDAM_tracker getVariable format ["%1_owner", _x]) == _side) then {
			
		_ownedGridsFriendly = (_ownedGridsFriendly + 1);
		
		// DEBUG
		player sideChat format ["ADD GRID %1, %2", _ownedGridsFriendly, _x];

		if ((_ownedGridsFriendly > 2)) exitWith {
		
			_null = [3, "You took a sector. Deploy your battle position.", _side, false] spawn SPY_bMessage;
			_null = [3, "You lost a sector!", _enemySide, false] spawn SPY_bMessage;

			_progressFriendly = (_progressFriendly + _valueWinSector);
			
			// SET VARIABLES
			CAS_JDAM_tracker setVariable [(format ["%1_owner", _sector]), _side, false];
			CAS_JDAM_tracker setVariable [_varProgressFriendly, _progressFriendly, false];
			CAS_JDAM_tracker setVariable [(format ["%1_westPlayers", _x]), [], false];
			CAS_JDAM_tracker setVariable [(format ["%1_eastPlayers", _x]), [], false];

			// DEBUG
			player sideChat format ["WIN SECTOR %1 - %2", _progressFriendly, _progressEnemy];

			// SET MARKER BASIC
			_sector setMarkerColor _markerColor;
			_sector setMarkerBrush "Solid";
			
			// COME BACK
			if ((_progressFriendly in [-1, 5])) exitWith {

				_progressEnemy = (_progressEnemy + _valueWinSector);
				CAS_JDAM_tracker setVariable [_varProgressEnemy, _progressEnemy, false];
					
				_null = [(_sectorList select _progressFriendly), _zone, _side, false] spawn CAS_JDAM_init_grids_s;
				_null = [(_sectorList select _progressEnemy), _zone, _enemySide, false] spawn CAS_JDAM_init_grids_s;
			
			};

			// TOOK FINAL ENEMY SECTOR
			if ((((_progressEnemy == _progressFriendly) || (_progressEnemy == (_progressFriendly + _valueWinSector))) && (_progressEnemy in [-1, 0, 4, 5]))) exitWith {

				_null = [(_sectorList select _progressFriendly), _zone, _side, false] spawn CAS_JDAM_init_grids_s;
				_null = [(_sectorList select _progressEnemy), _zone, _enemySide, true] spawn CAS_JDAM_init_grids_s;
				
				(_sectorList select (_progressFriendly + _valueLostSector)) setMarkerBrush "Horizontal";
				CAS_JDAM_tracker setVariable [(format ["%1_grids", (_sectorList select (_progressFriendly + _valueLostSector))]), [], false];
				
				_progressEnemy = (_progressEnemy + _valueWinSector);
				CAS_JDAM_tracker setVariable [_varProgressEnemy, _progressEnemy, false];

			};
			
			// MET ENEMY SECTOR FOR FIRST TIME
			if ((_progressEnemy == (_progressFriendly + _valueWinSector) && !(_progressEnemy in [-1, 5])) || ((_progressFriendly + (_valueWinSector * 2) == _progressEnemy) && (_progressEnemy in [-1, 5]))) exitWith {

				if ((_side == EAST)) then {
				
					_null = [_sector, _zone, _side, false] spawn CAS_JDAM_init_grids_s;
				
				};
				
				_null = [(_sectorList select _progressEnemy), _zone, _enemySide, false] spawn CAS_JDAM_init_grids_s;
				(_sectorList select _progressEnemy) setMarkerBrush "Solid";

			};

			// PUSHED ENEMY SECTOR BACK
			if (_progressEnemy == _progressFriendly) exitWith {

				_progressEnemy = (_progressEnemy + _valueWinSector);
				CAS_JDAM_tracker setVariable [_varProgressEnemy, _progressEnemy, false];

				_null = [(_sectorList select _progressFriendly), _zone, _side, false] spawn CAS_JDAM_init_grids_s;
				_null = [(_sectorList select _progressEnemy), _zone, _enemySide, false] spawn CAS_JDAM_init_grids_s;
				
				(_sectorList select (_progressFriendly + _valueLostSector)) setMarkerBrush "Horizontal";
				(_sectorList select _progressEnemy) setMarkerBrush "Solid";
				
				CAS_JDAM_tracker setVariable [(format ["%1_grids", (_sectorList select (_progressFriendly + _valueLostSector))]), [], false];

			};				
			
		};
		
	};

} forEach _sectorGrids;