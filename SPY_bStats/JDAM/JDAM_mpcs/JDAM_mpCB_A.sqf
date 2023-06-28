_temp = + _this;
waitUntil
{
	JDAM_PUBLIC_EX_ATOMIC = + _temp;
	publicVariable "JDAM_PUBLIC_EX_ATOMIC";
	true
};

private "_scriptArguments";
private "_scriptEx";
private "_machineType";
	
_scriptArguments = _this select 0;
_scriptEx = _this select 1;
_machineType = _this select 2;

_null = switch (_machineType) do
{
	case "SERVER": 
	{
		if (isServer) then
		{
			waitUntil
			{
				_scriptArguments call compile _scriptEx;
				true;
			};
		};
	};
	
	case "CLIENT":
	{
		if (!isDedicated) then
		{
			waitUntil
			{
				_scriptArguments call compile _scriptEx;
				true;
			};
		};
	};
		
	case "ALL":
	{	
		waitUntil
		{
			_scriptArguments call compile _scriptEx;
			true;
		};
	};
	
	default
	{
		if (!isDedicated) then
		{
			if (_machineType == (getPlayerUID player)) then
			{
				waitUntil
				{
					_scriptArguments call compile _scriptEx;
					true;
				};
			};
		};
	};
};