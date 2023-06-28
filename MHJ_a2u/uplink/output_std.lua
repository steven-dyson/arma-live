local _G = _G;

local output = require "uplink.output"
module("uplink.output_std")
sqf_escape = output.sqf_escape

-- These four functions are the std specific ones
function writeout(a) _G.io.stdout:write(a) end
function flush() end
function init() end
function ack(a) acknowledged = a end
acknowledged = nil;
