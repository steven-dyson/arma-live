--[[
	The game has a function "sendudpmessage" that doesn't work.
	Those who need it can instead use this module.
]]

require ("socket");
local udpsock = socket.udp();	-- reuse the same socket - and thus source port.

function secenv.sendudp (ip, port, content)
	udpsock:sendto (content,ip,port);
end

local hostcache = {}

function secenv.sendudp_name (hostname, port, content)
	if not hostcache[hostname] then
		hostcache[hostname] = assert(socket.dns.toip(hostname))
	end
	udpsock:sendto (content, hostcache[hostname], port)
end
