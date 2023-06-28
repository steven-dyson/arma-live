waituntil {!isnil "uplink_exec"};
// It might be worth checking if the object has changed since the last time it was saved, etc.

_object = _this;

if (typename _object != "OBJECT") exitwith {
	diag_log "ERROR: storestatic passed non-object";
};
_objectid = netid _object;
if (_objectid == "") exitwith 
{ diag_log "Storing objects requires multiplayer, and can only do global objects"; };

// If weapon/ammo classnames could contain ' then we'd be screwed - but I don't think they can
_string = format[
"mso_storestatic (%1, %2, %3, %4, %5, %6,  '%7', '%8', '%9', '%10')",
	str _objectid,
	str typeof _object,
	str str getposasl _object,	// array to string to quoted string
	str str vectordir _object,
	str str vectorup _object,
	damage _object,
	str weapons _object,
	str magazines _object,
	str getweaponcargo _object,
	str getmagazinecargo _object
];

[_string] call uplink_exec;
