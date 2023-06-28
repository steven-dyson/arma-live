waituntil {!isnil "uplink_exec"};

loopback_worked = false;
["loopbackhint(""Hello MSO world"") sqf(""loopback_worked = true"") "] spawn uplink_exec_callback;

sleep 35;
if (!loopback_worked) then { player globalchat "No response from a2u in 30 seconds. Is it running?"; };

