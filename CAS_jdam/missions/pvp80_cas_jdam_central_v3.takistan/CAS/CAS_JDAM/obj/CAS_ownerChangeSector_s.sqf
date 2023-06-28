/***************************************************************************
Owner Change Sector Server
Created by Spyder
spyder@armalive.com
***************************************************************************/

scriptName "OWNER CHANGE SECTOR SERVER";

_sector = (_this select 0);
_sideNew = (_this select 1);
_isActiveSector = (_this select 2);

_grids = (CAS_JDAM_tracker getVariable (format ["%1_grids", _sector]));

CAS_JDAM_tracker setVariable [(format ["%1_owner", _sector]), _sideNew, false];

{

	CAS_JDAM_tracker setVariable [(format ["%1_owner", _x]), _sideNew, false];

} forEach _grids;

switch (_sideNew) do {

	case west: {
	
		_sector setMarkerColor "ColorBLUFOR";
		
		if ((_isActiveSector)) then {
		
			_sector setMarkerBrush "Solid";
		
		} else {
		
			_sector setMarkerBrush "Horizontal";
		
		};
	
	};
	
	case east: {
	
		_sector setMarkerColor "ColorOPFOR";
		
		if ((_isActiveSector)) then {
		
			_sector setMarkerBrush "Solid";
		
		};
	
	};
	
	case civilian: {
	
		_sector setMarkerColor "ColorBlack";
		_sector setMarkerBrush "Border";
	
	};
	
};