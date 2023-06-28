/***************************************************************************
SPY Initialization and Compile (Method)
Created by Spyder
spyder@armalive.com
***************************************************************************/



/***************************************************************************
ALL
****************************************************************************/

/***************************************************************************
END
****************************************************************************/



/***************************************************************************
SERVER
****************************************************************************/
if ((isServer)) then {

	SPY_core_fnc_compareUID = compile preprocessFileLineNumbers "SPY\SPY_core\SPY_connect\SPY_core_fnc_compareUID.sqf";

};
/***************************************************************************
END
****************************************************************************/



/***************************************************************************
CLIENT
****************************************************************************/
if ((!isDedicated)) then {

	SPY_connect_fnc_clientKick = compile preprocessFileLineNumbers "SPY\SPY_core\SPY_connect\SPY_connect_fnc_clientKick.sqf";

};
/***************************************************************************
END
****************************************************************************/