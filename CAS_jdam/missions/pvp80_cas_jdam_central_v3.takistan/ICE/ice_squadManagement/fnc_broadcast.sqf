// Desc: wrapper for external broadcast function
//-----------------------------------------------------------------------------
#define __ICE_X_Server 0
#define __ICE_X_Clients -1
#define __ICE_X_ServerClients -2
#define __ICE_X_Invalid -3

#define _c_scriptName "ICE_sqdMgt_broadcast"

ICE_sqdMgt_broadcast =
{
	if (isNil "ICE_fnc_broadcast") then
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

		if (isNil "CBA_fnc_globalExecute") then
		{
			diag_log format ["%1: Error: ICE_fnc_broadcast is nil & CBA_fnc_globalExecute is nil", _c_scriptName];
			player groupChat format ["%1: Error: CBA_fnc_globalExecute is missing.", _c_scriptName];
			
			if (typeName (_this select 1) == "CODE") then
			{
				if ((_chan in [__ICE_X_Server, __ICE_X_ServerClients] && isServer) ||
						(_chan in [__ICE_X_Clients, __ICE_X_ServerClients] && !isDedicated && !isServer)) then
				{
					(_this select 2) call (_this select 1);
				};
			};
			
			/*
			if (isNil "RE") then {diag_log "sqdMgt: Error: RE is nil"};
			if (isNil "bis_fnc_init") then {diag_log "sqdMgt: Error: bis_fnc_init is nil"};

			/ *
			if (_this select 0 == "c") then
			{
				str (format ["if (!isServer) then {%1}", _this select 1])
				Is uncompiled code in string syntax supported by rCallVar?
			}
			else // "cs"
			{
			};
			* /
			// assume "cs"
			[nil, nil, rCallVar, _this select 2, str (_this select 1)] call RE;
			*/
		}
		else
		{
			[_chan, _this select 1, _this select 2] call CBA_fnc_globalExecute;
		};
	}
	else
	{
		_this call ICE_fnc_broadcast
	}
};
