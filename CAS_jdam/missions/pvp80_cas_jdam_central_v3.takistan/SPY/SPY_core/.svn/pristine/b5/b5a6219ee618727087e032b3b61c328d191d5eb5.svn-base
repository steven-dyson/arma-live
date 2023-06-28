/*
	Author: Spyder (spyder@armalive.com)

	Description:
	Displays a local message to a player. The player is added to a radio array during the display process only.

	Parameter(s):
	0: SCALAR - type of message to display
	1: STRING - text to display
	2: SCALAR - type of hint to display
	2: ARRAY - array containing STRING: Name of diary record and STRING: Name of entry
	2: BOOLEAN - true: adds entry in rpt

	Returns:
	BOOLEAN
*/

scriptName "SPY Core Msg Broadcast Message";

private ["_index", "_lead"];

_type = (_this select 0);
_msg = (_this select 1);
_hint = (_this select 2);
_log = (_this select 3);
_rpt = (_this select 4);

// Exit if debug is disabled for debug messages
if ((_type in [1]) && !(SPY_msg_debug)) exitWith {};

// Define message lead symbol %Todo custom symbol add script
switch (_type) do 
{
	case 1: { _index = SPY_msg_debugIndex; _lead = "[D]"; }; // Debug
	case 2: { _index = SPY_msg_errorIndex; _lead = "[E]"; }; // Errors
	case 3: { _index = SPY_msg_infoIndex; _lead = "[I]"; }; // Information
	case 4: { _index = SPY_msg_warnIndex; _lead = "[W]"; }; // Warnings
	case 5: { _index = SPY_bStats_radioIndex; _lead = "[S]"; }; // bStats
};

// Text message
_index radioChannelAdd [player];
player customChat [_index, _msg];
_index radioChannelRemove [player];
// SPY_container globalChat format ["%1 %2", _lead, _msg];

// Display hint
switch (_hint) do
{
	case 1: 
	{
		hint (format ["%1 %2", _lead, _msg]);
	};
	
	case 2: 
	{
		hintC (format ["%1 %2", _lead, _msg]);
	};
};

// Add to log
if (!(_log isEqualTo "")) then
{
	player createDiaryRecord [(_log select 0), [(_log select 1), _msg]];
};

if ((_rpt)) then
{
	diag_log (format ["%1 %2", _lead, _msg]);
};

true