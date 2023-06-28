/***************************************************************************
DELAY QUEUE EXECUTE
Created by Spyder
spyder@armalive.com
****************************************************************************/

private ["_args", "_script", "_execTime", "_timeout", "_compiledLine"];

while {true} do {

	waitUntil {sleep 0.1; (count SPY_queue_delay > 0)};

	_args = ((SPY_queue_delay select 0) select 0);
	_script = ((SPY_queue_delay select 0) select 1);
	_execTime = ((SPY_queue_delay select 0) select 2);
	
	_timeout = (time + 5);
	
	waitUntil {sleep 0.1; (time >= _execTime)};

	_compiledLine = compile _script;
	_code = _args spawn _compiledLine;

	SPY_queue_delay set [0, -1];
	SPY_queue_delay = SPY_queue_delay - [-1];
	
	waitUntil {sleep 0.1; (scriptDone _code) || (time > _timeOut)};
	
};