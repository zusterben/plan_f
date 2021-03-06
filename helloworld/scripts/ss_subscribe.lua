------------------------------------------------
-- This file is part of the luci-app-ssr-plus subscribe.lua
-- @author William Chan <root@williamchan.me>
-- 2020/03/15 by chongshengB
-- 2021/05/13 by zusterben
------------------------------------------------
-- these global functions are accessed all the time by the event handler
-- so caching them is worth the effort
local tinsert = table.insert
local ssub, slen, schar, sbyte, sformat, sgsub = string.sub, string.len, string.char, string.byte, string.format, string.gsub
local jsonParse, jsonStringify = cjson.decode, cjson.encode
local b64decode = nixio.bin.b64decode
local b64encode = nixio.bin.b64encode
local cache = {}
local nodeResult = setmetatable({}, {__index = cache}) -- update result
local subscribe_url = {}
local i = 1
-- base64
local function base64Decode(text)
	local raw = text
	if not text then return '' end
	text = text:gsub("%z", "")
	text = text:gsub("_", "/")
	text = text:gsub("-", "+")
	local mod4 = #text % 4
	text = text .. string.sub('====', mod4 + 1)
	local result = b64decode(text)
	
	if result then
		return result:gsub("%z", "")
	else
		return raw
	end
end
local ssrindext = io.popen('dbus list ssconf_basic_json_ | cut -d "=" -f1 | cut -d "_" -f4 | sort -rn|head -n1')
local ssrindex = ssrindext:read("*all")
if #ssrindex == 0 then
	ssrindex = 1
else
	ssrindex = tonumber(ssrindex) + 1
end
local ssrmodet = io.popen('dbus get ssconf_subscribe_mode')
local ssrmode = tonumber(ssrmodet:read("*all"))
local tfilter_words = io.popen("dbus get ssconf_basic_exclude")
local filter_words = tfilter_words:read("*all"):gsub("\n", "")
local tsave_words = io.popen("dbus get ssconf_basic_include")
local save_words = tsave_words:read("*all"):gsub("\n", "")
local tsubscribe_url = io.popen("dbus get ssconf_online_links | base64 -d")
local subscribe_url2 = tsubscribe_url:read("*all")
for w in subscribe_url2:gmatch("%C+") do 
table.insert(subscribe_url, w) 
i = i+1
end
local tpacket_encoding = io.popen("dbus get ssconf_default_packet_encoding")
local packet_encoding = tpacket_encoding:read("*all") or nil
if packet_encoding == '\n' then
	packet_encoding = nil
end

local log = function(...)
	print(os.date("%Y-%m-%d %H:%M:%S ") .. table.concat({...}, " "))
end
local encrypt_methods_ss = {
	-- plain
	"none",
	"plain",
	-- aead
	"aes-128-gcm",
	"aes-192-gcm",
	"aes-256-gcm",
	"chacha20-ietf-poly1305",
	"xchacha20-ietf-poly1305",
	-- aead 2022
	"2022-blake3-aes-128-gcm",
	"2022-blake3-aes-256-gcm",
	"2022-blake3-chacha20-poly1305"
	--[[ stream
	"table",
	"rc4",
	"rc4-md5",
	"aes-128-cfb",
	"aes-192-cfb",
	"aes-256-cfb",
	"aes-128-ctr",
	"aes-192-ctr",
	"aes-256-ctr",
	"bf-cfb",
	"camellia-128-cfb",
	"camellia-192-cfb",
	"camellia-256-cfb",
	"salsa20",
	"chacha20",
	"chacha20-ietf" ]]
}
-- ???????????????
local function split(full, sep)
	full = full:gsub("%z", "") -- ????????????????????? ?????????????????????\0
	local off, result = 1, {}
	while true do
		local nStart, nEnd = full:find(sep, off)
		if not nEnd then
			local res = ssub(full, off, slen(full))
			if #res > 0 then -- ????????? \0
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
-- urlencode
local function get_urlencode(c)
	return sformat("%%%02X", sbyte(c))
