private "_wait";
private "_FILL_KIT";
private "_MAIN_MENU";
private "_BUILD_LIST";
private "_SELECT_BUILD";
private "_BUILD";
private "_CANCEL";

_wait = 1;

//kit states
_FILL_KIT = 1;

//menu states
_MAIN_MENU = 1;
_BUILD_LIST = 2;
_SELECT_BUILD = 3;
_BUILD = 4;
_CANCEL = 5;

while {_wait == 1} do
{
	waitUntil {((count JDAM_CLIENT_KIT_QUEUE) > 0) || ((count JDAM_BUILDING_MENU_QUEUE) > 0)};
	if ((count JDAM_CLIENT_KIT_QUEUE) > 0) then
	{
		call PlayerKits_ClientKitQueue;
	};
	//if ((count JDAM_BUILDING_MENU_QUEUE) > 0) then
	//{
		//call ClientBuildSystem_MenuQueue;
	//};
};