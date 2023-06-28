/*=================================================================================================================
  Config Lookup by Jacmac

  Version History:
  A - Initial Release 3/16/2013

  Features:
  -Allows other scripts to use friendly calls for information lookups to vehicles, weapons, and magazines

  Use in init.sqf:
  call compile preProcessFile "cfg_lookup.sqf";

=================================================================================================================*/


Cfg_Lookup_WeaponInfo =
{
    private["_commonInfo", "_cfg"];
    _cfg = (configFile >> "CfgWeapons" >> _this);
    _commonInfo = _cfg call Cfg_Lookup_CommonInfo;
    [_commonInfo select 0, _commonInfo select 1, _commonInfo select 2, _commonInfo select 3]
};

Cfg_Lookup_MagazineInfo =
{
    private["_commonInfo", "_cfg", "_Count"];
    _cfg = (configFile >> "CfgMagazines" >> _this);
    _commonInfo = _cfg call Cfg_Lookup_CommonInfo;
    _Count = if (isText(_cfg >> "count")) then { parseNumber(getText(_cfg >> "count")) } else { getNumber(_cfg >> "count") };
    [_commonInfo select 0, _commonInfo select 1, _commonInfo select 2, _commonInfo select 3, _Count]
};

Cfg_Lookup_VehicleInfo =
{
    private["_commonInfo", "_cfg", "_MaxSpeed", "_MaxFuel", "_TurretCount", "_VehMagazines"];
    _cfg  = (configFile >> "CfgVehicles" >> _this);
    _TurretCount = count (configFile >> "CfgVehicles" >> _this >> "Turrets");
    _VehMagazines = getArray(configFile >> "CfgVehicles" >> _this >> "magazines");
    _commonInfo = _cfg call Cfg_Lookup_CommonInfo;
    _MaxSpeed = if (isText(_cfg >> "maxSpeed")) then { parseNumber(getText(_cfg >> "maxSpeed")) } else { getNumber(_cfg >> "maxSpeed") };
    _MaxFuel = if (isText(_cfg >> "fuelCapacity")) then { parseNumber(getText(_cfg >> "fuelCapacity")) } else { getNumber(_cfg >>"fuelCapacity") };
    [_commonInfo select 0, _commonInfo select 1, _commonInfo select 2, _commonInfo select 3, _MaxSpeed, _MaxFuel, _TurretCount, _VehMagazines]
};

Cfg_Lookup_CommonInfo =
{
    private["_cfg", "_DisplayName", "_Description", "_TypeID", "_Pic"];
    _cfg = _this;
    _DisplayName = if (isText(_cfg >> "displayName")) then { getText(_cfg >> "displayName") } else { "/" };
    _Description = if (isText(_cfg >> "Library" >> "libTextDesc")) then { getText(_cfg >> "Library" >> "libTextDesc") } else { "/" };
    _Pic = if (isText(_cfg >> "picture")) then { getText(_cfg >> "picture") } else { "/" };
    _TypeID = if (isText(_cfg >> "type")) then { parseNumber(getText(_cfg >> "type")) } else { getNumber(_cfg >> "type") };
    [_DisplayName, _Description, _TypeID, _Pic]
};

Cfg_Lookup_Weapons_GetName          = { (_this call Cfg_Lookup_WeaponInfo) select 0 };
Cfg_Lookup_Weapons_GetDesc          = { (_this call Cfg_Lookup_WeaponInfo) select 1 };
Cfg_Lookup_Weapons_GetType          = { (_this call Cfg_Lookup_WeaponInfo) select 2 };
Cfg_Lookup_Weapons_GetPic           = { (_this call Cfg_Lookup_WeaponInfo) select 3 };

Cfg_Lookup_Magazine_GetName         = { (_this call Cfg_Lookup_MagazineInfo) select 0 };
Cfg_Lookup_Magazine_GetDesc         = { (_this call Cfg_Lookup_MagazineInfo) select 1 };
Cfg_Lookup_Magazine_GetType         = { (_this call Cfg_Lookup_MagazineInfo) select 2 };
Cfg_Lookup_Magazine_GetPic          = { (_this call Cfg_Lookup_MagazineInfo) select 3 };
Cfg_Lookup_Magazine_GetCount        = { (_this call Cfg_Lookup_MagazineInfo) select 4 };

Cfg_Lookup_Vehicle_GetName          = { (_this call Cfg_Lookup_VehicleInfo) select 0 };
Cfg_Lookup_Vehicle_GetDesc          = { (_this call Cfg_Lookup_VehicleInfo) select 1 };
Cfg_Lookup_Vehicle_GetType          = { (_this call Cfg_Lookup_VehicleInfo) select 2 };
Cfg_Lookup_Vehicle_GetPic           = { (_this call Cfg_Lookup_VehicleInfo) select 3 };
Cfg_Lookup_Vehicle_GetSpeed         = { (_this call Cfg_Lookup_VehicleInfo) select 4 };
Cfg_Lookup_Vehicle_GetFuel          = { (_this call Cfg_Lookup_VehicleInfo) select 5 };
Cfg_Lookup_Vehicle_GetTurretCount   = { (_this call Cfg_Lookup_VehicleInfo) select 6 };
Cfg_Lookup_Vehicle_GetMagazines     = { (_this call Cfg_Lookup_VehicleInfo) select 7 };