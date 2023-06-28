local _G = _G;

module("uplink.output")

--[[
In order to insulate unrelated writes from each others syntax errors and similar problems,

when not using a callback, it should look like
0 spawn { call compile "code" };

When using a callback, it should look like
0 spawn { compile "code" call callback };

Unfortunately it will impact the order of execution; I could wait for each thread, but that would prohibit continuing if one of them started a long loop or wait. I settled on doing them in parallel because they should be made thread-safe in any case.

]]

sqf_escape = function (str)
	return '"' .. str:gsub('"','""') .. '"'
end
_G.secenv.sqf_escape = sqf_escape

function write(code, callback)
	_G.a2out.writeout ( 
	"0 spawn { call compile \n"
	..	sqf_escape(code)
	..	"\n};\n");
end

_G.secenv.sqf = write;

