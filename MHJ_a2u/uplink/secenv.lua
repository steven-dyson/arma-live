--[[
	This file sets up the basic secure environment. All other functions that are to be available to untrusted code, needs to be added to this table at some point; preferrably together with the definition of that function.
]]

function readonly_table (t)
	local ret = {};
	setmetatable (ret, { __index = t, __metatable={}, __newindex=function() end} );
	return ret;	
end

secenv={
	_VERSION	=_VERSION,
-- Base library
	tostring	=tostring,
	tonumber	=tonumber,
	--print		=print,		-- Std mode only, see below
	unpack		=unpack,
	select		=select,
	next		=next,
	assert		=assert,
	type		=type,
	error		=error,

	--getfenv	=getfenv,
	--setfenv		=setfenv,	-- secure version provided below
	--setmetatable=setmetatable,	-- see below
	--getmetatable=getmetatable,

	pairs		=pairs,
	ipairs		=ipairs,

	xpcall		=xpcall,
	pcall		=pcall,
	
	-- These were recommended kept off, but I do not quite know how much damage they could do in this secenv implementation. Overwrite what functions are available in the secure environment, like table.*, will persist as long as this app is running.
	--rawequal	=rawequal,
	--rawget		=rawget,
	--rawset		=rawset,

--	dofile		=dofile,
--	load        =load,
--	loadfile	=loadfile,
	loadstring	= function (a,b,c,d)
		-- TODO: filter precompiled
		local f = loadstring(a,b,c,d);
		setfenv (f,cursecenv)
		return f
	end,
	
	--newproxy	=newproxy,
	
--	collectgarbage	=collectgarbage,
	
-- Standard libraries
	table		=readonly_table(table),
	string		=readonly_table(string),
	math		=readonly_table(math),
--	os			=os,
--	io			=io,
--	debug		=debug,
	coroutine   =readonly_table(coroutine),

--[[ Modules
--	module          =module,
--	package         =package,
--	require         =require,
--]]
}

if inputmethod=="std" then secenv.print = print else secenv.print = errlog end

-- A lot of powerful stuff relies on this being available.
-- We will operate on the assumption that all the important stuff from outside has a mt set:
function secenv.setmetatable(t,mt) 
	if getmetatable(t) then
		error ("Restricted setmetatable may not overwrite metatables",2);
	end
	setmetatable(t,mt)
end

-- This will be obsoleted by lua 5.2 "in env"
function secenv.setfenv(func,newenv)
	if (type(func)~="function") then
		error ("Restricted setfenv may not operate on stack",2);
	end
	local oldenv = getfenv(func);
	if (oldenv~=cursecenv) then
		error ("Restricted setfenv may only change from secure environment",2);
	end
	assert (type(newenv)=="table");
	setfenv(func,newenv);
end


return secenv
