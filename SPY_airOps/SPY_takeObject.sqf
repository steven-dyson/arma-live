/***************************************************************************
SPY_takeObject.sqf
Created by Spyder
25 JAN 2011
****************************************************************************/

private ["_objectType"];

_objectType = _this select 3;

if (("T10D" in _objectType)) then {player removeWeapon "ACE_ParachutePack"; player addWeapon "ACE_ParachuteRoundPack";};
	
if (("MC5" in _objectType)) then {player removeWeapon "ACE_ParachuteRoundPack"; player addWeapon "ACE_ParachutePack";};
	
if (("Rope" in _objectType)) then {player addMagazine "ACE_Rope_M_120";};

