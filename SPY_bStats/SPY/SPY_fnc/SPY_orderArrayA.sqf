/***************************************************************************
ORDER ARRAY OF ARRAYS
CREATED BY SPYDER
SPYDER@ARMALIVE.COM

_ARRAY: ARRAY OF ARRAYS TO BE ORDERED
_ORDER: 1 = LOW TO HIGH 2 = HIGH TO LOW
_INDEX: INDEX OF VALUE INSIDE ARRAY TO BE USED
****************************************************************************/

private ["_array", "_order", "_index", "_indexTotal", "_y", "_z", "_a", "_b"];

_array = (_this select 0);
_order = (_this select 1);
_index = (_this select 2);

_indexTotal = ((count _array) - 1);
_y = 0;
_z = 1;

for "_i" from 1 to (_indexTotal * _indexTotal) do {

	if (((_array select _y) select _index) > ((_array select _z) select _index) && (_order == 1)) then {
		
		_a = (_array select _y);
		_b = (_array select _z);
		
		_array set [_y, _b];
		_array set [_z, _a];

	};
	
	if (((_array select _y) select _index) < ((_array select _z) select _index) && (_order == 2)) then {
		
		_a = (_array select _y);
		_b = (_array select _z);
		
		_array set [_y, _b];
		_array set [_z, _a];

	};
		
	_y = (_y + 1);
	_z = (_z + 1);
		
	if ((_y == _indexTotal)) then {
		
		_y = 0;
		_z = 1;
		
	};

};

_array