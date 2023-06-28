// Desc: for JIP players, reset group to null, in case a different player takes your slot.
// Exec: JIP client
//-----------------------------------------------------------------------------
if (isDedicated) exitWith {};
waitUntil {player == player};

if (count units player > 1) then // if in a group of 2+, then leave group.
{
	// TODO: check if this player's UID is different. If same, then stay in group, else leave group.
	if (isMultiplayer) then {[player] joinSilent grpNull};
};
