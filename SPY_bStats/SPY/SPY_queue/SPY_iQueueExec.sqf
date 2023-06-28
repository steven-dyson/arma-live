/***************************************************************************
INSTANT QUEUE EXECUTE
CREATED BY SPYDER
SPYDER@ARMALIVE.COM
****************************************************************************/

private ["_args", "_script", "_waitTime", "_compiledLine"];

while {true} do {

	waitUntil {count SPY_eMP_I_QUEUE > 0};
	
	_args = ((SPY_eMP_I_QUEUE select 0) select 0);
	_script = ((SPY_eMP_I_QUEUE select 0) select 1);
	_waitTime = ((SPY_eMP_I_QUEUE select 0) select 2);
	
	waitUntil {time > _waitTime};
	
	_compiledLine = compile _script;
	_null = _args spawn _compiledLine;

	SPY_eMP_I_QUEUE set [0, -1];
	SPY_eMP_I_QUEUE = SPY_eMP_I_QUEUE - [-1];
	
};