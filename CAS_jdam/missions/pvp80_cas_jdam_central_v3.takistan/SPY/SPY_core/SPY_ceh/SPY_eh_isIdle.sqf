private ["_idleTimer", "_oDir", "_nDir"];

_unit = (_this select 0);

_idle = false;
_idleTimer = 0;

while {sleep 0.1; (!isNil {direction player}) and !(_idle)} do
{
	if ((vehicle player isEqualTo player)) then
	{
		_oDir = direction player;
	}
	else
	{
		if (((assignedVehicleRole player select 0) isEqualTo "Turret")) then
		{
			_oDir = ((vehicle player weaponDirection currentMuzzle player) select 0);
		}
		else
		{
			_oDir = (eyeDirection player select 0);
		};
	};
	
	_oPosX = (getPos vehicle player select 0);
	_oPosY = (getPos vehicle player select 1);

	sleep 1;

	if (((vehicle player) isEqualTo player)) then
	{
		_nDir = (direction player);
	}
	else
	{
		if (((assignedVehicleRole player select 0) isEqualTo "Turret")) then
		{
			_nDir = ((vehicle player weaponDirection currentMuzzle player) select 0);
		}
		else
		{
			_nDir = (eyeDirection player select 0);
		};
	};
	
	_nPosX = (getPos vehicle player select 0);
	_nPosY = (getPos vehicle player select 1);
	
	if ((_oDir isEqualTo _nDir) and (_oPosX isEqualTo _nPosX) and (_oPosY isEqualTo _nPosY)) then
	{
		if ((_idleTimer isEqualTo 0)) then
		{
			_idleTimer = time + SPY_connect_idleKickTime;
		};
	
		if ((time > _idleTimer) and (_idleTimer > 0)) then
		{
			_idle = true;
			
			// Execute CEH of type
			_null = [[player], "SPY_ceh_isIdle"] spawn SPY_core_fnc_cehExec;
		};
	}
	else
	{
		_idleTimer = 0;
	};
};