end

local function urlEncode(szText)
	local str = szText:gsub("([^0-9a-zA-Z ])", get_urlencode)
	str = str:gsub(" ", "+")
	return str
end

local function get_urldecode(h)
	return schar(tonumber(h, 16))
end
local function UrlDecode(szText)
	return szText:gsub("+", " "):gsub("%%(%x%x)", get_urldecode)
end

-- trim
local function trim(text)
	if not text or text == "" then
		return ""
	end
	return (sgsub(text, "^%s*(.-)%s*$", "%1"))
end
-- md5
local function md5(content)
	local stdout = io.popen("echo -n '" .. urlEncode(content) .. "'|md5sum|cut -d ' ' -f1")
	local stdout2 = stdout:read("*all")
	-- assert(nixio.errno() == 0)
	return trim(stdout2)
end
-- ????????????(table)??????????????????????????????
-- https://www.04007.cn/article/135.html
local function checkTabValue(tab)
	local revtab = {}
	for k,v in pairs(tab) do
		revtab[v] = true
	end
	return revtab
end
-- ????????????
local function processData(szType, content)
	local result = {type = szType, local_port = 3333, kcp_param = '--nocomp'}
	if szType == 'ssr' then
		local dat = split(content, "/%?")
		local hostInfo = split(dat[1], ':')
		result.type = "v2ray"
		result.v2ray_protocol = "shadowsocksr"
		result.server = hostInfo[1]
		result.server_port = hostInfo[2]
		result.protocol = hostInfo[3]
		result.encrypt_method = hostInfo[4]
		result.obfs = hostInfo[5]
		result.password = base64Decode(hostInfo[6])
		local params = {}
		for _, v in pairs(split(dat[2], '&')) do
			local t = split(v, '=')
			params[t[1]] = t[2]
		end
		result.obfs_param = base64Decode(params.obfsparam)
		result.protocol_param = base64Decode(params.protoparam)
		local group = base64Decode(params.group)
		if group then
			result.alias = "[" .. group .. "] "
		end
		result.alias = result.alias .. base64Decode(params.remarks)
	elseif szType == 'vmess' then
		local info = jsonParse(content)
		result.type = 'v2ray'
		result.v2ray_protocol = 'vmess'
		result.server = info.add
		result.server_port = info.port
		result.transport = info.net
		result.alter_id = info.aid or "0"
		result.vmess_id = info.id
		result.alias = info.ps
		result.packet_encoding = packet_encoding
		-- result.mux = 1
		-- result.concurrency = 8
		if info.net == 'ws' then
			result.ws_host = info.host
			result.ws_path = info.path
		end
		if info.net == 'h2' then
			result.h2_host = info.host
			result.h2_path = info.path
		end
		if info.net == 'tcp' then
			if info.type and info.type ~= "http" then
				info.type = "none"
			end
			result.tcp_guise = info.type
			result.http_host = info.host
			result.http_path = info.path
		end
		if info.net == 'kcp' then
			result.kcp_guise = info.type
			result.mtu = 1350
			result.tti = 50
			result.uplink_capacity = 5
			result.downlink_capacity = 20
			result.read_buffer_size = 2
			result.write_buffer_size = 2
		end
		if info.net == 'grpc' then
			if info.path then
				result.serviceName = info.path
			elseif info.serviceName then
				result.serviceName = info.serviceName
			end
		end
		if info.net == 'quic' then
			result.quic_guise = info.type
			result.quic_key = info.key
			result.quic_security = info.securty
		end
		if info.security then
			result.security = info.security
		end
		if info.tls == "tls" or info.tls == "1" then
			result.tls = "1"
			if info.host then
				result.tls_host = info.host
			elseif info.sni then
				result.tls_host = info.sni
			end
			result.insecure = 1
		else
			result.tls = "0"
		end
	elseif szType == "ss" then
		local idx_sp = 0
		local alias = ""
		if content:find("#") then
			idx_sp = content:find("#")
			alias = content:sub(idx_sp + 1, -1)
		end
		local info = content:sub(1, idx_sp - 1)
		local hostInfo = split(base64Decode(info), "@")
		local hostInfoLen = #hostInfo
		local host = nil
		local userinfo = nil
		if hostInfoLen > 2 then
			host = split(hostInfo[hostInfoLen], ":")
			userinfo = {}
			for i = 1, hostInfoLen - 1 do
				tinsert(userinfo, hostInfo[i])
			end
			userinfo = table.concat(userinfo, '@')
		else
			host = split(hostInfo[2], ":")
			userinfo = base64Decode(hostInfo[1])
		end
		local method = userinfo:sub(1, userinfo:find(":") - 1)
		local password = userinfo:sub(userinfo:find(":") + 1, #userinfo)
		result.alias = UrlDecode(alias)
		result.type = "v2ray"
		result.v2ray_protocol = "shadowsocks"
		result.encrypt_method_ss = method
		result.password = password
		result.server = host[1]
		if host[2]:find("/%?") then
			local query = split(host[2], "/%?")
			result.server_port = query[1]
			local params = {}
			for _, v in pairs(split(query[2], '&')) do
				local t = split(v, '=')
				params[t[1]] = t[2]
			end
			if params.plugin then
				local plugin_info = UrlDecode(params.plugin)
				local idx_pn = plugin_info:find(";")
				if idx_pn then
					result.plugin = plugin_info:sub(1, idx_pn - 1)
					result.plugin_opts = plugin_info:sub(idx_pn + 1, #plugin_info)
				else
					result.plugin = plugin_info
				end
				-- ????????????????????????????????? simple-obfs????????????????????? obfs-local
				if result.plugin == "simple-obfs" then
					result.plugin = "obfs-local"
				end
			end
		else
			result.server_port = host[2]:gsub("/","")
		end
		if checkTabValue(encrypt_methods_ss)[method] then
			result.encrypt_method_ss = method
			result.password = password
		else
			-- 1202 ?????????????????? SS AEAD ????????????
			--result = nil
			result.encrypt_method_ss = method
			result.password = password
		end
	elseif szType == "sip008" then
		result.type = "ss"
		result.v2ray_protocol = "shadowsocks"
		result.server = content.server
		result.server_port = content.server_port
		result.password = content.password
		result.encrypt_method_ss = content.method
		result.plugin = content.plugin
		result.plugin_opts = content.plugin_opts
		result.alias = content.remarks
		if not checkTabValue(encrypt_methods_ss)[content.method] then
			result.server = nil
		end
	elseif szType == "ssd" then
		result.type = "ss"
		result.v2ray_protocol = "shadowsocks"
		result.server = content.server
		result.server_port = content.port
		result.password = content.password
		result.encrypt_method_ss = content.method
		result.plugin_opts = content.plugin_options
		result.alias = "[" .. content.airport .. "] " .. content.remarks
		if content.plugin == "simple-obfs" then
			result.plugin = "obfs-local"
		else
			result.plugin = content.plugin
		end
		if not checkTabValue(encrypt_methods_ss)[content.encryption] then
			result.server = nil
		end
	elseif szType == "trojan" then
		local idx_sp = 0
		local alias = ""
		if content:find("#") then
			idx_sp = content:find("#")
			alias = content:sub(idx_sp + 1, -1)
		end
		local info = content:sub(1, idx_sp - 1)
		local hostInfo = split(info, "@")
		local host = split(hostInfo[2], ":")
		local userinfo = hostInfo[1]
		local password = userinfo
		result.alias = UrlDecode(alias)
		result.type = "v2ray"
		result.v2ray_protocol = "trojan"
		result.server = host[1]
		-- ????????????????????? ????????????ssl??????
		result.insecure = "0"
		result.tls = "1"
		if host[2]:find("?") then
			local query = split(host[2], "?")
			result.server_port = query[1]
			local params = {}
			for _, v in pairs(split(query[2], '&')) do
				local t = split(v, '=')
				params[t[1]] = t[2]
			end
			if params.sni then
				-- ?????????peer???sni???????????????remote addr
				result.tls_host = params.sni
			end
		else
			result.server_port = host[2]
		end
		result.password = password
	elseif szType == "vless" then
		local idx_sp = 0
		local alias = ""
		if content:find("#") then
			idx_sp = content:find("#")
			alias = content:sub(idx_sp + 1, -1)
		end
		local info = content:sub(1, idx_sp - 1)
		local hostInfo = split(info, "@")
		local host = split(hostInfo[2], ":")
		local uuid = hostInfo[1]
		if host[2]:find("?") then
			local query = split(host[2], "?")
			local params = {}
			for _, v in pairs(split(UrlDecode(query[2]), '&')) do
				local t = split(v, '=')
				params[t[1]] = t[2]
			end
			result.alias = UrlDecode(alias)
			result.type = 'v2ray'
			result.v2ray_protocol = 'vless'
			result.server = host[1]
			result.server_port = query[1]
			result.vmess_id = uuid
			result.vless_encryption = params.encryption or "none"
			result.transport = params.type and (params.type == 'http' and 'h2' or params.type) or "tcp"
			result.packet_encoding = packet_encoding
			if not params.type or params.type == "tcp" then
				if params.security == "xtls" then
					result.xtls = "1"
					result.tls_host = params.sni
					result.vless_flow = params.flow
				else
					result.xtls = "0"
				end
			end
			if params.type == 'ws' then
				result.ws_host = params.host
				result.ws_path = params.path or "/"
			end
			if params.type == 'http' then
				result.h2_host = params.host
				result.h2_path = params.path or "/"
			end
			if params.type == 'kcp' then
				result.kcp_guise = params.headerType or "none"
				result.mtu = 1350
				result.tti = 50
				result.uplink_capacity = 5
				result.downlink_capacity = 20
				result.read_buffer_size = 2
				result.write_buffer_size = 2
				result.seed = params.seed
			end
			if params.type == 'quic' then
				result.quic_guise = params.headerType or "none"
				result.quic_key = params.key
				result.quic_security = params.quicSecurity or "none"
			end
			if params.type == 'grpc' then
				result.serviceName = params.serviceName
			end
			if params.security == "tls" then
				result.tls = "1"
				result.tls_host = params.sni
			else
				result.tls = "0"
			end
		else
			result.server_port = host[2]
		end
	end
	if not result.alias then
		if result.server and result.server_port then
			result.alias = result.server .. ':' .. result.server_port
		else
			result.alias = "NULL"
		end
	end
	-- alias ????????? hashkey ??????
	local alias = result.alias
	result.alias = nil
	local switch_enable = result.switch_enable
	result.switch_enable = nil
	result.hashkey = md5(jsonStringify(result))
	result.alias = alias
	result.switch_enable = switch_enable
	return result
end
-- wget
local function wget(url)
	local stdout = io.popen('curl -k -s --connect-timeout 15 --retry 5 "' .. url .. '"')
	local sresult = stdout:read("*all")
	return trim(sresult)
end

local function check_filer(result)
	do
		-- ????????????????????????
		local filter_word = split(filter_words, ",")
		-- ????????????????????????
		local check_save = false
		if save_words ~= nil and save_words ~= "" and save_words ~= "NULL" and save_words ~= "\n" then
			check_save = true
		end
		local save_word = split(save_words, ",")
		-- ????????????
		local filter_result = false
		local save_result = true

		-- ?????????????????????????????????
		for i, v in pairs(filter_word) do
			if tostring(result.alias):find(v, nil, true) then
				filter_result = true
			end
		end
		-- ???????????????????????????????????????????????????????????????
		if check_save == true then
			for i, v in pairs(save_word) do
				if tostring(result.alias):find(v, nil, true) then
					save_result = false
				end
			end
		else
			save_result = false
		end
		-- ???????????????
		if filter_result == true or save_result == true then
			return true
		else
			return false
		end
	end
end

--local execute = function()
	-- exec
	do
		for k, url in ipairs(subscribe_url) do
			local raw = wget(url)
			if #raw > 0 then
				local nodes, szType
				local groupHash = md5(url)
				cache[groupHash] = {}
				tinsert(nodeResult, {})
				local index = #nodeResult
				-- SSD ????????????????????? ssd:// ?????????
				if raw:find('ssd://') then
					szType = 'ssd'
					local nEnd = select(2, raw:find('ssd://'))
					nodes = base64Decode(raw:sub(nEnd + 1, #raw))
					nodes = jsonParse(nodes)
					local extra = {airport = nodes.airport, port = nodes.port, encryption = nodes.encryption, password = nodes.password}
					local servers = {}
					-- SS???????????? ??????????????????
					for _, server in ipairs(nodes.servers) do
						tinsert(servers, setmetatable(server, {__index = extra}))
					end
					nodes = servers
				-- SS SIP008 ???????????? Json ??????
				elseif raw:find('{"configs"') then
					nodes = jsonParse(raw).servers or jsonParse(raw)
					if nodes[1].server and nodes[1].method then
						szType = 'sip008'
					end
				else
					-- ssd ????????????
					nodes = split(base64Decode(raw):gsub(" ", "_"), "\n")
				end

				for _, v in ipairs(nodes) do
					if v then
						local result
						if szType then
							result = processData(szType, v)
						elseif not szType then
							local node = trim(v)
							local dat = split(node, "://")
							if dat and dat[1] and dat[2] then
								local dat3 = ""
								if dat[3] then
									dat3 = "://" .. dat[3]
								end
								if dat[1] == 'ss' or dat[1] == 'trojan' then
									result = processData(dat[1], dat[2] .. dat3)
								else
									result = processData(dat[1], base64Decode(dat[2]))
								end
							end
						else
							log('??????????????????: ' .. szType)
						end
						-- log(result)
						if result then
							-- ?????????????????? ??????????????????????????????????????????????????????Puny Code SB ??????
							if not result.server or not result.server_port or result.alias == "NULL" or check_filer(result) or result.server:match("[^0-9a-zA-Z%-%.%s]") or cache[groupHash][result.hashkey] then
								log('??????????????????: ' .. result.v2ray_protocol .. ' ??????, ' .. result.alias)
							else
								log('????????????: ' .. result.v2ray_protocol ..' ??????, ' .. result.alias)
								result.grouphashkey = groupHash
								tinsert(nodeResult[index], result)
								cache[groupHash][result.hashkey] = nodeResult[index][#nodeResult[index]]
							end
						end
					end

				end
				log('????????????????????????: ' .. #nodes)
			else
				log(url .. ': ??????????????????')
			end
		end
	end
	-- diff
	do
		if next(nodeResult) == nil then
			log("??????????????????????????????????????????")
			return
		end
		local add, del = 0, 0
		for k, v in ipairs(nodeResult) do
			for kk, vv in ipairs(v) do
				if not vv._ignore then
					os.execute("dbus set ssconf_basic_json_" .. ssrindex .. "=" .. b64encode(jsonStringify(vv)))
					os.execute("dbus set ssconf_basic_jsontype_" .. ssrindex .. "=" .. "1")
					os.execute("dbus set ssconf_basic_mode_" .. ssrindex .. "=" .. ssrmode)
					ssrindex = ssrindex +1
					add = add + 1
				end
			end
		end
		log('??????????????????: ' .. add, '??????????????????: ' .. del)
		log('??????????????????')
	end
--end

