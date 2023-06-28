private "_wait";
private "_SET_KIT";
private "_DISCONNECT_KIT";

_wait = 1;

//states
_SET_KIT = 1;
_DISCONNECT_KIT = 2;

while {_wait == 1} do
{
	waitUntil {(count JDAM_SERVER_KIT_QUEUE) > 0};
	call PlayerKits_ServerKitQueue;
};
