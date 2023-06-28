--[[
	The armascript interface defined here should be considered standard,
	for other databases use the same interface, but a different name in the secenv function.
]]

require ("luasql.sqlite")

local env = luasql.sqlite();
local connection = env.connect(sqlitedb);

function to_armascript_string (str)
	return str.gsub('"','""')
end

function to_armascript_array (t)
	return '["'..table.concat(t,'", "')..'"]'
end
	
function sql_callbacktable(cursor)
	-- These conditions will be checked by the caller
	--if readonly then return end
	--if not cursecenv.callback then return end
	--assert cursor is indeed a cursor
	
	local function line(cursor)
		local t = cursor.fetch()
		for k,v in pairs(t) do t[k]=to_armascript_string(tostring(v)) end
		if t then return to_armascript_array(t) end
		-- else return nil end
	end
	local rows = {}
	local str = line(cursor);
	while str do
		table.insert(rows,str)
		str = line(cursor);
	end
	output.write ('{[\n  '..table.concat(rows,',\n  ')..']} call ' .. cursecenv.callback ..';');
end

function sql_callbackerror(errmsg)
	assert (not readonly and cursecenv.callback)
	output.write('{ throw "' .. to_armascript_string(errmsg) ..'" } call ' .. cursecenv.callback .. ';');
end

function do_sql(connection, statement)
	local cur, err = connection:execute(statement)
	if not cur then errlog("SQL: "..err) end	-- Log any errors
	
	if readonly or not cursecenv.callback then return end;	-- Nobody's listening anyway.
	
	if not cur then sql_callbackerror(err)
	end
	if (type(cur)=="number") then
		
	end

end




local do_sql = do_sql;	-- Upvalue, needed for lua 5.2
secenv.sql = function (statement) do_sql(connection, statement) end

