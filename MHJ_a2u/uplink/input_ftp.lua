
dofile ("uplink/socket_ftp_replacement.lua")	
-- socket.ftp plus a small hack to enable REST command
-- file resides in the same directory but it is not the current directory.
local linebuffer = {}

local readpos = 1	-- Should probably be ignored on initial load anyway
local prevline = ""

local fileptr = socket.url.parse(inputfile);
	fileptr.type="i";
local _G = _G;

module ("uplink.input_ftp")

local function fillbuffer ()
	--_G.loadprogress "Getting more of the file"
	
	if _G.onIdle then _G.onIdle() end
	fileptr.command="REST "..readpos.. (_G.input_ftp_linebreak or "\n") .. "RETR";
	local ftpbuffer = {}
	fileptr.sink = _G.ltn12.sink.table(ftpbuffer);

	local ret,err = _G.ftp_replacement.get(fileptr);
	while not ret or (#ftpbuffer==1 and #ftpbuffer[1]==0) do	-- #ftpbuffer < 1 didn't work
		ftpbuffer[1]=nil;
		_=ret or _G.errlog(err);	-- else successful read of 0 bytes
		--if _G.onIdle then _G.onidle() end
		_G.socket.select(nil, nil, _G.input_sleepduration/1000)
		ret,err = _G.ftp_replacement.get(fileptr);
	end

	-- convert to lines - this could probably be done with ltn12 filters, if only their specification was at least half-assed.
	local buffer = prevline .. _G.table.concat(ftpbuffer)
	-- This next comment - don't know if it's still true:
	-- It's possible to get here with a 0-size buffer. That screws up a lot
	prevline = ""
	ftpbuffer = nil
	_G.collectgarbage("step",2);	-- There's now plenty stuff to collect, so we might as well allow it to grab some of it.
	
	local lineend = 0;
	local linestart = lineend;
	
	lineend = _G.string.find(buffer,'\n',linestart, true);
	while (lineend) do
		local substr = _G.string.sub(buffer,linestart,lineend);
		_G.table.insert(linebuffer, substr);
		linestart = lineend+1;
		lineend = _G.string.find(buffer,'\n',linestart, true);
	end
	prevline = _G.string.sub(buffer,linestart)
	readpos = readpos + #buffer;
end

function readline () 
	if #linebuffer==0 then fillbuffer() end
	return _G.table.remove(linebuffer,1);
end

function search_last_init () 
	_G.loadprogress("Finding last init:")
	_G.loadprogress("Downloading file...")
	if (#linebuffer==0) then fillbuffer() end
	_G.loadprogress("...loaded")
	local keeplines = {};
	while (#linebuffer>0) do
		local line = _G.table.remove(linebuffer,1);
		if _G.string.match(line,"#LOGCOMMS%s+INIT.*") then 
			keeplines = {};	-- reset
		else _G.table.insert(keeplines,line) end 
	end
	linebuffer = keeplines;
	_G.loadprogress("Found last init")
end

