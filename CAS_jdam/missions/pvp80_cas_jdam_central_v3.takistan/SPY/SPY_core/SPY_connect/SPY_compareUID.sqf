/***************************************************************************
COMPARE UID
Created by Spyder
spyder@armalive.com
****************************************************************************/

private ["_player", "_uidSent", "_cConx", "_reqConx", "_checkDelay", "_uidRec"];

_player = (_this select 0);
_uidSent = (_this select 1);

_cConx = 0;
_reqConx = 10;
_checkDelay = 0.1;

while {_cConx != _reqConx} do {

	sleep _checkDelay;
	
	_uidRec = (getPlayerUID _player);

	if ((_uidSent == _uidRec)) then {
	
		_cConx = (_cConx + 1);
		
		// DEBUG
		// _null = [[], "SPY_container globalChat 'CONNECT: UID CONNECTION';", "CLIENT"] spawn CAS_mpCB;

	};

};

sleep (random ((count playableUnits) / 6));

_null = [[], "SPY_CONNECT_SYNC = true;", _uidRec] spawn CAS_mpCB;