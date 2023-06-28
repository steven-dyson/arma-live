/*=================================================================================================================	
  GVS Watcher by Jacmac	
  
  Version History:
  A	- Initial Release 3/23/2013	
  
  Description:
  Called by	the	Generic	Vehcile	Service	script to prevent the same player from using any service point for a
  specified	period after using a service point successfully. The script	sleeps on a	10 second loop.	If the global 
  variable Global_GVS_InUse	is set to 1	by the Generic Vehicle Service script, Global_GVS_InUse	will be	set	to 0 
  at the end of	a varaible countdown of	10 second passes through the loop.	
  
  Default wait is 100 seconds (10 passes * 10 seconds).	
  
  It is	recommended	to not lower the sleep time	of 10 seconds to keep the execution	to a minimum.
  
  Adjust _gvs_reset_count as desired.
  
  Requirements:	
	See	generic_vehicle_service.sqf	
  
=================================================================================================================*/	
#define	RESET_COUNT	10
#define	LOOP_SLEEP	10

gvs_delay =	{ RESET_COUNT *	LOOP_SLEEP };

gvs_watcher	= 
{
	private	["_gvs_reset_countdown"];

	_gvs_reset_countdown = RESET_COUNT;	

	while {	true } do
	{
		if (Global_GVS_InUse ==	1) then	
		{
			_gvs_reset_countdown = _gvs_reset_countdown	- 1;
			if (_gvs_reset_countdown < 1) then
			{
				_gvs_reset_countdown = RESET_COUNT;	
				Global_GVS_InUse = 0;
			};
		};
		sleep LOOP_SLEEP;
	};
};