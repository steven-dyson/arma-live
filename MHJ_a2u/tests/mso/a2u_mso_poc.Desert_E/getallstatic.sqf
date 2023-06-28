waituntil {!isnil "uplink_exec"};
["mso_getallstatic()"] spawn uplink_exec_callback;
