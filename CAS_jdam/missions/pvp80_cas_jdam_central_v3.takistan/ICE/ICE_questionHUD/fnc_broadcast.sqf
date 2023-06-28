// Desc: wrapper for external broadcast function
//-----------------------------------------------------------------------------
#define __ICE_X_Server 0
#define __ICE_X_Clients -1
#define __ICE_X_ServerClients -2
#define __ICE_X_Invalid -3

#define _c_scriptName "ICE_questionHUD_broadcast"

ICE_questionHUD_broadcast =
{
	if (isNil "ICE_fnc_broadcast") then
	{
		if (isNil "CBA_fnc_globalExecute") then
		{
			diag_log format ["%1: Error: ICE_fnc_broadcast is nil & CBA_fnc_globalExecute is nil", _c_scriptName];
		}
		else
		{
			private ["_chan"];

			_chan = _this select 0;
			if (typeName _chan == "STRING") then
			{
				if (_chan in ["s", "S"]) exitWith {_chan = __ICE_X_Server};
				if (_chan in ["c", "C"]) exitWith {_chan = __ICE_X_Clients};
				if (_chan in ["cs", "CS", "sc", "SC", ""]) exitWith {_chan = __ICE_X_ServerClients};
				_chan = __ICE_X_Invalid;
				diag_log format ["%1: Error: invalid param: %2", _c_scriptName, _this];
			};

			[_chan, _this select 1, _this select 2] call CBA_fnc_globalExecute;
		};
	}
	else
	{
		_this call ICE_fnc_broadcast
	}
};
