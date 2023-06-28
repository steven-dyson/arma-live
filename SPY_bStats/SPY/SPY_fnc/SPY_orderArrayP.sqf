/***************************************************************************
ORDER ARRAY OF PLAYERS
CREATED BY SPYDER
SPYDER@ARMALIVE.COM

_ARRAY: ARRAY OF PLAYERS TO BE ORDERED
_OBJECT: OBJECT TO RETRIEVE VARIABLE FROM
_INDEX: INDEX OF VARIABLE TO CHECK
_ORDER: 1 = LOW TO HIGH, 2 = HIGH TO LOW
****************************************************************************/

private ["_array", "_object", "_index", "_order", "_indexTotal", "_y", "_z", "_playerYVarName", "_playerZVarName","_j", "_k", "_a", "_b"];

_array = (_this select 0);
_object = (_this select 1);
_index = (_this select 2);
_order = (_this select 3);

_indexTotal = ((count _array) - 1);
_y = 0;
_z = 1;

if ((_indexTotal <= 0)) exitWith {_array};

for "_i" from 1 to (_indexTotal * _indexTotal) do {
	
	_playerYVarName = (format ["SPY_bStats_%1", (getPlayerUID (_array select _y))]);
	_playerZVarName = (format ["SPY_bStats_%1", (getPlayerUID (_array select _z))]);
	_j = (_object getVariable _playerYVarName select _index);
	_k = (_object getVariable _playerZVarName select _index);
	
	if ((isNil "_j")) then {_j = 0};
	if ((isNil "_k")) then {_k = 0};
	
	if ((_j > _k) && (_order == 1)) then {
		
		_a = (_array select _y);
		_b = (_array select _z);
		
		_array set [_y, _b];
		_array set [_z, _a];

	};
	
	if ((_j < _k) && (_order == 2)) then {
		
		_a = (_array select _y);
		_b = (_array select _z);
		
		_array set [_y, _b];
		_array set [_z, _a];

	};
		
	if ((_z == _indexTotal)) then {
		
		_y = 0;
		_z = 1;
		
	} else {
	
		_y = (_y + 1);
		_z = (_z + 1);
	
	};

};

_array