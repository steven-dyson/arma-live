/***************************************************************************
EXIT TUNNEL
CREATED BY SPYDER
SPYDER001@COMCAST.NET
****************************************************************************/

_player = (_this select 1);
_args = (_this select 3);

_entranceObject = (_args select 0);

if ((alive _entranceObject)) then {

	_pTime = (_player getVariable "CAS_STUNNEL_INFO" select 1);
	_pH = (_pTime select 0);
	_pM = (_pTime select 1);
	_pT = (_pTime select 2);
	
	_eH = (floor ((time - _pT) / 360));
	_eM = (floor ((time - (_pT - (_eH / 360))) / 60));
	
	_nH = (_pH + _eH);
	_nM = (_pM + _eM);
	
	player sideChat format ["H: %1 - %2 = %3", _pH, _eH, _nH];
	player sideChat format ["M: %1 - %2 = %3", _pM, _eM, _nM];
	
	setDate [(date select 0), (date select 1), (date select 2), _nH, _nM];

	_player setPosASL (getPosASL _entranceObject);
	
	_player setVariable ["CAS_STUNNEL_INFO", [false, []], true];
	
} else {

	_player sideChat "TUNNEL ENTRANCE DESTROYED";

};