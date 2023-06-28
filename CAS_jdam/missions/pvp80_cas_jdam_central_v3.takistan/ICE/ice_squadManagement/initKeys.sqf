// Squad Management
// Desc: init keys
//-----------------------------------------------------------------------------
#include "armaGameVer.sqh"
#include "defineDIKCodes.sqh"
#include "keyHandlerMacros.sqh"
#include "common.sqh"
//-----------------------------------------------------------------------------
// Validate keys array for correct types. The keys variable can be an empty array. Syntax [[dikCode, [shift,ctrl,alt]], ...]
_valid = !isNil "ICE_sqdMgt_keys";
if (_valid) then
{
	// perform type validations. Array must be nested and complete.
	_valid = (typeName ICE_sqdMgt_keys == typeName []);
	if (_valid) then
	{
		{
			_valid = (typeName _x == typeName []);
			if (_valid) then
			{
				_valid = 
					(typeName (_x select 0) == typeName 5) &&
					(typeName (_x select 1) == typeName []);
			};
			if (!_valid) exitWith {};
		} forEach ICE_sqdMgt_keys;
	};
};

// if invalid array or nil key specified, then provide a default. Empty array is valid for 'no keys'.
if (!_valid) then
{
	if (!isNil "ICE_sqdMgt_keys") then
	{
		diag_log format ["SqdMgt: Error: ICE_sqdMgt_keys is invalid: %1", ICE_sqdMgt_keys];
	};

	if (count actionKeys "Compass" > 0) then
	{
		ICE_sqdMgt_keys = [[(actionKeys "Compass") select 0, [true, false, false]]]; // usually shift+K
	}
	else
	{
		ICE_sqdMgt_keys = [[DIK_K, [true, false, false]]]; // shift+K
	};
};

// If defined, set up key EH to activate dialog directly.
if (count ICE_sqdMgt_keys > 0) then
{
	ICE_c_addKeyDownEH(_null,"_this call ICE_sqdMgt_keyDown");
};

player addAction ["Squad Management", "\ice\ice_squadManagement\custom\showWithOptions.sqf", [], -1, false, true, "", "inputAction 'LookAround' != 0"];
// re-add action after each respawn
player addEventHandler ["respawn", {
	player addAction ["Squad Management", "\ice\ice_squadManagement\custom\showWithOptions.sqf", [], -1, false, true, "", "inputAction 'LookAround' != 0"];
}];
