/***************************************************************************
SPY Initialization and Compile (Method)
Created by Spyder
spyder@armalive.com
***************************************************************************/

waitUntil {sleep 0.1; time > 30};

while {true} do {

	{
		
		[] call bis_fnc_hints;
		[] call BIS_AdvHints_setDefaults;
		
		BIS_AdvHints_THeader = "Server Message";
		BIS_AdvHints_TInfo = "";
		BIS_AdvHints_TImp = _x;
		BIS_AdvHints_TAction = "";
		BIS_AdvHints_TBinds = "";
		BIS_AdvHints_Text = call BIS_AdvHints_formatText;
		BIS_AdvHints_Duration = SPY_msg_scrollMsgsDuration;
		BIS_AdvHints_HideCode = "hintSilent '';";
		call BIS_AdvHints_showHint;
		
		sleep 2;
		
		// STANDARD TEXT
		// _null = [3, _x, "LOCAL", false] spawn SPY_core_fnc_bMessage;
		// SLEEP SPY_msg_scrollMsgsDuration;
		
	} forEach SPY_msg_scrollMsgs;
	
	sleep SPY_msg_scrollMsgsRepeat;
	
};