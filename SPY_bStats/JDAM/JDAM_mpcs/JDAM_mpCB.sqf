_temp = + _this;
waitUntil
{
	JDAM_PUBLIC_EX = + _temp;
	publicVariable "JDAM_PUBLIC_EX";
	true
};

if(isServer && ((_this select 2) == "SERVER")) then
{
	_null = _this spawn
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

if ((_this select 2) == (getPlayerUID player)) then
{
	_null = _this spawn
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

if (!isDedicated && ((_this select 2) == "CLIENT")) then
{
	_null = _this spawn
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

if ((_this select 2) == "ALL") then
{
	_null = _this spawn
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