/*
	Author: Spyder (spyder@armalive.com)

	Description:
	Initialize

	Parameter(s):
		NONE

	Returns:
	BOOL
*/

// Init diary
player createDiarySubject ["SPY Systems", "SPY Systems"];

SPY_msg_debugIndex = radioChannelCreate [[0.96, 0.34, 0.13, 0.8], "SPY Debug Radio", "[D]", []];
publicVariable "SPY_msg_debugIndex";

SPY_msg_errorIndex = radioChannelCreate [[0.96, 0.14, 0.03, 0.3], "SPY Error Radio", "[E]", []];
publicVariable "SPY_msg_errorIndex";

SPY_msg_infoIndex = radioChannelCreate [[0.13, 0.34, 0.96, 0.8], "SPY Info Radio", "[I]", []];
publicVariable "SPY_msg_infoIndex";

SPY_msg_warnIndex = radioChannelCreate [[1, 0.14, 0.03, 0.3], "SPY Warning Radio", "[W]", []];
publicVariable "SPY_msg_warnIndex";

// Debug
_null = [1, "Core: Msg Initialized *Server*", 0, ["SPY Systems", "Debug Log"], true] spawn SPY_core_fnc_bMessage;