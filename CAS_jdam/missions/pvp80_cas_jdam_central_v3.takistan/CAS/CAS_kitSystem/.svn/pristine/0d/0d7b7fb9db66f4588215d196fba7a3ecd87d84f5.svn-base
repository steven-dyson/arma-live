private "_executeState";

_executeState = JDAM_CLIENT_KIT_QUEUE select 0;
switch (_executeState select 1) do
{
	case _FILL_KIT:
	{
		(_executeState select 0) call PlayerKits_FillKit;
	};
	
	default
	{
		player sideChat "INVALID STATE CHANGE!";
	};
};
JDAM_CLIENT_KIT_QUEUE set [0, -1];
JDAM_CLIENT_KIT_QUEUE = JDAM_CLIENT_KIT_QUEUE - [-1];