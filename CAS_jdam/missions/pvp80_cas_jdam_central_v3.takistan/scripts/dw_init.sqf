/*
===============================================================================================
Day&Weather Script - by Moerderhoschi
Version: 1.1
Date: 12.02.2011

===============================================================================================
*/
//VariableToForcePermanentWeather
if (isServer and isNil "DW_ForceWeather") then {DW_ForceWeather=true; publicVariable "DW_ForceWeather"};

//GlobalWindSettings
if (isServer and isNil "DW_wx") then {DW_wx = (switch (paramsArray select 1) do
{
  case 2: {(-10+(random 20))};
  case 0: {((-0.5)+(random 1))};
  case 3: {(-1+(random 2))};
  case 0.5: {(-2.5+(random 5))};
  case 0.75: {(-5+(random 10))};
  case 1: {(-10+(random 20))};
});publicVariable "DW_wx";};

if (isServer and isNil "DW_wy") then {DW_wy = (switch (paramsArray select 1) do
{
  case 2: {(-10+(random 20))};
  case 0: {((-0.5)+(random 1))};
  case 3: {(-1+(random 2))};
  case 0.5: {(-2.5+(random 5))};
  case 0.75: {(-5+(random 10))};
  case 1: {(-10+(random 20))};
});publicVariable "DW_wy";};

//ServerDaytimeSettings
if (isServer and paramsArray select 0 == 1) then {skipTime (random -96)};
if (isServer and paramsArray select 0 == 2) then {setDate [2020, 7, 20, 1, 0]};
if (isServer and (paramsArray select 0 != 1) and (paramsArray select 0 != 2)) then {skipTime (paramsArray select 0)};

//ServerWeatherSettings
if (isServer and paramsArray select 1 == 2) then {if (isNil "DW_aktweather") then {DW_aktweather = (random 1); publicVariable "DW_aktweather"}; 0 setOvercast DW_aktweather};
if (isServer and paramsArray select 1 == 3) then {0 setOvercast (0.25)};
if (isServer and (paramsArray select 1 != 2) and (paramsArray select 1 != 3)) then {0 setOvercast (paramsArray select 1)};

//ServerRainSettings
if (isServer and paramsArray select 1 == 2) then {0 setRain DW_aktweather};
if (isServer and paramsArray select 1 == 3) then {0 setRain (0.25)};
if (isServer and (paramsArray select 1 != 2) and (paramsArray select 1 != 3)) then {0 setRain (paramsArray select 1)};

//WaitUntil Player exists
waitUntil {!(isNull player)};

//ClientWeatherSettings
if (paramsarray select 1 == 2) then {0 setOvercast DW_aktweather};
if (paramsarray select 1 == 3) then {0 setOvercast (0.25)};
if ((paramsarray select 1 != 2) and (paramsarray select 1 != 3)) then {0 setOvercast (paramsarray select 1)};

sleep 0.5;

//ClientWetaherSettingsForLongTime
if (paramsarray select 1 == 2) then {36000 setOvercast DW_aktweather};
if (paramsarray select 1 == 3) then {36000 setOvercast (0.25)};
if ((paramsarray select 1 != 2) and (paramsarray select 1 != 3)) then {36000 setOvercast (paramsarray select 1)};

//PermanentForcedClientWindAndRainSettings
while {DW_ForceWeather} do
{
  sleep 1;
  setwind [DW_wx,DW_wy,true];
  3 setRain (switch (paramsArray select 1) do
  {
    case 2: {DW_aktweather};
    case 0: {(paramsArray select 1)};
    case 3: {(0.25)};
    case 0.5: {(paramsArray select 1)};
    case 0.75: {(paramsArray select 1)};
    case 1: {(paramsArray select 1)};
  });
};