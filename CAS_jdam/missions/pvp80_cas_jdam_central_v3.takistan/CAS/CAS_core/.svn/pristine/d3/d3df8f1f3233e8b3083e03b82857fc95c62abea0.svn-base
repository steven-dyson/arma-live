/***************************************************************************
MULTIPLAYER CODE EVENT HANDLER ATOMIC
CREATED BY GOSCHIE, MAHUJA, & SPYDER
STAFF@ARMALIVE.COM
***************************************************************************/

private ["_publicName", "_publicValue", "_scriptArguments", "_scriptEx", "_machineType"];

"CAS_PUBLIC_EX_ATOMIC" addPublicVariableEventHandler {
	
	_publicName = (_this select 0);
	_publicValue = (_this select 1);
	
	_scriptArguments = (_publicValue select 0);
	_scriptEx = (_publicValue select 1);
	_machineType = (_publicValue select 2);
	
	switch (_machineType) do {
		
		case "SERVER": {
			
			if (isServer) then {
				
				_scriptArguments call (compile _scriptEx);
				
			};
			
		};
		
		case "CLIENT": {
			
			if (!isDedicated) then {
				
				_scriptArguments call (compile _scriptEx);
				
			};
			
		};
		
		case "ALL": {
			
			_scriptArguments call (compile _scriptEx);
			
		};
		
		default {
			
			if (((typeName _machineType) == "STRING")) then {
				
				if (!(isDedicated) && (_machineType == (getPlayerUID player))) then {

					_scriptArguments call (compile _scriptEx);

				};
				
			} else {
			
				if (!(isDedicated) && (_machineType == playerSide)) then {

					_scriptArguments call (compile _scriptEx);

				};
			
			};
			
		};
		
	};
	
};