// Desc: "keyDown" EH
//-----------------------------------------------------------------------------
#include "armaGameVer.sqh"
#include "common.sqh"

private ['_handled', '_control', '_dikCode', '_shiftKey', '_ctrlKey', '_altKey', '_match'];

//_control = _this select 0;
_dikCode = _this select 1; // key
_shiftKey = _this select 2;
_ctrlKey = _this select 3;
_altKey = _this select 4;

_handled = false;

if (!dialog) then
{
	//ICE_sqdMgt_keys array: [[(actionKeys "Compass") select 0, [true, false, false]]] // usually shift+K
	_match = false;
	// scan for matching key/shiftKeys combination
	{
		if (_dikCode == (_x select 0)) then
		{
#define _c_booleansEqual(_var1,_var2) ((!(_var1) && !(_var2)) || ((_var1) && (_var2)))
			private "_shiftKeys";
			_shiftKeys = _x select 1;
			_match = (
				_c_booleansEqual(_shiftKeys select 0, _shiftKey) &&
				_c_booleansEqual(_shiftKeys select 1, _ctrlKey) &&
				_c_booleansEqual(_shiftKeys select 2, _altKey));
		};
	} forEach ICE_sqdMgt_keys;

	if (_match) then
	{
		ICE_sqdMgt_openDlgTime = time;
		[] call compile preprocessFileLineNumbers _c_basePath(custom\showWithOptions.sqf);
		_handled = true;
	};
};

_handled
