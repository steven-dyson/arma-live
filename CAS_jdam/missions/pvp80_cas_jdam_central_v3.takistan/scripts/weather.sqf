/*
Random weather conditions script, originally written by toadlife for Operation Lojack
Reads weather parameters from the init.sqf
converted to sqf by W0lle
Original script by toadlife for Operation Lojack, converted to sqf by Norrin
When used in your own mission, Credits please to toadlife and Norrin

Needs below lines in the init.sqf:
if (isServer) then
{
  wtime1 = ((random 300) + 1000); //Time for Fog change
  wtime2 = ((random 300) + 1000); //Time for Overcast change
  wtime3 = ((random 300) + 700); //Time for Rain change
  wfog1 = (random 0.75); //Min. fog
  wfog2 = (random 0.5); // Max. fog
  woc1 = (random 0.6); //Min. overcast
  woc2 = (random 0.7); //Max. overcast
  wrain1 = (random 0.8); //Min. rain
  wrain2 = (random 0.8); //Max. rain
  publicVariable "wtime1";
  publicVariable "wtime2";
  publicVariable "wtime3";
  publicVariable "wfog1";
  publicVariable "wfog2";
  publicVariable "wrain1";
  publicVariable "wrain2";
  publicVariable "woc1";
  publicVariable "woc2";
};
[] execVM "scripts\weather.sqf";
*/

if (isServer) then
{
  setweather=true; publicVariable "setweather";
};

waitUntil {setweather};
0 setFog wfog1;
0 setOvercast woc1;
wtime1 setFog wfog2;
wtime2 setOvercast woc2;
if (woc1 >= 0.7) then {0 setRain wrain1};
if (woc2 >= 0.7) then
{
  sleep wtime2;
  wtime3 setRain wrain2;
};
