"JDAM_PUBLIC_EX" addPublicVariableEventHandler
{
	private "_publicName";
	private "_publicValue";
	
	_publicName = _this select 0;
	_publicValue = _this select 1;
	
	_null = switch ((_publicValue select 2)) do
	{
		case "SERVER": 
		{
			_null = _publicValue spawn
			{
				private "_scriptArguments";
				private "_scriptEx";
				private "_machineType";
				private "_compiledLine";
				_scriptArguments = _this select 0;
				_scriptEx = _this select 1;
				_machineType = _this select 2;
				
				if (isServer) then
				{
					_compiledLine = compile _scriptEx;
					_null = _scriptArguments spawn _compiledLine;
				};
			};
		};
		
		case "CLIENT":
		{
			_null = _publicValue spawn
			{
				private "_scriptArguments";
				private "_scriptEx";
				private "_machineType";
				private "_compiledLine";
				_scriptArguments = _this select 0;
				_scriptEx = _this select 1;
				_machineType = _this select 2;
				
				if (!isDedicated) then
				{
					_compiledLine = compile _scriptEx;
					_null = _scriptArguments spawn _compiledLine;
				};
			};
		};
		
		case "ALL":
		{
			_null = _publicValue spawn
			{
				private "_scriptArguments";
				private "_scriptEx";
				private "_machineType";
				private "_compiledLine";
				_scriptArguments = _this select 0;
				_scriptEx = _this select 1;
				_machineType = _this select 2;
				
				_compiledLine = compile _scriptEx;
				_null = _scriptArguments spawn _compiledLine;
			};
		};
		
		default
		{
			_null = _publicValue spawn
			{
				private "_scriptArguments";
				private "_scriptEx";
				private "_machineType";
				private "_compiledLine";
				_scriptArguments = _this select 0;
				_scriptEx = _this select 1;
				_machineType = _this select 2;
				
				if (!isDedicated) then
				{
					if (_machineType == (getPlayerUID player)) then
					{
						_compiledLine = compile _scriptEx;
						_null = _scriptArguments spawn _compiledLine;
					};
				};
			};
		};
	};
	
};