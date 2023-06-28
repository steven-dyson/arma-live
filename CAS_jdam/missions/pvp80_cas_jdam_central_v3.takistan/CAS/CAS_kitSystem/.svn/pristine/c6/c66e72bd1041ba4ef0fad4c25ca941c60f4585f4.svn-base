private "_kitName";
private "_side";
private "_comDelay";

_kitName = _this select 0;
_comDelay = 5;

_side = playerSide;

while {_kitName == ((call PLAYER_KIT) select 6)} do
{
	if (_kitName != ((call PLAYER_KIT) select 6)) exitWith {};
	_markerList = [];
	_index = 0;
	{
		waitUntil {true};
		if ((player != _x) && ((group player) != (group _x)) && (_side == (side _x)) && (alive _x)) then
		{
			_marker = createMarkerLocal [format["COMMUNICATOR%1UNIT_POSITION_MARKER", _index], getPosASL _x];
			_marker setMarkerShapeLocal "ICON";
			_marker setMarkerTypeLocal "Arrow";
			_marker setMarkerColorLocal "ColorBlue";
			_marker setMarkerSizeLocal [0.5, 0.5];
			_marker setMarkerDirLocal (getDir (vehicle _x));
			if ((leader _x) == _x) then
			{
				_marker setMarkerTextLocal format ["%1(LEADER)", (name _x)];
			}
			else
			{
				_marker setMarkerTextLocal (name _x);
			};
			_markerList = _markerList + [_marker];
			_index = _index + 1;
		};
		if (_kitName != ((call PLAYER_KIT) select 6)) exitWith {};
	} foreach AllUnits;
	
	if (_kitName == ((call PLAYER_KIT) select 6)) then
	{
		_delay = (time + _comDelay);
		waitUntil {(time > _delay) || (_kitName != ((call PLAYER_KIT) select 6))};
	};
	
	{
		deleteMarkerLocal _x;
	} foreach _markerList;
};