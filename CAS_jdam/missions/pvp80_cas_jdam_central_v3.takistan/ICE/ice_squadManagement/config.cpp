#include "armaGameVer.sqh"

#define QUOTEME(x) #x

class CfgPatches
{
	class ICE_squadManagement
	{
		units[] = {};
		weapons[] = {};
		requiredVersion = 1;
		requiredAddons[] = {"Extended_EventHandlers"};
	};
};

class RscListNBox;
//class RscControlsGroup;
class RscStructuredText;

#include "SquadManagement.hpp"

class Extended_PostInit_EventHandlers
{
	class ICE_squadManagement
	{
		init = QUOTEME(if (isNil 'ICE_squadManagement_init') then {ICE_squadManagement_init = true; 'addon' execVM '\ice\ice_squadManagement\init.sqf';};);
	};
};
