/***************************************************************************
INSTANT QUEUE EXECUTE
Created by Spyder
spyder@armalive.com
****************************************************************************/

private ["_args", "_script", "_timeout", "_compiledLine", "_code"];

while {true} do {

	waitUntil {sleep 0.1; (count SPY_queue_instant > 0)};
	
	_args = ((SPY_queue_instant select 0) select 0);
	_script = ((SPY_queue_instant select 0) select 1);
	
	_timeout = (time + 5);
	
	_compiledLine = compile _script;
	_code = _args spawn _compiledLine;
	
	SPY_queue_instant set [0, -1];
	SPY_queue_instant = SPY_queue_instant - [-1];
	
	waitUntil {sleep 0.1; (scriptDone _code) || (time > _timeOut)};
	
};