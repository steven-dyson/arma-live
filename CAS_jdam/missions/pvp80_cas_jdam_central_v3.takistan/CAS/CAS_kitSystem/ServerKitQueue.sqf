private "_executeState";

_executeState = JDAM_SERVER_KIT_QUEUE select 0;
switch (_executeState select 1) do
{
	case _SET_KIT:
	{
		(_executeState select 0) call PlayerKits_SetKit;
	};
	
	case _DISCONNECT_KIT:
	{
		(_executeState select 0) call PlayerKits_DisconnectKit;
		player sideChat "DISCONNECT KIT ATTEMPT!";
	};
	
	default
	{
		player sideChat "INVALID STATE CHANGE!";
	};
};
JDAM_SERVER_KIT_QUEUE set [0, -1];
JDAM_SERVER_KIT_QUEUE = JDAM_SERVER_KIT_QUEUE - [-1];