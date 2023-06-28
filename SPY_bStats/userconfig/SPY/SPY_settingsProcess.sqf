/***************************************************************************
SPY INIT AND COMPILE (METHOD)
BSTATS SETTINGS
CREATED BY SPYDER
SPYDER@ARMALIVE.COM
***************************************************************************/

private ["_setting", "_variable", "_value"];

_settings = (_this select 0);

{

	_str = (_x select 0) + " = " + ( str (_x select 1));

	call compile _str;
	publicVariable (_x select 0);
	
} forEach _settings;