/***************************************************************************
SPY Initialization and Compile (Method)
Created by Spyder
spyder@armalive.com
***************************************************************************/



/***************************************************************************
ALL
****************************************************************************/
SPY_core_fnc_bMessage = compile preprocessFileLineNumbers "SPY\SPY_core\SPY_msg\SPY_core_fnc_bMessage.sqf";
SPY_core_fnc_bInfoScreen = compile preprocessFileLineNumbers "SPY\SPY_core\SPY_msg\SPY_core_fnc_bInfoScreen.sqf";
/***************************************************************************
END
****************************************************************************/



/***************************************************************************
SERVER
****************************************************************************/
if ((isServer)) then {};
/***************************************************************************
END
****************************************************************************/



/***************************************************************************
CLIENT
****************************************************************************/
if ((!isDedicated)) then {};
/***************************************************************************
END
****************************************************************************/