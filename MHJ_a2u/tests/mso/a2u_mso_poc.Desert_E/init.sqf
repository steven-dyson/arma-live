0 execvm "MHJ_a2uplink.sqf";

loopback = compile preprocessfile "loopback.sqf";
storestatic = compile preprocessfile "storestatic.sqf";
getallstatic = { _this execvm "getallstatic.sqf"; };

