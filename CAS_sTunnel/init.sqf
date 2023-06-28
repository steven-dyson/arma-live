/***************************************************************************
INIT
CREATED BY SPYDER
SPYDER001@COMCAST.NET
****************************************************************************/

_path = [] execVM "CAS\CAS_sTunnel\init\CAS_path.sqf";
waitUntil {scriptDone _path};

_pathEnd = [] execVM "CAS\CAS_sTunnel\init\CAS_path_end.sqf";
waitUntil {scriptDone _pathEnd};

_roof = [] execVM "CAS\CAS_sTunnel\init\CAS_roof.sqf";
waitUntil {scriptDone _roof};

_floor = [] execVM "CAS\CAS_sTunnel\init\CAS_floor.sqf";
waitUntil {scriptDone _floor};