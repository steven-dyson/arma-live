/***************************************************************************
MULTIPLAYER CODE EVENT HANDLER
CREATED BY GOSCHIE, MAHUJA, & SPYDER
STAFF@ARMALIVE.COM
***************************************************************************/

private ["_publicName", "_publicValue", "_scriptArguments", "_scriptEx", "_machineType"];

"CAS_PUBLIC_EX" addPublicVariableEventHandler {
	
	_publicName = (_this select 0);
	_publicValue = (_this select 1);
	
	switch (true) do {
		
		case (((_publicValue select 2) in ["SERVER"]) && (isServer)): {
			
			_null = _publicValue spawn {
			
				_scriptArguments = (_this select 0);
				_scriptEx = (_this select 1);
					
				_null = _scriptArguments spawn (compile _scriptEx);
				
			};
			
		};
		
		case (((_publicValue select 2) in ["CLIENT"]) && (!isDedicated)): {
			
			_null = _publicValue spawn {

				_scriptArguments = (_this select 0);
				_scriptEx = (_this select 1);
				
				_null = _scriptArguments spawn (compile _scriptEx);
				
			};
			
		};
		
		case (((_publicValue select 2) in [(getPlayerUID player)]) && (!isDedicated)): {
			
			_null = _publicValue spawn {

				_scriptArguments = (_this select 0);
				_scriptEx = (_this select 1);
				
				_null = _scriptArguments spawn (compile _scriptEx);
				
			};
			
		};
		
		case (((_publicValue select 2) in [playerSide]) && (!isDedicated)): {
			
			_null = _publicValue spawn {

				_scriptArguments = (_this select 0);
				_scriptEx = (_this select 1);
				
				_null = _scriptArguments spawn (compile _scriptEx);
				
			};
			
		};
		
		case (((_publicValue select 2) in ["ALL"])): {
			
			_null = _publicValue spawn {

				_scriptArguments = (_this select 0);
				_scriptEx = (_this select 1);
				
				_null = _scriptArguments spawn (compile _scriptEx);
				
			};
			
		};
		
	};
	
};