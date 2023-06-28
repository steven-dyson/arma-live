private "_unit";
private "_UID";
private "_wait";
private "_crate";

_unit = _this select 0;
_UID = _this select 1;
_crate = _this select 2;

_null = ((format ["CONNECT : %1", _UID]) createVehicleLocal [0,0,0]);
_wait = 1;
	
while {_wait == 1} do
{
	waitUntil {_UID != (getPlayerUID _unit)};
	_wait = 0;
	{
		if (_UID == (getPlayerUID _x)) then
		{
			_unit = _x;
			_wait = 1;
		};
	} foreach playableUnits;
		
	if (_wait == 0) then
	{
		JDAM_SERVER_KIT_QUEUE set [(count JDAM_SERVER_KIT_QUEUE), [[_crate, _UID], 2]];
	};
};