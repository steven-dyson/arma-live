/***************************************************************************
MULTIPLAYER CODE BROADCAST ATOMIC
CREATED BY GOSCHIE, MAHUJA, & SPYDER
STAFF@ARMALIVE.COM
***************************************************************************/

private ["_scriptArguments", "_scriptEx", "_machineType"];

_temp = + _this;

waitUntil {CAS_PUBLIC_EX_ATOMIC = + _temp; publicVariable "CAS_PUBLIC_EX_ATOMIC"; true};
	
_scriptArguments = (_this select 0);
_scriptEx = (_this select 1);
_machineType = (_this select 2);

switch (_machineType) do {
	
	case "SERVER": {
		
		if ((isServer)) then {
			
			waitUntil {_scriptArguments call (compile _scriptEx); true;};
			
		};
		
	};
	
	case "CLIENT": {
		
		if (!(isDedicated)) then {
			
			waitUntil { _scriptArguments call (compile _scriptEx); true;};
			
		};
		
	};
		
	case "ALL": {
		
		waitUntil {_scriptArguments call (compile _scriptEx); true;};
		
	};
	
	default {
			
		if (((typeName _machineType) == "STRING")) then {
					
			if ((!isDedicated) && (_machineType == (getPlayerUID player))) then {

				waitUntil {_scriptArguments call (compile _scriptEx); true;};

			};
			
		} else {
		
			if ((!isDedicated) && (_machineType == playerSide)) then {

				waitUntil {_scriptArguments call (compile _scriptEx); true;};

			};
		
		};
		
	};
	
};