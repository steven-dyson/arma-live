// Desc: open squad management dialog with mission specific param's
//-----------------------------------------------------------------------------
#include "armaGameVer.sqh"

if (isNil "ICE_sqdMgt_create") exitWith {hintSilent "Squad Management dialog has not been initialised yet."};

ICE_sqdMgt_groupSizeDefault = 6;
ICE_sqdMgt_groupSizeMax = 13;

/*
Custom team name and flag can be set up using these variable names:
ICE_teamName_client = "BluFor";
ICE_teamFlag_client = "\ca\ui\data\flag_bluefor_ca.paa";
ICE_teamFlag_client = "\a3\ui_f\data\map\Markers\Flags\nato_ca.paa";
*/

(
	// requires ICE blueForceTracking & Commander addon
	(if (isClass (configFile >> "cfgPatches" >> "TB_gameMode_aas") || 
			isClass (configFile >> "cfgPatches" >> "ice_blueForceTracking")) then 
		{["EnableCommanderSelection"]} else {[]})+
  [
		//"AnySquadMemberCanOrganise", // recommended for trusted private servers only. Comment out for public servers.
		//"SetRankForSL", // Warning: this alters ranks, so disable if ranks are used in mission.
		"QueryJoinAcceptance", // recommended for public servers.
		"QuerySLAcceptance", // recommended for public servers.
		"AllowPlayerRecruitment"
		// "AllowPlayerInvites" // AllowPlayerInvites takes precedence over AllowPlayerRecruitment and replaces it. // recommended for public servers.
		//"ShowSquadHUDOnJoin" // requires ICE Squad HUD addon.
  ]+
	(if (isMultiplayer) then {[]} else {
	[
		// "ShowAIGroups", // Warning: some missions could misbehave if AI group changes are made.
		//"showRank",
		//"DeleteRemovedAI",
		// "AllowAIRecruitment", 
		// "AllowAILeaderSelect"
	]})
) call ICE_sqdMgt_create;
