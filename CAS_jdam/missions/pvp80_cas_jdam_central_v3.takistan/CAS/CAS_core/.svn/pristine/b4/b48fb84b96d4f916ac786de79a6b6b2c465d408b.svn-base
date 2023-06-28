/***************************************************************************
MULTIPLAYER CODE BROADCAST
CREATED BY GOSCHIE, MAHUJA, & SPYDER
STAFF@ARMALIVE.COM
***************************************************************************/

private ["_scriptArguments", "_scriptEx", "_machineType"];

_temp = + _this;

waitUntil {CAS_PUBLIC_EX = + _temp; publicVariable "CAS_PUBLIC_EX"; true};

switch (true) do {
	
	case (((_this select 2) in ["SERVER"]) && (isServer)): {
		
		_null = _this spawn {

			_scriptArguments = (_this select 0);
			_scriptEx = (_this select 1);

			_null = _scriptArguments spawn (compile _scriptEx);

		};
	
	};
	
	case (((_this select 2) in ["CLIENT"]) && (!isDedicated)): {
	
		_null = _this spawn {

			_scriptArguments = (_this select 0);
			_scriptEx = (_this select 1);

			_null = _scriptArguments spawn (compile _scriptEx);
		
		};
	
	};
	
	case (((_this select 2) in [(getPlayerUID player)]) && (!isDedicated)): {
	
		_null = _this spawn {

			_scriptArguments = (_this select 0);
			_scriptEx = (_this select 1);

			_null = _scriptArguments spawn (compile _scriptEx);

		};
	
	};
	
	case (((_this select 2) in [playerSide]) && (!isDedicated)): {

		_null = _this spawn {

			_scriptArguments = (_this select 0);
			_scriptEx = (_this select 1);

			_null = _scriptArguments spawn (compile _scriptEx);

		};

	};

	case ((_this select 2) in ["ALL"]): {

		_null = _this spawn {

			_scriptArguments = (_this select 0);
			_scriptEx = (_this select 1);

			_null = _scriptArguments spawn (compile _scriptEx);

		};

	};
	
};