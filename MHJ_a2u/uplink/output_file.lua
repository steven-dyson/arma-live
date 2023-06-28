local _G = _G;
local table = table;

local output = require "uplink.output"
module("uplink.output_file")
sqf_escape = output.sqf_escape

local sessionid = 0;
-- nonlocal "filenum"
--local sessionserial = 0;

writebuffer = {}

-- These four functions are the interface
function writeout(a) 
	table.insert(writebuffer,a);
	table.insert(writebuffer,"\n");	
end
function flush() 
	if not filenum then return end
	if #writebuffer == 0 then return end
	local filepath = _G.outputfile .. sessionid .. '.' .. filenum;
	
	local file = _G.assert(_G.io.open(filepath,"w"))
	file:write(table.concat(writebuffer))
	file:close()
	writebuffer = {}
end
function init(newid)
	writebuffer = {}
	sessionid = newid
end

