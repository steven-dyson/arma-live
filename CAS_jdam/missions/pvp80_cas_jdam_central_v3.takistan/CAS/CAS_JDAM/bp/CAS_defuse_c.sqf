/***************************************************************************
Defuse Client
Created by Spyder
spyder@armalive.com
***************************************************************************/

scriptName "CAS JDAM BP Defuse Client";

private ["_bp", "_player"];

_bp = (_this select 0);
_player = (_this select 1);

_bp setVariable ["CAS_JDAM_chargeSet", false, true];

// ANIMATION
_animation = "(_this select 0) playMove 'amovpercmstpsraswrfldnon_amovpknlmstpslowwrfldnon';";
_null = [[_player], _animation, "CLIENT"] spawn CAS_mpCB;