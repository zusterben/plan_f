local tinsert = table.insert
local ssub, slen, schar, sbyte, sformat, sgsub = string.sub, string.len, string.char, string.byte, string.format, string.gsub
local jsonParse, jsonStringify = cjson.decode, cjson.encode
local b64decode = nixio.bin.b64decode
local b64encode = nixio.bin.b64encode
local dbus_get = skipd.get
local dbus_getall = skipd.get_all
local dbus_lock = skipd.lock
local dbus_unlock = skipd.unlock
local dbus_checklock = skipd.islocked
local dbus_nodelist = skipd.get_nodelist

local function stringsplit(str,splitchar)
	local tmp
	for s in (str):gmatch("(.-)"..splitchar) do
		tmp = s
	end
	return tmp
end

--bafter - true:before,false:after
local function getstring(strfull, strchar, bafter)
	local ts = string.reverse(strfull)
	local param1, param2 = string.find(ts, strchar)
	local m = string.len(strfull) - param2 + 1 
	local result
	if (bafter == true) then
		result = string.sub(strfull, m+1, string.len(strfull)) 
	else
		result = string.sub(strfull, 1, m-1) 
	end
	return result
end

-- 分割字符串
local function split(full, sep)
	full = full:gsub("%z", "") -- 这里不是很清楚 有时候结尾带个\0
	local off, result = 1, {}
	while true do
		local nStart, nEnd = full:find(sep, off)
		if not nEnd then
			local res = ssub(full, off, slen(full))
			if #res > 0 then -- 过滤掉 \0
				tinsert(result, res)
			end
			break
		else
			tinsert(result, ssub(full, off, nStart - 1))
			off = nEnd + 1
		end
	end
	return result
end

local function ping_func(server, method)
	local cmd = "" ping_time = "" ping_loss = "" ping_num = 0 ping_text = ""
	if server == "0" then
		local tmp = dbus_nodelist("ssconf_basic_json_")
		local nodelist = split(tmp, " ")
		ping_text = "["
		for i, v in pairs(nodelist) do
			tmp = dbus_get("ssconf_basic_json_" .. v)
			local node_doamin = jsonParse(b64decode(tmp))
			if method == "1" then
				cmd = "ping -4 " .. node_doamin.server .. " -c 1 -w 1 -q"
			elseif method == "2" then
				cmd = "ping -4 " .. node_doamin.server .. " -c 5 -w 5 -q"
			elseif method == "3" then
				cmd = "ping -4 " .. node_doamin.server .. " -c 10 -w 10 -q"
			elseif method == "4" then
				cmd = "ping -4 " .. node_doamin.server .. " -c 20 -w 20 -q"
			end
			tmp = io.popen(cmd)
			local response = tmp:read("*a")
			if response and response ~= "" then
				ping_time = stringsplit(response, "/")
				if not ping_time or ping_time == "" then
					ping_time = ""
				end
				ping_loss = getstring(response, ",", true):match("%d%%")
				if ping_num > 0 then
					ping_text = ping_text .. ","
				end
				ping_text = ping_text .. "[\"" .. i .. "\",\"" .. ping_time .. "\",\"" .. ping_loss .. "\"]"
				ping_num = ping_num + 1
			else
				if ping_num > 0 then
					ping_text = ping_text .. ","
				end
				ping_text = ping_text .. "[\"" .. i .. "\",\"0\",\"100%\"]"
				ping_num = ping_num + 1
			end
		end
		ping_text = ping_text .. "]"
	else
		local tmp = dbus_get("ssconf_basic_json_" .. server)
		local node_doamin = jsonParse(b64decode(tmp))
		if method == "1" then
			cmd = "ping -4 " .. node_doamin.server .. " -c 1 -w 1 -q"
		elseif method == "2" then
			cmd = "ping -4 " .. node_doamin.server .. " -c 5 -w 5 -q"
		elseif method == "3" then
			cmd = "ping -4 " .. node_doamin.server .. " -c 10 -w 10 -q"
		elseif method == "4" then
			cmd = "ping -4 " .. node_doamin.server .. " -c 20 -w 20 -q"
		end
		tmp = io.popen(cmd)
		local response = tmp:read("*a")
		if response and response ~= "" then
			ping_time = stringsplit(response, "/")
			if not ping_time or ping_time == "" then
				ping_time = ""
			end
			ping_loss = getstring(response, ",", true):match("%d%%")
			ping_text = "[[\"" ..server .. "\",\"" .. ping_time .. "\",\"" .. ping_loss .. "\"]]"
		else
			ping_text = "[[\"" .. server .. "\",\"0\",\"100%\"]]"
		end
	end
	print(b64encode(ping_text))
end


local function start_ping()
	local check = dbus_checklock("ss_ping")
	if check > 0 then
		return
	end
	local server_section = dbus_get("ssconf_basic_ping_node")
	local method = dbus_get("ssconf_basic_ping_method")
	if not server_section or server_section == "" then
		server_section = "0"
	end
	if not method or method == "" then
		method = "2"
	end
	dbus_lock("ss_ping")
	ping_func(server_section, method)
	dbus_unlock("ss_ping")
end

start_ping()
