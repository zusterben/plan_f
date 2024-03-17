local jsonParse, jsonStringify = cjson.decode, cjson.encode
local b64decode = nixio.bin.b64decode
local b64encode = nixio.bin.b64encode
local server_section = arg[1]
local proto = arg[2]
local local_port = arg[3] or "0"
local socks_port = arg[4] or "0"

local log = function(...)
	print(os.date("%Y-%m-%d %H:%M:%S ") .. table.concat({...}, " "))
end
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

local tserver = io.popen("dbus get ssconf_basic_json_" .. server_section)
local tserver2 = tserver:read("*a"):gsub("\n", "")
tserver:close()
local server = jsonParse(b64decode(tserver2))
local outbound_settings = nil

function shadowsocksr()
	outbound_settings = {
		plugin = ((server.v2ray_protocol == "shadowsocks") and server.plugin ~= "none" and server.plugin) or (server.v2ray_protocol == "shadowsocksr" and "shadowsocksr") or nil,
		pluginOpts = (server.v2ray_protocol == "shadowsocks") and server.plugin_opts or nil,
		pluginArgs = (server.v2ray_protocol == "shadowsocksr") and {
			"--protocol=" .. server.protocol,
			"--protocol-param=" .. (server.protocol_param or ""),
			"--obfs=" .. server.obfs,
			"--obfs-param=" .. (server.obfs_param or "")
		} or nil,
		servers = {
			{
				address = server.server,
				port = tonumber(server.server_port),
				password = server.password,
				method = ((server.v2ray_protocol == "shadowsocks") and server.encrypt_method_ss) or ((server.v2ray_protocol == "shadowsocksr") and server.encrypt_method) or nil,
				ivCheck = (server.v2ray_protocol == "shadowsocks") and (server.ivCheck == '1') or nil,
			}
		}
	}

	if server.v2ray_protocol == "shadowsocksr" then
		server.v2ray_protocol = "shadowsocks"
	end
end

local outbound = {}
function outbound:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end
function outbound:handleIndex(index)
	local switch = {
		shadowsocks = function()
			shadowsocksr()
		end,
		shadowsocksr = function()
			shadowsocksr()
		end
	}
	if switch[index] then
		switch[index]()
	end
end
local settings = outbound:new()
settings:handleIndex(server.v2ray_protocol)
local Xray = {
	log = {
		-- error = "/var/ssrplus.log",
		loglevel = "warning"
	},
	-- 传入连接
	inbound = (local_port ~= "0") and {
		-- listening
		port = tonumber(local_port),
		protocol = "dokodemo-door",
		settings = {network = proto, followRedirect = true},
		sniffing = {enabled = true, destOverride = {"http", "tls"}}
	} or nil,
	-- 开启 socks 代理
	inboundDetour = (proto:find("tcp") and socks_port ~= "0") and {
		{
			-- socks
			protocol = "socks",
			port = tonumber(socks_port),
			settings = {auth = "noauth", udp = true}
		}
	} or nil,
	-- 传出连接
	outbound = {
		protocol = server.v2ray_protocol,
		settings = outbound_settings,
		-- 底层传输配置
		streamSettings = {
			network = server.transport or "tcp",
			security = (server.tls == '1') and "tls" or (server.reality == '1') and "reality" or nil,
			tlsSettings = (server.tls == '1') and {
				-- tls
				alpn = server.tls_alpn,
				fingerprint = server.fingerprint,
				allowInsecure = (server.insecure == "1"),
				serverName = server.tls_host,
				certificates = server.certificate and {
					usage = "verify",
					certificateFile = server.certpath
				} or nil
			} or nil,
			realitySettings = (server.reality == '1') and {
				show = false,
				publicKey = server.reality_publickey,
				shortId = server.reality_shortid,
				spiderX = server.reality_spiderx,
				fingerprint = server.fingerprint,
				serverName = server.tls_host
			} or nil,
			tcpSettings = (server.transport == "tcp" and server.tcp_guise == "http") and {
				-- tcp
				header = {
					type = server.tcp_guise,
					request = {
						-- request
						path = {server.http_path} or {"/"},
						headers = {Host = {server.http_host} or {}}
					}
				}
			} or nil,
			kcpSettings = (server.transport == "kcp") and {
				mtu = tonumber(server.mtu),
				tti = tonumber(server.tti),
				uplinkCapacity = tonumber(server.uplink_capacity),
				downlinkCapacity = tonumber(server.downlink_capacity),
				congestion = (server.congestion == "1") and true or false,
				readBufferSize = tonumber(server.read_buffer_size),
				writeBufferSize = tonumber(server.write_buffer_size),
				header = {type = server.kcp_guise},
				seed = server.seed or nil
			} or nil,
			wsSettings = (server.transport == "ws") and (server.ws_path or server.ws_host or server.tls_host) and {
				-- ws
				headers = (server.ws_host or server.tls_host) and {
					-- headers
					Host = server.ws_host or server.tls_host
				} or nil,
				path = server.ws_path,
				maxEarlyData = tonumber(server.ws_ed) or nil,
				earlyDataHeaderName = server.ws_ed_header or nil
			} or nil,
			httpSettings = (server.transport == "h2") and {
				-- h2
				path = server.h2_path or "",
				host = {server.h2_host} or nil,
				read_idle_timeout = tonumber(server.read_idle_timeout) or nil,
				health_check_timeout = tonumber(server.health_check_timeout) or nil
			} or nil,
			quicSettings = (server.transport == "quic") and {
				-- quic
				security = server.quic_security,
				key = server.quic_key,
				header = {type = server.quic_guise}
			} or nil,
			grpcSettings = (server.transport == "grpc") and {
				-- grpc
				serviceName = server.serviceName or "",
				multiMode = (server.grpc_mode == "multi") and true or false,
				idle_timeout = tonumber(server.idle_timeout) or nil,
				health_check_timeout = tonumber(server.health_check_timeout) or nil,
				permit_without_stream = (server.permit_without_stream == "1") and true or nil,
				initial_windows_size = tonumber(server.initial_windows_size) or nil
			} or nil
		},
		mux = (server.mux == "1" and server.transport ~= "grpc") and {
			-- mux
			enabled = true,
			concurrency = tonumber(server.concurrency)
		} or nil
	} or nil
}

local config = {}
function config:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end
function config:handleIndex(index)
	local switch = {
		v2ray = function()
			print(jsonStringify(Xray))
		end
	}
	if switch[index] then
		switch[index]()
	end
end
local f = config:new()
f:handleIndex("v2ray")

