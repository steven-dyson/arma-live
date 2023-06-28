"JDAM_PUBLIC_EX_ATOMIC" addPublicVariableEventHandler
{
	private "_publicName";
	private "_publicValue";
	private "_scriptArguments";
	private "_scriptEx";
	private "_machineType";
	
	_publicName = _this select 0;
	_publicValue = _this select 1;
	
	_scriptArguments = _publicValue select 0;
	_scriptEx = _publicValue select 1;
	_machineType = _publicValue select 2;
	
	_null = switch (_machineType) do
	{
		case "SERVER": 
		{
			if (isServer) then
			{
				_scriptArguments call compile _scriptEx;
			};
		};
		
		case "CLIENT":
		{
			if (!isDedicated) then
			{
				_scriptArguments call compile _scriptEx;
			};
		};
		
		case "ALL":
		{	
			_scriptArguments call compile _scriptEx;
		};
		
		default
		{
			if (!isDedicated) then
			{
				if (_machineType == (getPlayerUID player)) then
				{
					_scriptArguments call compile _scriptEx;
				};
			};
		};
	};
	
};