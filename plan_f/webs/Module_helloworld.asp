<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<html xmlns:v>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
<meta HTTP-EQUIV="Expires" CONTENT="-1">
<link rel="shortcut icon" href="images/favicon.png">
<link rel="icon" href="images/favicon.png">
<title id="ss_title">【ShadowSocksR Plus】</title>
<link rel="stylesheet" type="text/css" href="index_style.css">
<link rel="stylesheet" type="text/css" href="form_style.css">
<link rel="stylesheet" type="text/css" href="usp_style.css">
<link rel="stylesheet" type="text/css" href="css/element.css">
<link rel="stylesheet" type="text/css" href="/device-map/device-map.css">
<link rel="stylesheet" type="text/css" href="/js/table/table.css">
<link rel="stylesheet" type="text/css" href="/res/layer/theme/default/layer.css">
<link rel="stylesheet" type="text/css" href="/res/softcenter.css">
<link rel="stylesheet" type="text/css" href="/res/helloworld.css">
<script language="JavaScript" type="text/javascript" src="/js/jquery.js"></script>
<script language="JavaScript" type="text/javascript" src="/res/layer/layer.js"></script>
<script language="JavaScript" type="text/javascript" src="/js/httpApi.js"></script>
<script language="JavaScript" type="text/javascript" src="/state.js"></script>
<script language="JavaScript" type="text/javascript" src="/popup.js"></script>
<script language="JavaScript" type="text/javascript" src="/help.js"></script>
<script language="JavaScript" type="text/javascript" src="/general.js"></script>
<script language="JavaScript" type="text/javascript" src="/client_function.js"></script>
<script language="JavaScript" type="text/javascript" src="/js/table/table.js"></script>
<script language="JavaScript" type="text/javascript" src="/res/ss-menu.js"></script>
<script language="JavaScript" type="text/javascript" src="/res/softcenter.js"></script>
<script language="JavaScript" type="text/javascript" src="/res/tablednd.js"></script>
<script>
var PKG_TYPE="full";
var PKG_ARCH="unknown"
var pkg_name="helloworld_" + PKG_ARCH + "_" + PKG_TYPE
var db_ss = {};
var dbus = {};
var confs = {};
var scarch;
var node_max = 0;
var node_nu = 0;
var ss_nodes = [];
var nodeN = 15;
var trsH = 36;
var nodeH;
var node_idx;
var sel_mode;
var edit_id;
var isMenuopen = 0;
var _responseLen;
var noChange = 0;
var noChange2 = 0;
var noChange_status = 0;
var poped = 0;
var x = 5;
var ping_result = "";
var save_flag = "";
var submit_flag = "0";
var STATUS_FLAG;
var refreshRate;
var ws_flag;
var ws_enable = 0;
var hostname = document.domain;
var stop_scroll = 0;
var ph_v2ray = "# 此处填入v2ray json，内容可以是标准的也可以是压缩的&#10;# 请保证你json内的outbound配置正确！！！&#10;# ------------------------------------&#10;# 同样支持vmess://链接填入，格式如下：&#10;vmess://ew0KICAidiI6ICIyIiwNCiAgInBzIjogIjIzMyIsDQogICJhZGQiOiAiMjMzLjIzMy4yMzMuMjMzIiwNCiAgInBvcnQiOiAiMjMzIiwNCiAgImlkIjogImFlY2EzYzViLTc0NzktNDFjMy1hMWUzLTAyMjkzYzg2Y2EzOCIsDQogICJhaWQiOiAiMjMzIiwNCiAgIm5ldCI6ICJ3cyIsDQogICJ0eXBlIjogIm5vbmUiLA0KICAiaG9zdCI6ICJ3d3cuMjMzLmNvbSIsDQogICJwYXRoIjogIi8yMzMiLA0KICAidGxzIjogInRscyINCn0="
var option_modes = [["1", "gfwlist模式"], ["2", "大陆白名单模式"], ["3", "游戏模式"], ["5", "全局代理模式"], ["6", "回国模式"]];
var option_method = [ "none", "table", "rc4", "rc4-md5", "rc4-md5-6", "aes-128-gcm", "aes-192-gcm", "aes-256-gcm", "aes-128-cfb", "aes-192-cfb", "aes-256-cfb", "aes-128-ctr", "aes-192-ctr", "aes-256-ctr", "camellia-128-cfb", "camellia-192-cfb", "camellia-256-cfb", "bf-cfb", "cast5-cfb", "idea-cfb", "rc2-cfb", "seed-cfb", "salsa20",  "chacha20",  "chacha20-ietf" ];
var option_method_aead = [ "none", "plain", "aes-128-gcm", "aes-192-gcm", "aes-256-gcm", "chacha20-ietf-poly1305", "xchacha20-ietf-poly1305", "2022-blake3-aes-128-gcm", "2022-blake3-aes-256-gcm", "2022-blake3-chacha20-poly1305" ];
var option_protocals = [ "origin", "verify_deflate", "auth_sha1_v4", "auth_aes128_md5", "auth_aes128_sha1", "auth_chain_a", "auth_chain_b", "auth_chain_c", "auth_chain_d", "auth_chain_e", "auth_chain_f" ];
var option_obfs = ["plain", "http_simple", "http_post", "random_head", "tls1.2_ticket_auth"];
var option_v2enc = [["none", "不加密"], ["auto", "自动"], ["zero", "zero"], ["aes-128-gcm", "aes-128-gcm"], ["chacha20-poly1305", "chacha20-poly1305"]];
var option_headtcp = [["none", "不伪装"], ["http", "伪装http"]];
var option_headkcp = [["none", "不伪装"], ["srtp", "伪装视频通话(srtp)"], ["utp", "伪装BT下载(uTP)"], ["wechat-video", "伪装微信视频通话"], ["dtls", "DTLS 1.2"], ["wireguard", "WireGuard"]];
var tls_flows = [["xtls-rprx-vision", "xtls-rprx-vision"], ["xtls-rprx-vision-udp443", "xtls-rprx-vision-udp443"]];
var option_hy2_obfs = [["0", "停用"], ["1", "salamander"]];	//helloworld-full
var heart_count = 1;
const pattern=/[`~!@#$^&*()=|{}':;'\\\[\]\.<>\/?~！@#￥……&*（）——|{}%【】'；：""'。，、？\s]/g;
if(PKG_TYPE == "full"){
	ws_enable = 1;
}
function init() {
	show_menu(menu_hook);
	get_dbus_data();
	try_ws_connect();
}
function try_ws_connect(){
	if (ws_enable != 1){
		ws_flag = 0;
		return false;
	}
	if (window.location.protocol != "http:"){
		ws_flag = 0;
		return false;
	}
	ws_test = new WebSocket("ws://" + hostname + ":8030/");
	ws_test.onopen = function() {
		ws_test.send("echo ws_ok");
	};
	ws_test.onerror = function(event) {
		ws_flag = 2;
		//console.log('ws_test failed!');
	};
	ws_test.onmessage = function(event) {
		ws_flag = 1;
		//console.log('ws_test message_ok!');
		ws_test.close();
	};
}
function refresh_dbss() {
	$.ajax({
		type: "GET",
		url: "/_api/ssconf",
		dataType: "json",
		async: false,
		success: function(data) {
			db_ss = data.result[0];
			confdecode(db_ss);
			generate_node_info();
		}
	});
}

function get_heart_beat() {
	$.ajax({
		type: "GET",
		url: "/_api/ssconf_heart_beat",
		dataType: "json",
		async: false,
		success: function(data) {
			heart_beat = data.result[0]["ssconf_heart_beat"];
			if(heart_beat == "1"){
				if (heart_count == "1"){
					var dbus_post = {};
					dbus_post["ssconf_heart_beat"] = "0";
					push_data("dummy_script.sh", "", dbus_post, "2");
					return true;
				}else{
					var dbus_post = {};
					dbus_post["ssconf_heart_beat"] = "0";
					push_data("dummy_script.sh", "", dbus_post, "2");
					require(['/res/layer/layer.js'], function(layer) {
						layer.confirm('<li>ShadowSocksR Plus插件页面需要刷新！</li><br /><li>由于故障转移功能已经在后台切换了节点，为了保证页面显示正确配置！需要刷新此页面！</li><br /><li>确定现在刷新吗？</li>', {
							time: 3e4,
							shade: 0.8
						}, function(index) {
							layer.close(index);
							refreshpage();
						}, function(index) {
							layer.close(index);
							return false;
						});
					});
				}
			}
		}
	});
	heart_count++
	setTimeout("get_heart_beat();", 10000);
}
function get_dbus_data() {
	$.ajax({
		type: "GET",
		url: "/_api/ssconf,softcenter_arch",
		dataType: "json",
		cache:false,
		async: false,
		success: function(data) {
			db_ss = data.result[0];
			db_scarch = data.result[1];
			confdecode(db_ss);
			generate_node_info();
			refresh_options();
			refresh_html();
			toggle_func();
			ss_node_sel();
			version_show();
			get_ss_status();
			get_heart_beat();
			message_show();
		},
		error: function(XmlHttpRequest, textStatus, errorThrown){
			console.log(XmlHttpRequest.responseText);
			alert("skipd数据读取错误！错误信息：" + XmlHttpRequest.responseText);
		}
		,timeout: 0
	});
}
function confdecode(obj) {
	// 统计节点信息
	ss_nodes = [];
	for (var field in obj) {
		var arr = field.split("ssconf_basic_json_");
		if(arr[0] == ""){
			ss_nodes.push(arr[1]);
		}
	}
	ss_nodes = ss_nodes.sort(compare);
	node_nu = ss_nodes.length;
	node_max = ss_nodes.length > 0 ? Math.max.apply(null, ss_nodes) : 0;
	node_idx = $.inArray(obj["ssconf_basic_node"], ss_nodes) + 1;
	for (var i = 1; i <= node_max; i++){
		if(typeof(obj["ssconf_basic_json_" + i]) != "undefined")//跳过已删除节点，等待后面修正排序
			obj["ssconf_basic_json_" + i] =  Base64.decode(obj["ssconf_basic_json_" + i]);
		else if(i == obj["ssconf_basic_node"]){//跳到其他可用节点
			for (var j = 1; j <= node_max; j++){
				if(typeof(obj["ssconf_basic_json_" + j]) != "undefined"){
					obj["ssconf_basic_node"] = j+"";
					break;
				}
			}	
		}
	}
}
function conf2obj(obj, p) {
	var c = obj["json"] ? JSON.parse(obj["json"]) : "";
	var type = c.v2ray_protocol;
	E(p + "mode").value = obj["mode"];
	E(p + "server").value = c.server || "";
	E(p + "port").value = c.server_port || "";
	E(p + "password").value = c.password || "";
	E(p + "v2_protocol").value = c.v2ray_protocol;
	E(p + "alias").value = c.alias || "";
	if(type == "shadowsocks"){
		E(p + "type").value = "0";
		E(p + "method_ss").value = c.encrypt_method_ss || "none";
		E(p + "plugin").value = c.plugin || "none";
		E(p + "plugin_opts").value = c.plugin_opts || "";
		E(p + "v2_tls").value = c.tls || "0";
		E(p + "v2_tls").checked =  E(p + "v2_tls").value != 0;
		E(p + "tls_host").value = c.tls_host || "";
		E(p + "v2_ivCheck").value = c.ivCheck || "1";
	}else if(type == "shadowsocksr"){
		E(p + "type").value = "1";
		E(p + "protocol").value = c.protocol || "origin";
		E(p + "protocol_param").value = c.protocol_param;
		E(p + "method").value = c.encrypt_method || "none";
		E(p + "obfs").value = c.obfs || "plain";
		E(p + "obfs_param").value = c.obfs_param;
	}else if(type == "vmess" || type == "vless"){
		E(p + "type").value = "2";
		var transport = c.transport || "tcp";
		E(p + "v2_vmess_id").value = c.vmess_id;
		if(c.v2ray_protocol == "vmess"){
			E(p + "v2_alter_id").value = c.alter_id;
			E(p + "v2_security").value = c.security || "auto";
		}
		if(c.v2ray_protocol == "vless"){
			E(p + "v2_encryption").value = c.vless_encryption;
			E(p + "v2_reality").value = c.reality || "0";
			E(p + "v2_reality").checked =  E(p + "v2_reality").value != 0;
			E(p + "v2_tls_flow").value = c.tls_flow || "xtls-rprx-vision";
			if(E(p + "v2_reality").checked){
				E(p + "v2_reality_publickey").value = c.reality_publickey || "";
				E(p + "v2_reality_shortid").value = c.reality_shortid || "";
				E(p + "v2_reality_spiderx").value = c.reality_spiderx || "";
			}
		}
		E(p + "v2_transport").value = transport;
		if(E(p + "v2_reality").checked == false){
			E(p + "v2_mux").value = c.mux || "0";
			E(p + "v2_mux").checked =  E(p + "v2_mux").value != 0;
			E(p + "v2_concurrency").value = c.concurrency || "4";
		}
		E(p + "v2_tls").value = c.tls || "0";
		E(p + "v2_tls").checked =  E(p + "v2_tls").value != 0;
		if(E(p + "v2_tls").checked || E(p + "v2_reality").checked){
			E(p + "tls_host").value = c.tls_host || "";
			E(p + "v2_fingerprint").value = c.fingerprint || "disable";
		}
		E(p + "insecure").value = c.insecure || "0";
		E(p + "insecure").checked =  E(p + "insecure").value != 0;
		if (transport == "tcp") {
			E(p + "v2_tcp_guise").value = c.tcp_guise || "none";
			if(c.tcp_guise == "http"){
				E(p + "v2_http_host").value = c.http_host || "";;
				E(p + "v2_http_path").value = c.http_path || "";;
			}
		} else if (transport == "kcp") {
			E(p + "v2_kcp_guise").value = c.kcp_guise || "none";
			E(p + "v2_mtu").value = c.mtu || "1350";
			E(p + "v2_tti").value = c.tti || "50";
			E(p + "uplink_capacity").value = c.uplink_capacity || "5";
			E(p + "downlink_capacity").value = c.downlink_capacity || "20";
			E(p + "v2_read_buffer_size").value = c.read_buffer_size || "2";
			E(p + "v2_write_buffer_size").value = c.write_buffer_size || "2";
			E(p + "v2_seed").value = c.seed || "";
			E(p + "v2_congestion").value = c.congestion || "0";
			E(p + "v2_congestion").checked =  E(p + "v2_congestion").value != 0;
		} else if (transport == "ws") {
			E(p + "v2_http_host").value = c.ws_host || "";;
			E(p + "v2_http_path").value = c.ws_path || "";;
		} else if (transport == "h2") {
			E(p + "v2_http_host").value = c.h2_host || "";;
			E(p + "v2_http_host").value = c.h2_path || "";;
			E(p + "v2_health_check").value = c.health_check || "0";
			E(p + "v2_health_check").checked =  E(p + "v2_health_check").value != 0;
			if(E(p + "v2_health_check").value != 0){
				E(p + "v2_idle_timeout").value = c.read_idle_timeout || "60";
				E(p + "v2_health_check_timeout").value = c.health_check_timeout || "20";
			}
		} else if (transport == "quic") {
			E(p + "v2_quic_guise").value = c.quic_guise || "none";
			E(p + "v2_quic_key").value = c.quic_key;
			E(p + "v2_quic_security").value = c.quic_security || "none";
		} else if (transport == "grpc") {
			E(p + "v2_serviceName").value = c.serviceName;
			E(p + "v2_grpc_mode").value = c.grpc_mode || "gun";
			E(p + "v2_initial_windows_size").value = c.initial_windows_size || "0";
			E(p + "v2_health_check").value = c.health_check || "0";
			E(p + "v2_health_check").checked =  E(p + "v2_health_check").value != 0;	
			if(E(p + "v2_health_check").value != 0){
				E(p + "v2_idle_timeout").value = c.idle_timeout || "60";
				E(p + "v2_health_check_timeout").value = c.health_check_timeout || "20";
				E(p + "v2_permit_without_stream").value = c.permit_without_stream || "0";
			}			
		}
	}else if(type == "trojan"){
		E(p + "type").value = "3";
		E(p + "insecure").value = c.insecure || "0";
		E(p + "insecure").checked =  E(p + "insecure").value != 0;
		E(p + "v2_tls").value = c.tls || "0";
		E(p + "v2_tls").checked =  E(p + "v2_tls").value != 0;
		E(p + "tls_host").value = c.tls_host || "";
		if(E(p + "v2_tls").checked == true)
			E(p + "tls_sessionTicket").value = c.tls_sessionTicket || "0";
	}else if(type == "hysteria"){	//helloworld-full
		E(p + "type").value = "4";	//helloworld-full
		E(p + "hy2_auth").value = c.hy2_auth || "";	//helloworld-full
		E(p + "flag_obfs").value = c.flag_obfs || "0";	//helloworld-full
		E(p + "salamander").value = c.salamander || "cry_me_a_r1ver";	//helloworld-full
		E(p + "tls_host").value = c.tls_host || "";	//helloworld-full
		E(p + "insecure").value = c.insecure || "0";	//helloworld-full
		E(p + "insecure").checked =  E(p + "insecure").value != 0;	//helloworld-full
		E(p + "fast_open").value = c.fast_open || "0";	//helloworld-full
		E(p + "fast_open").checked =  E(p + "fast_open").value != 0;	//helloworld-full
		E(p + "uplink_capacity").value = c.uplink_capacity || "5";	//helloworld-full
		E(p + "downlink_capacity").value = c.downlink_capacity || "20";	//helloworld-full
	}
}
function ssconf_node2obj(node_sel) {
	var obj = {};
	obj["json"] = db_ss["ssconf_basic_json_" + node_sel] || "";
	obj["mode"] = db_ss["ssconf_basic_mode_" + node_sel] || "";
	return obj;
}
function ss_node_sel() {
	var p = "sstable_";
	var node_sel = E("sstable_node").value;
	var obj = ssconf_node2obj(node_sel);
	conf2obj(obj, p);
	verifyFields();
}
function refresh_options() {
	if (node_max == 0) return false;
	var option = $("#sstable_node");
	var option1 = $("#ssconf_basic_ping_node");
	var option2 = $("#ssconf_failover_s4_3");
	var option3 = $("#sstable_type");

	option.find('option').remove().end();
	option1.find('option').remove().end();
	option2.find('option').remove().end();
	
	option1.append('<option value="off">关闭ping功能</option>');
	option1.append('<option value="0" selected>全部节点</option>');
	for (var field in confs) {
		var c = confs[field];
		var j = JSON.parse(c["json"]);
		option1.append('<option value="' + field + '">' + j.alias + '</option>');
	}

	for (var field in confs) {
		var c = confs[field];
		var j = JSON.parse(c["json"]);
		option2.append('<option value="' + field + '">' + j.alias + '</option>');
	}

	for (var field in confs) {
		var c = confs[field];
		var j = JSON.parse(c["json"]);
		if (j.v2ray_protocol == "shadowsocksr") {
			option.append($("<option>", {
				value: field,
				text: "【SSR】" + j.alias
			}));
		} else if(j.v2ray_protocol == "shadowsocks") {
			option.append($("<option>", {
				value: field,
				text: "【SS】" + j.alias
			}));
		} else if(j.v2ray_protocol == "vmess" || j.v2ray_protocol == "vless") {
			option.append($("<option>", {
				value: field,
				text: "【V2Ray】" + j.alias
			}));
		} else if(j.v2ray_protocol == "trojan") {
			option.append($("<option>", {
				value: field,
				text: "【TROJAN】" + j.alias
			}));
		}else if(j.v2ray_protocol == "hysteria"){
			option.append($("<option>", {
				value: field,
				text: "【Hysteria】" + j.alias
			}));
		}
	}
	if(typeof(db_ss["ssconf_basic_node"]) != "undefined" && parseInt(db_ss["ssconf_basic_node"]) <= node_max)
		option.val(db_ss["ssconf_basic_node"]);
	else
		option.val("1");
	option1.val(db_ss["ssconf_basic_ping_node"]||"0");
	option2.val((db_ss["ssconf_failover_s4_3"])||"1");
	var j = db_ss["ssconf_basic_json_" + E("sstable_node").value].v2ray_protocol;
	if(j == "shadowsocks")
		option3.val("0");
	else if(j == "shadowsocksr")
		option3.val("1");
	else if(j == "vmess" || j == "vless")
		option3.val("2");
	else if(j == "trojan")
		option3.val("3");
	else if(j == "hysteria")
		option3.val("4");
}
function save() {
	var tmp_db = {}
	submit_flag="1";
	var node_sel = E("sstable_node").value;
	var node_type = E("sstable_type").value;
	dbus["ssconf_basic_node"] = node_sel;
	E("ss_state2").innerHTML = "国外连接 - " + "Waiting...";
	E("ss_state3").innerHTML = "国内连接 - " + "Waiting...";
	//key define
	var params_input = ["ssconf_failover_s1", "ssconf_failover_s2_1", "ssconf_failover_s2_2", "ssconf_failover_s3_1", "ssconf_failover_s3_2", "ssconf_failover_s4_1", "ssconf_failover_s4_2", "ssconf_failover_s4_3", "ssconf_failover_s5", "ssconf_basic_interval", "ssconf_basic_row", "ssconf_basic_ping_node", "ssconf_basic_ping_method", "ssconf_dns_china", "ssconf_foreign_dns", "ssconf_basic_kcp_lserver", "ssconf_basic_kcp_lport", "ssconf_basic_kcp_server", "ssconf_basic_kcp_port", "ssconf_basic_kcp_parameter", "ssconf_basic_rule_update", "ssconf_basic_rule_update_time", "ssconf_subscribe_mode", "ssconf_basic_online_links_goss", "ssconf_basic_node_update", "ssconf_basic_node_update_day", "ssconf_basic_node_update_hr", "ssconf_basic_exclude", "ssconf_basic_include", "ssconf_base64_links", "ssconf_acl_default_port", "ssconf_acl_default_mode", "ssconf_basic_kcp_password", "ssconf_reboot_check", "ssconf_basic_week", "ssconf_basic_day", "ssconf_basic_inter_min", "ssconf_basic_inter_hour", "ssconf_basic_inter_day", "ssconf_basic_inter_pre", "ssconf_basic_time_hour", "ssconf_basic_time_min", "ssconf_basic_tri_reboot_time", "ssconf_basic_server_resolver"];
	var params_check = ["ssconf_failover_enable", "ssconf_failover_c1", "ssconf_failover_c2", "ssconf_failover_c3", "ssconf_basic_tablet", "ssconf_basic_netflix_enable", "ssconf_basic_dragable", "ssconf_basic_enable", "ssconf_basic_gfwlist_update", "ssconf_basic_tfo", "ssconf_basic_chnroute_update", "ssconf_basic_cdn_update", "ssconf_basic_dns_hijack", "ssconf_basic_mcore"];
	var params_base64_a = ["ssconf_dnsmasq", "ssconf_wan_white_ip", "ssconf_wan_white_domain", "ssconf_wan_black_ip", "ssconf_wan_black_domain", "ssconf_online_links"];
	var params_base64_b = ["ssconf_basic_custom"];

	// collect data from input
	for (var i = 0; i < params_input.length; i++) {
		if (E(params_input[i])) {
			dbus[params_input[i]] = E(params_input[i]).value;
		}
	}
	dbus["ssconf_basic_exclude"] = E("ssconf_basic_exclude").value.replace(pattern,"") || "";
	dbus["ssconf_basic_include"] = E("ssconf_basic_include").value.replace(pattern,"") || "";
	// collect data from checkbox
	for (var i = 0; i < params_check.length; i++) {
		dbus[params_check[i]] = E(params_check[i]).checked ? '1' : '0';
	}
	// data need base64 encode:format a with "."
	for (var i = 0; i < params_base64_a.length; i++) {
		dbus[params_base64_a[i]] = E(params_base64_a[i]).value.indexOf(".") != -1 ? Base64.encode(E(params_base64_a[i]).value):"";
	}
	// data need base64 encode, format b with plain text
	for (var i = 0; i < params_base64_b.length; i++) {
		dbus[params_base64_b[i]] = Base64.encode(E(params_base64_b[i]).value);
	}
	// collect values in acl table
	if(E("ACL_table")){
		var tr = E("ACL_table").getElementsByTagName("tr");
		for (var i = 1; i < tr.length - 1; i++) {
			var rowid = tr[i].getAttribute("id").split("_")[2];
			if (E("ssconf_acl_name_" + i)){
				dbus["ssconf_acl_name_" + rowid] = E("ssconf_acl_name_" + rowid).value;
				dbus["ssconf_acl_mode_" + rowid] = E("ssconf_acl_mode_" + rowid).value;
				dbus["ssconf_acl_port_" + rowid] = E("ssconf_acl_port_" + rowid).value;
			}
		}
	}
	tmp_db.alias = E("sstable_alias").value;
	tmp_db.server = E("sstable_server").value;
	tmp_db.server_port = E("sstable_port").value;
	tmp_db.v2ray_protocol = E("sstable_v2_protocol").value;
	tmp_db.type = "v2ray";
	if(node_type == 0){
		tmp_db.password = E("sstable_password").value;
		tmp_db.encrypt_method_ss = E("sstable_method_ss").value;
		tmp_db.plugin = E("sstable_plugin").value;
		tmp_db.plugin_opts = E("sstable_plugin_opts").value;
		tmp_db.tls = E("sstable_v2_tls").checked ? '1' : '0';
		tmp_db.tls_host = E("sstable_tls_host").value;
		tmp_db.ivCheck = E("sstable_v2_ivCheck").value
	}else if(node_type == 1){
		tmp_db.password = E("sstable_password").value;
		tmp_db.encrypt_method = E("sstable_method").value;
		tmp_db.protocol = E("sstable_protocol").value;
		tmp_db.protocol_param = E("sstable_protocol_param").value;
		tmp_db.obfs = E("sstable_obfs").value;
		tmp_db.obfs_param = E("sstable_obfs_param").value;
	}else if(node_type == 2){
		tmp_db.transport = E("sstable_v2_transport").value;
		tmp_db.vmess_id = E("sstable_v2_vmess_id").value;
		if(tmp_db.v2ray_protocol == "vmess"){
			tmp_db.alter_id = E("sstable_v2_alter_id").value;
			tmp_db.security = E("sstable_v2_security").value;
		}
		if(tmp_db.v2ray_protocol == "vless"){
			tmp_db.vless_encryption = E("sstable_v2_encryption").value;
			tmp_db.reality = E("sstable_v2_reality").checked ? '1' : '0';
			tmp_db.tls_flow = E("sstable_v2_tls_flow").value;
			if(E("sstable_v2_reality").checked == true){
					tmp_db.reality_publickey = E("sstable_v2_reality_publickey").value;
					tmp_db.reality_shortid = E("sstable_v2_reality_shortid").value;
					tmp_db.reality_spiderx = E("sstable_v2_reality_spiderx").value;
			}
		}
		tmp_db.tls = E("sstable_v2_tls").checked ? '1' : '0';
		if(E("sstable_v2_reality").checked == false){
			tmp_db.mux = E("sstable_v2_mux").checked ? '1' : '0';
			tmp_db.concurrency = E("sstable_v2_concurrency").value;
		}
		if(E("sstable_v2_tls").checked || E("sstable_v2_reality").checked){
			tmp_db.tls_host = E("sstable_tls_host").value;
			tmp_db.fingerprint = E("sstable_v2_fingerprint").value;
		}
		tmp_db.insecure = E("sstable_insecure").checked ? '1' : '0';
		if (tmp_db.transport == "tcp") {
			tmp_db.tcp_guise = E("sstable_v2_tcp_guise").value;
			if(tmp_db.tcp_guise == "http"){
				tmp_db.http_host = E("sstable_v2_http_host").value;
				tmp_db.http_path = E("sstable_v2_http_path").value;
			}
		} else if (tmp_db.transport == "kcp") {
			tmp_db.kcp_guise = E("sstable_v2_kcp_guise").value;
			tmp_db.mtu = E("sstable_v2_mtu").value;
			tmp_db.tti = E("sstable_v2_tti").value;
			tmp_db.uplink_capacity = E("sstable_uplink_capacity").value;
			tmp_db.downlink_capacity = E("sstable_downlink_capacity").value;
			tmp_db.read_buffer_size = E("sstable_v2_read_buffer_size").value;
			tmp_db.write_buffer_size = E("sstable_v2_write_buffer_size").value;
			tmp_db.seed = E("sstable_v2_seed").value;
			tmp_db.congestion = E("sstable_v2_congestion").checked ? '1' : '0';
		} else if (tmp_db.transport == "ws") {
			tmp_db.ws_host = E("sstable_v2_http_host").value;
			tmp_db.ws_path = E("sstable_v2_http_path").value;
		} else if (tmp_db.transport == "h2") {
			tmp_db.h2_host = E("sstable_v2_http_host").value;
			tmp_db.h2_path = E("sstable_v2_http_path").value;
			tmp_db.health_check = E("sstable_v2_health_check").checked ? '1' : '0';
			if(E("sstable_v2_health_check").checked){
				tmp_db.read_idle_timeout = E("sstable_v2_idle_timeout").value;
				tmp_db.health_check_timeout = E("sstable_v2_health_check_timeout").value;
			}
		} else if (tmp_db.transport == "quic") {
			tmp_db.quic_guise = E("sstable_v2_quic_guise").value;
			tmp_db.quic_key = E("sstable_v2_quic_key").value;
			tmp_db.quic_security = E("sstable_v2_quic_security").value;
		} else if (tmp_db.transport == "grpc") {
			tmp_db.serviceName = E("sstable_v2_serviceName").value;
			tmp_db.grpc_mode = E("sstable_v2_grpc_mode").value;
			tmp_db.initial_windows_size = E("sstable_v2_initial_windows_size").value;
			tmp_db.health_check = E("sstable_v2_health_check").checked ? '1' : '0';
			if(E("sstable_v2_health_check").checked){
				tmp_db.idle_timeout = E("sstable_v2_idle_timeout").value;
				tmp_db.health_check_timeout = E("sstable_v2_health_check_timeout").value;
				tmp_db.permit_without_stream = E("sstable_v2_permit_without_stream").value;
			}			
		}
	}else if(node_type == 3){
		tmp_db.password = E("sstable_password").value;
		tmp_db.tls = E("sstable_v2_tls").checked ? '1' : '0';
		if(E("sstable_v2_tls").checked){
			tmp_db.tls_host = E("sstable_tls_host").value;
			tmp_db.insecure = E("sstable_insecure").checked ? '1' : '0';
		}
		if(E("sstable_v2_tls").checked)
			tmp_db.tls_sessionTicket = E("sstable_tls_sessionTicket").value;
	}else if(node_type == 4){	//helloworld-full
		tmp_db.v2ray_protocol = "hysteria";	//helloworld-full
		tmp_db.type = "hysteria";	//helloworld-full
		tmp_db.hy2_auth = E("sstable_hy2_auth").value;	//helloworld-full
		tmp_db.tls_host = E("sstable_tls_host").value;	//helloworld-full
		tmp_db.insecure = E("sstable_insecure").checked ? '1' : '0';	//helloworld-full
		tmp_db.fast_open = E("sstable_fast_open").checked ? '1' : '0';	//helloworld-full
		tmp_db.flag_obfs = E("sstable_flag_obfs").value;	//helloworld-full
		if(E("sstable_flag_obfs").value == "1")	//helloworld-full
			tmp_db.salamander = E("sstable_salamander").value;	//helloworld-full
		tmp_db.uplink_capacity = E("sstable_uplink_capacity").value;	//helloworld-full
		tmp_db.downlink_capacity = E("sstable_downlink_capacity").value;	//helloworld-full
	}
	dbus["ssconf_basic_json_" + node_sel] = tmp_db;
	dbus["ssconf_basic_mode_" + node_sel] = E("sstable_mode").value;

	dbus["ssconf_basic_use_kcp_" + node_sel] = E("ssconf_basic_use_kcp").checked ? '1' : '0';
	// show different title when subscribe
	if(E("ssconf_basic_enable").checked){
		var sel_mode = E("sstable_mode").value;
		if (sel_mode == "1") {
			db_ss["ssconf_basic_action"] = "1";
		} else if (sel_mode == "2") {
			db_ss["ssconf_basic_action"] = "2";
		} else if (sel_mode == "3") {
			db_ss["ssconf_basic_action"] = "3";
		} else if (sel_mode == "5") {
			db_ss["ssconf_basic_action"] = "5";
		} else if (sel_mode == "6") {
			db_ss["ssconf_basic_action"] = "6";
		}
	}else{
		db_ss["ssconf_basic_action"] = "0";
	}
	//---------------------------------------------------------------
	var post_dbus = compfilter(db_ss, dbus);
	//console.log("post_dbus", post_dbus);
	post_dbus["ssconf_basic_json_" + node_sel] = Base64.encode(JSON.stringify(post_dbus["ssconf_basic_json_" + node_sel]));
	dbus["ssconf_basic_jsontype_" + node_sel] = dbus["ssconf_basic_jsontype_" + node_sel] || "0";
	if(E("ssconf_basic_enable").checked){
		if(ws_flag == 1){
			//console.log("push_data_ws");
			push_data_ws("ss_config.sh", "start",  post_dbus);
		}else{
			//console.log("push_data_httpd");
			push_data("ss_config.sh", "start",  post_dbus);
		}
	}else{
		if(ws_flag == 1){
			push_data_ws("ss_config.sh", "stop",  post_dbus);
		}else{
			push_data("ss_config.sh", "stop",  post_dbus);
		}
	}
}
function push_data_ws(script, arg, obj, flag){
	// just push data, show log through ws
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "dummy_script.sh", "params":[], "fields": obj};
	$.ajax({
		type: "POST",
		cache:false,
		url: "/_api/",
		data: JSON.stringify(postData),
		dataType: "json",
		success: function(response){
			if(response.result == id){
				// run command through ws
				ws = new WebSocket("ws://" + hostname + ":8030/");
				ws.onopen = function() {
					//console.log('ws：成功建立websocket链接，开始获取启动日志...');
					ws.send(". " + script + " " + arg);
					showSSLoadingBar();
				};
				//ws.onclose = function() {
				//	console.log('ws： DISCONNECT');
				//};
				ws.onerror = function(event) {
					// fallback to httpd method
					//console.log('WS Error: ' + event.data);
					push_data(script, arg, obj, flag);
				};
				ws.onmessage = function(event) {
					if(event.data != "XU6J03M6"){
						E('log_content3').value += event.data + '\n';
					}else{
						E("ok_button").style.display = "";
						count_down_close();
						ws.close();
					}
					E("log_content3").scrollTop = E("log_content3").scrollHeight;
				};
			}
		}
	});
}
function push_data(script, arg, obj, flag){
	if (!flag) showSSLoadingBar();
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": script, "params":[arg], "fields": obj};
	$.ajax({
		type: "POST",
		cache:false,
		url: "/_api/",
		data: JSON.stringify(postData),
		dataType: "json",
		success: function(response){
			//返回太快变成string"1111"
			if(response.result == id || parseInt(response.result) == id){
				if(flag && flag == "1"){
					refreshpage();
				}else if(flag && flag == "2"){
					//continue;
					//do nothing
				}else{
					get_realtime_log();
				}
			}
		}
	});
}
function verifyFields(r) {
	var node_sel = E("sstable_node").value;
	var node;	//helloworld-full
	var ss_on = false;
	var ssr_on = false;
	var trojan_on = false;
	var v2ray_on = false;
	var hysteria_on = false;
	if(db_ss["ssconf_basic_json_" + node_sel])	//helloworld-full
		node = JSON.parse(db_ss["ssconf_basic_json_" + node_sel]);	//helloworld-full
	if(E("sstable_v2_protocol").value == "shadowsocks"){
		ss_on = true;
	}else if(E("sstable_v2_protocol").value == "shadowsocksr"){
		ssr_on = true;
	}else if(E("sstable_v2_protocol").value == "vmess" || E("sstable_v2_protocol").value == "vless"){
		v2ray_on = true;
	}else if(E("sstable_v2_protocol").value == "trojan"){
		trojan_on = true;
	}else if(node && node.type == "hysteria"){	//helloworld-full
		hysteria_on = true;	//helloworld-full
	}
	//ss
	elem.display(elem.parentElem('sstable_plugin', 'tr'), ss_on);
	elem.display(elem.parentElem('sstable_plugin_opts', 'tr'), (ss_on && E("sstable_plugin").value != "none"));
	//ssr
	elem.display(elem.parentElem('sstable_protocol_param', 'tr'), ssr_on);
	elem.display(elem.parentElem('sstable_protocol', 'tr'), ssr_on);
	elem.display(elem.parentElem('sstable_obfs', 'tr'), ssr_on);
	elem.display(elem.parentElem('sstable_obfs_param', 'tr'), ssr_on);
	//v2ray
	var tcp_on = E("sstable_v2_transport").value == "tcp" && v2ray_on;
	var thttp_on = tcp_on && E("sstable_v2_tcp_guise").value == "http";
	var kcp_on = E("sstable_v2_transport").value == "mkcp";
	var h2_on = E("sstable_v2_transport").value == "h2";
	var ws_on = E("sstable_v2_transport").value == "ws";
	var quic_on = E("sstable_v2_transport").value == "quic";
	var grpc_on = E("sstable_v2_transport").value == "grpc";
	var vmess_on =  E("sstable_v2_protocol").value == "vmess";
	var vless_on =  E("sstable_v2_protocol").value == "vless";
	var socks_on =  E("sstable_v2_protocol").value == "socks";
	var http_on =  E("sstable_v2_protocol").value == "http";
	elem.display(elem.parentElem('sstable_v2_vmess_id', 'tr'), (v2ray_on && (vmess_on || vless_on)));
	elem.display(elem.parentElem('sstable_v2_alter_id', 'tr'), (v2ray_on && vmess_on));
	elem.display(elem.parentElem('sstable_insecure', 'tr'), ((v2ray_on && (vmess_on || vless_on)) || hysteria_on));
	elem.display(elem.parentElem('sstable_v2_protocol', 'tr'), v2ray_on);
	elem.display(elem.parentElem('sstable_v2_security', 'tr'), (v2ray_on && vmess_on));
	elem.display(elem.parentElem('sstable_v2_transport', 'tr'), v2ray_on);
	elem.display(elem.parentElem('sstable_v2_tcp_guise', 'tr'), tcp_on);
	elem.display(elem.parentElem('sstable_v2_kcp_guise', 'tr'), kcp_on);
	elem.display(elem.parentElem('sstable_v2_http_host', 'tr'), (v2ray_on &&(ws_on || h2_on || thttp_on)));
	elem.display(elem.parentElem('sstable_v2_http_path', 'tr'), (v2ray_on &&(ws_on || h2_on || thttp_on)));
	elem.display(elem.parentElem('sstable_v2_quic_security', 'tr'), quic_on);
	elem.display(elem.parentElem('sstable_v2_mtu', 'tr'), kcp_on);
	elem.display(elem.parentElem('sstable_v2_tti', 'tr'), kcp_on);
	elem.display(elem.parentElem('sstable_uplink_capacity', 'tr'), kcp_on || hysteria_on);
	elem.display(elem.parentElem('sstable_downlink_capacity', 'tr'), kcp_on || hysteria_on);
	elem.display(elem.parentElem('sstable_v2_read_buffer_size', 'tr'), kcp_on);
	elem.display(elem.parentElem('sstable_v2_write_buffer_size', 'tr'), kcp_on);
	elem.display(elem.parentElem('sstable_v2_seed', 'tr'), kcp_on);
	elem.display(elem.parentElem('sstable_v2_congestion', 'tr'), kcp_on);
	elem.display(elem.parentElem('sstable_v2_quic_key', 'tr'), quic_on);
	elem.display(elem.parentElem('sstable_v2_quic_guise', 'tr'), quic_on);
	elem.display(elem.parentElem('sstable_v2_serviceName', 'tr'), grpc_on);
	elem.display(elem.parentElem('sstable_v2_encryption', 'tr'), (v2ray_on && vless_on));
	elem.display(elem.parentElem('sstable_v2_idle_timeout', 'tr'), (grpc_on || h2_on));
	elem.display(elem.parentElem('sstable_v2_permit_without_stream', 'tr'), grpc_on);
	elem.display(elem.parentElem('sstable_v2_health_check_timeout', 'tr'), (grpc_on || h2_on));
	elem.display(elem.parentElem('sstable_v2_initial_windows_size', 'tr'), grpc_on);
	elem.display(elem.parentElem('sstable_v2_tls', 'tr'), ((v2ray_on || ss_on || trojan_on) && E("sstable_v2_reality").checked != true));
	elem.display(elem.parentElem('sstable_v2_reality', 'tr'), (vless_on && E("sstable_v2_tls").checked != true));
	elem.display(elem.parentElem('sstable_tls_host', 'tr'), (E("sstable_v2_tls").checked || E("sstable_v2_reality").checked || hysteria_on));
	elem.display(elem.parentElem('sstable_v2_fingerprint', 'tr'), (E("sstable_v2_tls").checked || E("sstable_v2_reality").checked));
	elem.display(elem.parentElem('sstable_v2_tls_flow', 'tr'), (vless_on && E("sstable_v2_transport").value == "tcp" && (E("sstable_v2_tls").checked || E("sstable_v2_reality").checked)));
	elem.display(elem.parentElem('sstable_v2_reality_publickey', 'tr'), (vless_on && E("sstable_v2_reality").checked));
	elem.display(elem.parentElem('sstable_v2_reality_shortid', 'tr'), (vless_on && E("sstable_v2_reality").checked));
	elem.display(elem.parentElem('sstable_v2_reality_spiderx', 'tr'), (vless_on && E("sstable_v2_reality").checked));
	elem.display(elem.parentElem('sstable_v2_ivCheck', 'tr'), ss_on);
	elem.display(elem.parentElem('sstable_v2_mux', 'tr'), ((v2ray_on || ss_on || trojan_on) && E("sstable_v2_reality").checked == false));
	elem.display(elem.parentElem('sstable_v2_concurrency', 'tr'), E("sstable_v2_mux").checked);
	elem.display(elem.parentElem('sstable_tls_sessionTicket', 'tr'), (trojan_on && E("sstable_v2_tls").checked));
	//hysteria
	elem.display(elem.parentElem('sstable_hy2_auth', 'tr'), hysteria_on);	//helloworld-full
	elem.display(elem.parentElem('sstable_flag_obfs', 'tr'), hysteria_on);	//helloworld-full
	elem.display(elem.parentElem('sstable_salamander', 'tr'), (hysteria_on && E("sstable_flag_obfs").value == "1"));	//helloworld-full
	elem.display(elem.parentElem('sstable_fast_open', 'tr'), hysteria_on);	//helloworld-full

	elem.display(elem.parentElem('sstable_server', 'tr'), true);
	elem.display(elem.parentElem('sstable_port', 'tr'), true);
	elem.display(elem.parentElem('sstable_password', 'tr'), (ss_on || ssr_on || trojan_on));
	elem.display(elem.parentElem('sstable_method_ss', 'tr'), ss_on);
	elem.display(elem.parentElem('sstable_method', 'tr'), ssr_on);

	// dns pannel
	showhide("dns_plan_foreign", true);
	//node add/edit pannel
	if (save_flag == "shadowsocks") {
		showhide("ss_node_table_method_ss_tr", true);
		showhide("ss_node_table_plugin_tr", ($("#ss_node_table_mode").val() != "3"));
		showhide("ss_node_table_plugin_opts_tr", ($("#ss_node_table_mode").val() != "3" && $("#ss_node_table_plugin").val() != "none"));
		showhide("ss_node_table_v2_tls_tr", true);
		showhide("ss_node_table_v2_reality_tr", false);
		showhide("ss_node_table_tls_host_tr", E("ss_node_table_v2_tls").checked);
		showhide("ss_node_table_insecure_tr", E("ss_node_table_v2_tls").checked);
	}
	if (save_flag == "shadowsocksr") {
		showhide("ss_node_table_method_tr", true);
		showhide("ss_node_table_v2_tls_tr", false);
		showhide("ss_node_table_v2_reality_tr", false);
		showhide("ss_node_table_tls_host_tr", false);
		showhide("ss_node_table_insecure_tr", false);
	}
	if (save_flag == "v2ray") {
		E('ss_node_table_server_tr').style.display = "";
		E('ss_node_table_port_tr').style.display = "";
		E('ss_node_table_v2_vmess_id_tr').style.display = "";
		E('ss_node_table_v2_alter_id_tr').style.display = "";
		E('ss_node_table_v2_protocol_tr').style.display = "";
		E('ss_node_table_v2_security_tr').style.display = "";
		E('ss_node_table_v2_transport_tr').style.display = "";
		E('ss_node_table_v2_tcp_guise_tr').style.display = "";
		E('ss_node_table_v2_kcp_guise_tr').style.display = "";
		E('ss_node_table_v2_http_path_tr').style.display = "";
		E('ss_node_table_v2_http_host_tr').style.display = "";
		E('ss_node_table_v2_tls_flow_tr').style.display = "";
		E('ss_node_table_v2_mux_tr').style.display = "";
		E('ss_node_table_v2_concurrency_tr').style.display = "";
		var http_on_2 = E("ss_node_table_v2_transport").value == "tcp" && E("ss_node_table_v2_tcp_guise").value == "http";
		var host_on_2 = E("ss_node_table_v2_transport").value == "ws" || E("ss_node_table_v2_transport").value == "h2" || http_on_2;
		var path_on_2 = E("ss_node_table_v2_transport").value == "ws" || E("ss_node_table_v2_transport").value == "h2" || E("ss_node_table_v2_transport").value == "mkcp";
		var vmess_on_2 = E("ss_node_table_v2_protocol").value == "vmess";
		var vless_on_2 = E("ss_node_table_v2_protocol").value == "vless";
		showhide("ss_node_table_v2_vmess_id_tr", (vmess_on_2 || vless_on_2));
		showhide("ss_node_table_v2_alter_id_tr", vmess_on_2);
		showhide("ss_node_table_v2_security_tr", vmess_on_2);
		showhide("ss_node_table_v2_tcp_guise_tr", (E("ss_node_table_v2_transport").value == "tcp"));
		showhide("ss_node_table_v2_kcp_guise_tr", (E("ss_node_table_v2_transport").value == "mkcp"));
		showhide("ss_node_table_v2_http_host_tr", host_on_2);
		showhide("ss_node_table_v2_http_path_tr", path_on_2);
		showhide("ss_node_table_v2_encryption_tr", vless_on_2);
		showhide("ss_node_table_v2_quic_security_tr", (E("ss_node_table_v2_transport").value == "quic"));
		showhide("ss_node_table_v2_quic_key_tr", (E("ss_node_table_v2_transport").value == "quic"));
		showhide("ss_node_table_v2_quic_guise_tr", (E("ss_node_table_v2_transport").value == "quic"));
		showhide("ss_node_table_v2_serviceName_tr", (E("ss_node_table_v2_transport").value == "grpc"));
		showhide("ss_node_table_v2_idle_timeout_tr", (E("ss_node_table_v2_transport").value == "grpc" || E("ss_node_table_v2_transport").value == "h2"));
		showhide("ss_node_table_v2_health_check_timeout_tr", (E("ss_node_table_v2_transport").value == "grpc" || E("ss_node_table_v2_transport").value == "h2"));
		showhide("ss_node_table_v2_permit_without_stream_tr", (E("ss_node_table_v2_transport").value == "grpc"));
		showhide("ss_node_table_v2_initial_windows_size_tr", (E("ss_node_table_v2_transport").value == "grpc"));
		showhide("ss_node_table_v2_tls_tr", (E("ss_node_table_v2_protocol").value != "shadowsocksr" && E("ss_node_table_v2_reality").checked != true));
		showhide("ss_node_table_v2_mtu_tr", E("ss_node_table_v2_transport").value == "mkcp");
		showhide("ss_node_table_v2_tti_tr", E("ss_node_table_v2_transport").value == "mkcp");
		showhide("ss_node_table_uplink_capacity_tr", E("ss_node_table_v2_transport").value == "mkcp");
		showhide("ss_node_table_downlink_capacity_tr", E("ss_node_table_v2_transport").value == "mkcp");
		showhide("ss_node_table_v2_read_buffer_size_tr", E("ss_node_table_v2_transport").value == "mkcp");
		showhide("ss_node_table_v2_write_buffer_size_tr", E("ss_node_table_v2_transport").value == "mkcp");
		showhide("ss_node_table_v2_seed_tr", E("ss_node_table_v2_transport").value == "mkcp");
		showhide("ss_node_table_v2_congestion_tr", E("ss_node_table_v2_transport").value == "mkcp");
		showhide("ss_node_table_tls_host_tr", (E("ss_node_table_v2_tls").checked || E("ss_node_table_v2_reality").checked));
		showhide("ss_node_table_v2_reality_tr", (vless_on_2 && E("ss_node_table_v2_tls").checked != true));
		showhide("ss_node_table_v2_fingerprint_tr", (E("ss_node_table_v2_tls").checked || E("ss_node_table_v2_reality").checked));
		showhide("ss_node_table_v2_tls_flow_tr", (vless_on_2 && E("ss_node_table_v2_transport").value == "tcp" && (E("ss_node_table_v2_tls").checked || E("ss_node_table_v2_reality").checked)));
		showhide("ss_node_table_v2_ivCheck_tr", (E("ss_node_table_v2_protocol").value == "shadowsocks"));
		showhide("ss_node_table_v2_mux_tr", (E("ss_node_table_v2_protocol").value != "shadowsocksr" && E("ss_node_table_v2_reality").checked == false));
		showhide("ss_node_table_v2_concurrency_tr", E("ss_node_table_v2_mux").checked);
		showhide("ss_node_table_insecure_tr", (E("ss_node_table_v2_tls").checked));
		showhide("ss_node_table_v2_reality_publickey_tr", (vless_on_2 && E("ss_node_table_v2_reality").checked));
		showhide("ss_node_table_v2_reality_shortid_tr", (vless_on_2 && E("ss_node_table_v2_reality").checked));
		showhide("ss_node_table_v2_reality_spiderx_tr", (vless_on_2 && E("ss_node_table_v2_reality").checked));
	}
	if (save_flag == "trojan") {
		showhide("ss_node_table_v2_tls_tr", true);
		showhide("ss_node_table_v2_reality_tr", false);
		showhide("ss_node_table_tls_host_tr", E("ss_node_table_v2_tls").checked);
		showhide("ss_node_table_tls_sessionTicket_tr", E("ss_node_table_v2_tls").checked);
		showhide("ss_node_table_v2_mux_tr", true);
		showhide("ss_node_table_v2_concurrency_tr", E("ss_node_table_v2_mux").checked);
		showhide("ss_node_table_insecure_tr", E("ss_node_table_v2_tls").checked);
	}
	if (save_flag == "hysteria") {	//helloworld-full
		showhide("ss_node_table_hy2_auth_tr", true);	//helloworld-full
		showhide("ss_node_table_flag_obfs_tr", true);	//helloworld-full
		showhide("ss_node_table_tls_host_tr", true);	//helloworld-full
		showhide("ss_node_table_salamander_tr", E("ss_node_table_flag_obfs").value == "1");	//helloworld-full
		showhide("ss_node_table_fast_open_tr", true);	//helloworld-full
		showhide("ss_node_table_uplink_capacity_tr", true);	//helloworld-full
		showhide("ss_node_table_downlink_capacity_tr", true);	//helloworld-full
		showhide("ss_node_table_insecure_tr", true);	//helloworld-full
	}	//helloworld-full
	//kcp pannel
	E("sstable_kcp_parameter_tr").style.display = "";
	E("sstable_kcp_password_tr").style.display = "";
	// 插件重启功能
	var Ti = E("ssconf_reboot_check").value;
	var In = E("ssconf_basic_inter_pre").value;
	var items = ["re1", "re2", "re3", "re4", "re4_1", "re4_2", "re4_3", "re5"];
	for ( var i = 1; i < items.length; ++i ) $("." + items[i]).hide();
	if (Ti != "0") $(".re" + Ti).show();
	if (Ti == "4") $(".re4_" + In).show();
	// failover
	if(E("ssconf_failover_enable").checked){
		$("#failover_settings_1").show();
		$("#failover_settings_2").show();
		$("#failover_settings_3").show();
	}else{
		$("#failover_settings_1").hide();
		$("#failover_settings_2").hide();
		$("#failover_settings_3").hide();
	}
	showhide("ssconf_failover_text_1",  E("ssconf_failover_enable").checked && E("ssconf_failover_s4_1").value == "2" && E("ssconf_failover_s4_2").value == "2");
	showhide("ssconf_failover_s4_2",  E("ssconf_failover_enable").checked && E("ssconf_failover_s4_1").value == "2");
	showhide("ssconf_failover_s4_3",  E("ssconf_failover_enable").checked && E("ssconf_failover_s4_1").value == "2" && E("ssconf_failover_s4_2").value == "1");
	// push on click
	var trid = $(r).attr("id")
	if ( trid == "ssconf_basic_dragable" || trid == "ssconf_basic_tablet") {
		var dbus_post = {};
		dbus_post[trid] = E(trid).checked ? '1' : '0';
		push_data("dummy_script.sh", "", dbus_post, "1");
	}	
	refresh_acl_table();
}
function update_visibility() {
	var a = E("ssconf_basic_rule_update").value == "1";
	var b = E("ssconf_basic_node_update").value == "1";
	var c = E("ssconf_basic_tri_reboot_time").value;
	var d = E("ssconf_basic_ping_node").value != "off" && E("ssconf_basic_ping_node").value != "";
	showhide("ssconf_basic_rule_update_time", a);
	showhide("update_choose", a);
	showhide("ssconf_basic_node_update_day", b);
	showhide("ssconf_basic_node_update_hr", b);
	showhide("ssconf_basic_tri_reboot_time_note", (c != "0"));
	showhide("ssconf_basic_ping_method", d);
	showhide("sstable_ping_btn", d);
}
function Add_profile() { //点击节点页面内添加节点动作
	$('body').prepend(tableApi.genFullScreen());
	$('.fullScreen').show();
	tabclickhandler(0); //默认显示添加ss节点
	E("ss_node_table_alias").value = "";
	E("ss_node_table_server").value = "";
	E("ss_node_table_port").value = "";
	E("ss_node_table_password").value = "";
	E("ss_node_table_method").value = "aes-256-cfb";
	E("ss_node_table_v2_ivCheck").value = "none";
	E("ss_node_table_mode").value = "1";
	E("ss_node_table_plugin").value = "none"
	E("ss_node_table_plugin_opts").value = "";
	E("ss_node_table_protocol").value = "origin";
	E("ss_node_table_protocol_param").value = "";
	E("ss_node_table_obfs").value = "plain";
	E("ss_node_table_obfs_param").value = "";
	E("ss_node_table_v2_vmess_id").value = "";
	E("ss_node_table_v2_alter_id").value = "";
	E("ss_node_table_v2_protocol").value = "vmess";
	E("ssTitle").style.display = "";
	E("ssrTitle").style.display = "";
	E("v2rayTitle").style.display = "";
	E("TrojanTitle").style.display = "";
	E("HysteriaTitle").style.display = "";	//helloworld-full
	E("add_node").style.display = "";
	E("edit_node").style.display = "none";
	E("continue_add").style.display = "";
	$("#vpnc_settings").fadeIn(300);
	$(".contentM_qis").css("top", "0px");
}
function cancel_add_rule() { //点击添加节点面板上的返回
	$("#vpnc_settings").fadeOut(300);
	$("body").find(".fullScreen").fadeOut(300, function() { tableApi.removeElement("fullScreen"); });
}
function tabclickhandler(_type) {
	E('ssTitle').className = "vpnClientTitle_td_unclick";
	E('ssrTitle').className = "vpnClientTitle_td_unclick";
	E('v2rayTitle').className = "vpnClientTitle_td_unclick";
	E('TrojanTitle').className = "vpnClientTitle_td_unclick";
	E('HysteriaTitle').className = "vpnClientTitle_td_unclick";	//helloworld-full
	if (_type == 0) {
		save_flag = "shadowsocks";
		E('ssTitle').className = "vpnClientTitle_td_click";
		E('ss_node_table_alias_tr').style.display = "";
		E('ss_node_table_server_tr').style.display = "";
		E('ss_node_table_port_tr').style.display = "";
		E('ss_node_table_password_tr').style.display = "";
		E('ss_node_table_method_tr').style.display = "none";
		E('ss_node_table_method_ss_tr').style.display = "";
		E('ss_node_table_protocol_tr').style.display = "none";
		E('ss_node_table_protocol_param_tr').style.display = "none";
		E('ss_node_table_obfs_tr').style.display = "none";
		E('ss_node_table_obfs_param_tr').style.display = "none";
		E('ss_node_table_v2_vmess_id_tr').style.display = "none";
		E('ss_node_table_v2_alter_id_tr').style.display = "none";
		E('ss_node_table_v2_protocol_tr').style.display = "none";
		E('ss_node_table_v2_security_tr').style.display = "none";
		E('ss_node_table_v2_transport_tr').style.display = "none";
		E('ss_node_table_v2_tcp_guise_tr').style.display = "none";
		E('ss_node_table_v2_kcp_guise_tr').style.display = "none";
		E('ss_node_table_v2_http_path_tr').style.display = "none";
		E('ss_node_table_v2_http_host_tr').style.display = "none";
		E('ss_node_table_v2_fingerprint_tr').style.display = "none";
		E('ss_node_table_v2_tls_flow_tr').style.display = "none";
		E('ss_node_table_v2_quic_security_tr').style.display = "none";
		E('ss_node_table_v2_quic_key_tr').style.display = "none";
		E('ss_node_table_v2_quic_guise_tr').style.display = "none";
		E('ss_node_table_v2_serviceName_tr').style.display = "none";
		E('ss_node_table_v2_idle_timeout_tr').style.display = "none";
		E('ss_node_table_v2_health_check_timeout_tr').style.display = "none";
		E('ss_node_table_v2_permit_without_stream_tr').style.display = "none";
		E('ss_node_table_v2_initial_windows_size_tr').style.display = "none";
		E('ss_node_table_v2_tls_tr').style.display = "";
		E('ss_node_table_v2_tls').value = "0";
		E('ss_node_table_v2_reality').value = "0";
		E('ss_node_table_v2_reality_tr').style.display = "none";
		E('ss_node_table_v2_mux_tr').style.display = "none";
		E('ss_node_table_v2_concurrency_tr').style.display = "none";
		showhide("ss_node_table_plugin_tr", ($("#ss_node_table_mode").val() != "3"));
		showhide("ss_node_table_plugin_opts_tr", ($("#ss_node_table_mode").val() != "3" && $("#ss_node_table_plugin").val() != "none"));
		showhide("ss_node_table_tls_host_tr", (E("ss_node_table_v2_tls").checked || E("ss_node_table_v2_reality").checked));
		showhide("ss_node_table_insecure_tr", (E("ss_node_table_v2_tls").checked));
		E('ss_node_table_hy2_auth_tr').style.display = "none";	//helloworld-full
		E('ss_node_table_flag_obfs_tr').style.display = "none";	//helloworld-full
		E('ss_node_table_salamander_tr').style.display = "none";	//helloworld-full
		E('ss_node_table_fast_open_tr').style.display = "none";	//helloworld-full
		E('ss_node_table_uplink_capacity_tr').style.display = "none";	//helloworld-full
		E('ss_node_table_downlink_capacity_tr').style.display = "none";	//helloworld-full
	} else if (_type == 1) {
		save_flag = "shadowsocksr";
		E('ssrTitle').className = "vpnClientTitle_td_click";
		E('ss_node_table_alias_tr').style.display = "";
		E('ss_node_table_server_tr').style.display = "";
		E('ss_node_table_port_tr').style.display = "";
		E('ss_node_table_password_tr').style.display = "";
		E('ss_node_table_method_tr').style.display = "";
		E('ss_node_table_method_ss_tr').style.display = "none";
		E('ss_node_table_plugin_tr').style.display = "none";
		E('ss_node_table_plugin_opts_tr').style.display = "none";
		E('ss_node_table_protocol_tr').style.display = "";
		E('ss_node_table_protocol_param_tr').style.display = "";
		E('ss_node_table_obfs_tr').style.display = "";
		E('ss_node_table_obfs_param_tr').style.display = "";
		E('ss_node_table_v2_vmess_id_tr').style.display = "none";
		E('ss_node_table_v2_alter_id_tr').style.display = "none";
		E('ss_node_table_v2_protocol_tr').style.display = "none";
		E('ss_node_table_v2_security_tr').style.display = "none";
		E('ss_node_table_v2_transport_tr').style.display = "none";
		E('ss_node_table_v2_tcp_guise_tr').style.display = "none";
		E('ss_node_table_v2_kcp_guise_tr').style.display = "none";
		E('ss_node_table_v2_http_path_tr').style.display = "none";
		E('ss_node_table_v2_http_host_tr').style.display = "none";
		E('ss_node_table_v2_fingerprint_tr').style.display = "none";
		E('ss_node_table_v2_tls_flow_tr').style.display = "none";
		E('ss_node_table_v2_quic_security_tr').style.display = "none";
		E('ss_node_table_v2_quic_key_tr').style.display = "none";
		E('ss_node_table_v2_quic_guise_tr').style.display = "none";
		E('ss_node_table_v2_serviceName_tr').style.display = "none";
		E('ss_node_table_v2_idle_timeout_tr').style.display = "none";
		E('ss_node_table_v2_health_check_timeout_tr').style.display = "none";
		E('ss_node_table_v2_permit_without_stream_tr').style.display = "none";
		E('ss_node_table_v2_initial_windows_size_tr').style.display = "none";
		E('ss_node_table_v2_mux_tr').style.display = "none";
		E('ss_node_table_v2_concurrency_tr').style.display = "none";
		E('ss_node_table_v2_tls_tr').style.display = "none";
		E('ss_node_table_v2_reality_tr').style.display = "none";
		E('ss_node_table_v2_tls').value = "0";
		E('ss_node_table_v2_reality').value = "0";
		E('ss_node_table_tls_host_tr').style.display = "none";
		E('ss_node_table_insecure_tr').style.display = "none";
		E('ss_node_table_hy2_auth_tr').style.display = "none";	//helloworld-full
		E('ss_node_table_flag_obfs_tr').style.display = "none";	//helloworld-full
		E('ss_node_table_tls_host_tr').style.display = "none";	//helloworld-full
		E('ss_node_table_salamander_tr').style.display = "none";	//helloworld-full
		E('ss_node_table_fast_open_tr').style.display = "none";	//helloworld-full
		E('ss_node_table_uplink_capacity_tr').style.display = "none";	//helloworld-full
		E('ss_node_table_downlink_capacity_tr').style.display = "none";	//helloworld-full
	} else if (_type == 2) {
		save_flag = "v2ray";
		E('v2rayTitle').className = "vpnClientTitle_td_click";
		E('ss_node_table_alias_tr').style.display = "";
		E('ss_node_table_password_tr').style.display = "none";
		E('ss_node_table_method_tr').style.display = "none";
		E('ss_node_table_method_ss_tr').style.display = "none";
		E('ss_node_table_plugin_tr').style.display = "none";
		E('ss_node_table_plugin_opts_tr').style.display = "none";
		E('ss_node_table_protocol_tr').style.display = "none";
		E('ss_node_table_protocol_param_tr').style.display = "none";
		E('ss_node_table_obfs_tr').style.display = "none";
		E('ss_node_table_obfs_param_tr').style.display = "none";
		E('ss_node_table_v2_vmess_id_tr').style.display = "";
		E('ss_node_table_v2_alter_id_tr').style.display = "";
		E('ss_node_table_v2_protocol_tr').style.display = "";
		E('ss_node_table_v2_security_tr').style.display = "";
		E('ss_node_table_v2_transport_tr').style.display = "";
		E('ss_node_table_v2_tcp_guise_tr').style.display = "";
		E('ss_node_table_v2_kcp_guise_tr').style.display = "";
		E('ss_node_table_v2_http_path_tr').style.display = "";
		E('ss_node_table_v2_http_host_tr').style.display = "";
		E('ss_node_table_v2_mux_tr').style.display = "";
		E('ss_node_table_v2_concurrency_tr').style.display = "";
		E('ss_node_table_v2_tls_tr').style.display = "";
		E('ss_node_table_v2_tls').value = "0";
		E('ss_node_table_v2_reality_tr').style.display = "none";
		E('ss_node_table_v2_reality').value = "0";
		E('ss_node_table_server_tr').style.display = "";
		E('ss_node_table_port_tr').style.display = "";
		E('ss_node_table_v2_vmess_id_tr').style.display = "";
		E('ss_node_table_v2_alter_id_tr').style.display = "";
		E('ss_node_table_v2_protocol_tr').style.display = "";
		E('ss_node_table_v2_security_tr').style.display = "";
		E('ss_node_table_v2_transport_tr').style.display = "";
		E('ss_node_table_v2_tcp_guise_tr').style.display = "";
		E('ss_node_table_v2_kcp_guise_tr').style.display = "";
		E('ss_node_table_v2_http_path_tr').style.display = "";
		E('ss_node_table_v2_http_host_tr').style.display = "";
		E('ss_node_table_v2_tls_flow_tr').style.display = "none";
		E('ss_node_table_v2_mux_tr').style.display = "";
		E('ss_node_table_v2_concurrency_tr').style.display = "";
		var http_on_2 = E("ss_node_table_v2_transport").value == "tcp" && E("ss_node_table_v2_tcp_guise").value == "http";
		var host_on_2 = E("ss_node_table_v2_transport").value == "ws" || E("ss_node_table_v2_transport").value == "h2" || http_on_2;
		var path_on_2 = E("ss_node_table_v2_transport").value == "ws" || E("ss_node_table_v2_transport").value == "h2" || E("ss_node_table_v2_transport").value == "mkcp";
		showhide("ss_node_table_v2_tcp_guise_tr", (E("ss_node_table_v2_transport").value == "tcp"));
		showhide("ss_node_table_v2_reality_tr", (E("ss_node_table_v2_protocol").value == "vless" && E('ss_node_table_v2_tls').value != "1"));
		showhide("ss_node_table_v2_tls_flow_tr", (E("ss_node_table_v2_tls").value == "1" && E('ss_node_table_v2_reality').value == "1"));
		showhide("ss_node_table_v2_kcp_guise_tr", (E("ss_node_table_v2_transport").value == "mkcp"));
		showhide("ss_node_table_v2_http_host_tr", host_on_2);
		showhide("ss_node_table_v2_http_path_tr", path_on_2);
		showhide("ss_node_table_v2_quic_security_tr", (E("ss_node_table_v2_transport").value == "quic"));
		showhide("ss_node_table_v2_quic_key_tr", (E("ss_node_table_v2_transport").value == "quic"));
		showhide("ss_node_table_v2_quic_guise_tr", (E("ss_node_table_v2_transport").value == "quic"));
		showhide("ss_node_table_v2_serviceName_tr", (E("ss_node_table_v2_transport").value == "grpc"));
		showhide("ss_node_table_v2_health_check_timeout_tr", (E("ss_node_table_v2_transport").value == "grpc" || E("ss_node_table_v2_transport").value == "h2"));
		showhide("ss_node_table_v2_idle_timeout_tr", (E("ss_node_table_v2_transport").value == "grpc"));
		showhide("ss_node_table_v2_permit_without_stream_tr", (E("ss_node_table_v2_transport").value == "grpc"));
		showhide("ss_node_table_v2_initial_windows_size_tr", (E("ss_node_table_v2_transport").value == "grpc"));
		showhide("ss_node_table_v2_vmess_id_tr", (E("ss_node_table_v2_protocol").value == "vmess" || E("ss_node_table_v2_protocol").value == "vless"));
		showhide("ss_node_table_v2_alter_id_tr", (E("ss_node_table_v2_protocol").value == "vmess"));
		showhide("ss_node_table_v2_security_tr", (E("ss_node_table_v2_protocol").value == "vmess"));
		showhide("ss_node_table_v2_ivCheck_tr", (E("ss_node_table_v2_protocol").value == "shadowsocks"));
		showhide("ss_node_table_v2_concurrency_tr", (E("ss_node_table_v2_mux").checked));
		showhide("ss_node_table_tls_host_tr", (E("ss_node_table_v2_tls").checked || E("ss_node_table_v2_reality").checked));
		showhide("ss_node_table_insecure_tr", (E("ss_node_table_v2_tls").checked));
		showhide("ss_node_table_v2_reality_publickey_tr", (E("ss_node_table_v2_protocol").value == "vless" && E("ss_node_table_v2_reality").checked));
		showhide("ss_node_table_v2_reality_shortid_tr", (E("ss_node_table_v2_protocol").value == "vless" && E("ss_node_table_v2_reality").checked));
		showhide("ss_node_table_v2_reality_spiderx_tr", (E("ss_node_table_v2_protocol").value == "vless" && E("ss_node_table_v2_reality").checked));
		E('ss_node_table_hy2_auth_tr').style.display = "none";	//helloworld-full
		E('ss_node_table_flag_obfs_tr').style.display = "none";	//helloworld-full
		E('ss_node_table_tls_host_tr').style.display = "none";	//helloworld-full
		E('ss_node_table_salamander_tr').style.display = "none";	//helloworld-full
		E('ss_node_table_fast_open_tr').style.display = "none";	//helloworld-full
		E('ss_node_table_uplink_capacity_tr').style.display = "none";	//helloworld-full
		E('ss_node_table_downlink_capacity_tr').style.display = "none";	//helloworld-full
	}else if (_type == 3) {
		save_flag = "trojan";
		E('TrojanTitle').className = "vpnClientTitle_td_click";
		E('ss_node_table_alias_tr').style.display = "";
		E('ss_node_table_server_tr').style.display = "";
		E('ss_node_table_port_tr').style.display = "";
		E('ss_node_table_password_tr').style.display = "";
		E('ss_node_table_plugin_tr').style.display = "none";
		E('ss_node_table_plugin_opts_tr').style.display = "none";
		E('ss_node_table_method_ss_tr').style.display = "none";
		E('ss_node_table_protocol_tr').style.display = "none";
		E('ss_node_table_protocol_param_tr').style.display = "none";
		E('ss_node_table_obfs_tr').style.display = "none";
		E('ss_node_table_obfs_param_tr').style.display = "none";
		E('ss_node_table_v2_vmess_id_tr').style.display = "none";
		E('ss_node_table_v2_alter_id_tr').style.display = "none";
		E('ss_node_table_v2_security_tr').style.display = "none";
		E('ss_node_table_v2_protocol_tr').style.display = "none";
		E('ss_node_table_v2_transport_tr').style.display = "none";
		E('ss_node_table_v2_tcp_guise_tr').style.display = "none";
		E('ss_node_table_v2_kcp_guise_tr').style.display = "none";
		E('ss_node_table_v2_http_path_tr').style.display = "none";
		E('ss_node_table_v2_http_host_tr').style.display = "none";
		E('ss_node_table_v2_fingerprint_tr').style.display = "none";
		E('ss_node_table_v2_tls_flow_tr').style.display = "none";
		E('ss_node_table_v2_quic_security_tr').style.display = "none";
		E('ss_node_table_v2_quic_key_tr').style.display = "none";
		E('ss_node_table_v2_quic_guise_tr').style.display = "none";
		E('ss_node_table_v2_serviceName_tr').style.display = "none";
		E('ss_node_table_v2_idle_timeout_tr').style.display = "none";
		E('ss_node_table_v2_health_check_timeout_tr').style.display = "none";
		E('ss_node_table_v2_permit_without_stream_tr').style.display = "none";
		E('ss_node_table_v2_initial_windows_size_tr').style.display = "none";
		E('ss_node_table_v2_mux_tr').style.display = "";
		E("ss_node_table_v2_mux").checked = false;
		E('ss_node_table_v2_concurrency_tr').style.display = "none";
		E('ss_node_table_v2_tls_tr').style.display = "";
		E('ss_node_table_v2_reality_tr').style.display = "none";
		E('ss_node_table_v2_tls').value = "0";
		E('ss_node_table_v2_reality').value = "0";
		showhide("ss_node_table_tls_host_tr", (E("ss_node_table_v2_tls").checked || E("ss_node_table_v2_reality").checked));
		showhide("ss_node_table_insecure_tr", (E("ss_node_table_v2_tls").checked));
		E('ss_node_table_hy2_auth_tr').style.display = "none";	//helloworld-full
		E('ss_node_table_flag_obfs_tr').style.display = "none";	//helloworld-full
		E('ss_node_table_salamander_tr').style.display = "none";	//helloworld-full
		E('ss_node_table_fast_open_tr').style.display = "none";	//helloworld-full
		E('ss_node_table_uplink_capacity_tr').style.display = "none";	//helloworld-full
		E('ss_node_table_downlink_capacity_tr').style.display = "none";	//helloworld-full
	}else if (_type == 4) {	//helloworld-full
		save_flag = "hysteria";	//helloworld-full
		E('HysteriaTitle').className = "vpnClientTitle_td_click";	//helloworld-full
		E('ss_node_table_password_tr').style.display = "none";	//helloworld-full
		E('ss_node_table_plugin_tr').style.display = "none";	//helloworld-full
		E('ss_node_table_plugin_opts_tr').style.display = "none";	//helloworld-full
		E('ss_node_table_method_ss_tr').style.display = "none";	//helloworld-full
		E('ss_node_table_protocol_tr').style.display = "none";	//helloworld-full
		E('ss_node_table_protocol_param_tr').style.display = "none";	//helloworld-full
		E('ss_node_table_obfs_tr').style.display = "none";	//helloworld-full
		E('ss_node_table_obfs_param_tr').style.display = "none";	//helloworld-full
		E('ss_node_table_v2_vmess_id_tr').style.display = "none";	//helloworld-full
		E('ss_node_table_v2_alter_id_tr').style.display = "none";	//helloworld-full
		E('ss_node_table_v2_security_tr').style.display = "none";	//helloworld-full
		E('ss_node_table_v2_protocol_tr').style.display = "none";	//helloworld-full
		E('ss_node_table_v2_transport_tr').style.display = "none";	//helloworld-full
		E('ss_node_table_v2_tcp_guise_tr').style.display = "none";	//helloworld-full
		E('ss_node_table_v2_kcp_guise_tr').style.display = "none";	//helloworld-full
		E('ss_node_table_v2_http_path_tr').style.display = "none";	//helloworld-full
		E('ss_node_table_v2_http_host_tr').style.display = "none";	//helloworld-full
		E('ss_node_table_v2_fingerprint_tr').style.display = "none";	//helloworld-full
		E('ss_node_table_v2_tls_flow_tr').style.display = "none";	//helloworld-full
		E('ss_node_table_v2_quic_security_tr').style.display = "none";	//helloworld-full
		E('ss_node_table_v2_quic_key_tr').style.display = "none";	//helloworld-full
		E('ss_node_table_v2_quic_guise_tr').style.display = "none";	//helloworld-full
		E('ss_node_table_v2_serviceName_tr').style.display = "none";	//helloworld-full
		E('ss_node_table_v2_idle_timeout_tr').style.display = "none";	//helloworld-full
		E('ss_node_table_v2_health_check_timeout_tr').style.display = "none";	//helloworld-full
		E('ss_node_table_v2_permit_without_stream_tr').style.display = "none";	//helloworld-full
		E('ss_node_table_v2_initial_windows_size_tr').style.display = "none";	//helloworld-full
		E('ss_node_table_v2_mux_tr').style.display = "none";	//helloworld-full
		E("ss_node_table_v2_mux").checked = false;	//helloworld-full
		E('ss_node_table_v2_concurrency_tr').style.display = "none";	//helloworld-full
		E('ss_node_table_v2_tls_tr').style.display = "none";	//helloworld-full
		E('ss_node_table_v2_reality_tr').style.display = "none";	//helloworld-full
		E('ss_node_table_v2_tls').value = "0";	//helloworld-full
		E('ss_node_table_v2_reality').value = "0";	//helloworld-full
		E('ss_node_table_tls_host_tr').style.display = "";	//helloworld-full
		E('ss_node_table_insecure_tr').style.display = "";	//helloworld-full
		E('ss_node_table_hy2_auth_tr').style.display = "";	//helloworld-full
		E('ss_node_table_flag_obfs_tr').style.display = "";	//helloworld-full
		E('ss_node_table_tls_host_tr').style.display = "";	//helloworld-full
		showhide("ss_node_table_salamander_tr", (E("ss_node_table_flag_obfs").value == "1"));	//helloworld-full
		E('ss_node_table_fast_open_tr').style.display = "";	//helloworld-full
		E("ss_node_table_fast_open").checked = false;
		E('ss_node_table_uplink_capacity_tr').style.display = "";	//helloworld-full
		E('ss_node_table_downlink_capacity_tr').style.display = "";	//helloworld-full
	} 
	return save_flag;
}

function add_edit_node(flag, node_idx, add) {
	var dbus = {};
	var tmp_db = {}
	tmp_db.alias = $.trim($('#ss_node_table_alias').val());
	tmp_db.server = $.trim($('#ss_node_table_server').val());
	tmp_db.server_port = $.trim($('#ss_node_table_port').val());
	if(flag == 'shadowsocks'){
		tmp_db.password = $.trim($('#ss_node_table_password').val());
		tmp_db.encrypt_method_ss = $.trim($('#ss_node_table_method_ss').val());
		tmp_db.plugin = $.trim($('#ss_node_table_plugin').val());
		tmp_db.plugin_opts = $.trim($('#ss_node_table_plugin_opts').val());
		tmp_db.tls = E("ss_node_table_v2_tls").checked ? '1' : '0';
		tmp_db.tls_host = $.trim($('#ss_node_table_tls_host').val());
		tmp_db.ivCheck = $.trim($('#ss_node_table_v2_ivCheck').val());
		tmp_db.v2ray_protocol = "shadowsocks";
	}else if(flag == 'shadowsocksr'){
		tmp_db.password = $.trim($('#ss_node_table_password').val());
		tmp_db.encrypt_method = $.trim($('#ss_node_table_method').val());
		tmp_db.protocol = $.trim($('#ss_node_table_protocol').val());
		tmp_db.protocol_param = $.trim($('#ss_node_table_protocol_param').val());
		tmp_db.obfs = $.trim($('#ss_node_table_obfs').val());
		tmp_db.obfs_param = $.trim($('#ss_node_table_obfs_param').val());
		tmp_db.v2ray_protocol = "shadowsocksr";
	}else if(flag == 'v2ray'){
		tmp_db.transport = $.trim($('#ss_node_table_v2_transport').val());
		tmp_db.vmess_id = $.trim($('#ss_node_table_v2_vmess_id').val());
		tmp_db.v2ray_protocol = $.trim($('#ss_node_table_v2_protocol').val());
		if(tmp_db.v2ray_protocol == "vmess"){
			tmp_db.alter_id = $.trim($('#ss_node_table_v2_alter_id').val());
			tmp_db.security = $.trim($('#ss_node_table_v2_security').val());
			tmp_db.v2ray_protocol = "vmess";
		}
		if(tmp_db.v2ray_protocol == "vless"){
			tmp_db.v2ray_protocol = "vless";
			tmp_db.vless_encryption = $.trim($('#ss_node_table_v2_encryption').val());
			tmp_db.reality = E("ss_node_table_v2_reality").checked ? '1' : '0';
			if(tmp_db.reality == "1"){
				tmp_db.reality_publickey = $.trim($('#ss_node_table_v2_reality_publickey').val());
				tmp_db.reality_shortid = $.trim($('#ss_node_table_v2_reality_shortid').val());
				tmp_db.reality_spiderx = $.trim($('#ss_node_table_v2_reality_spiderx').val());
			}
		}
		tmp_db.tls = E("ss_node_table_v2_tls").checked ? '1' : '0';
		tmp_db.mux = E("ss_node_table_v2_mux").checked ? '1' : '0';
		tmp_db.concurrency = $.trim($('#ss_node_table_v2_concurrency').val());
		if(tmp_db.tls == "1" || tmp_db.reality == "1"){
			tmp_db.tls_host = $.trim($('#ss_node_table_tls_host').val());
			tmp_db.fingerprint = $.trim($('#ss_node_table_v2_fingerprint').val());
			tmp_db.tls_flow = $.trim($('#ss_node_table_v2_tls_flow').val());
		}
		tmp_db.insecure = E("ss_node_table_insecure").checked ? '1' : '0';
		if (tmp_db.transport == "tcp") {
			tmp_db.tcp_guise = $.trim($('#ss_node_table_v2_tcp_guise').val());
			if(tmp_db.tcp_guise == "http"){
				tmp_db.http_host = $.trim($('#ss_node_table_v2_http_host').val());
				tmp_db.http_path = $.trim($('#ss_node_table_v2_http_path').val());
			}
		} else if (tmp_db.transport == "kcp") {
			tmp_db.kcp_guise = $.trim($('#ss_node_table_v2_kcp_guise').val());
			tmp_db.mtu = $.trim($('#ss_node_table_v2_mtu').val());
			tmp_db.tti = $.trim($('#ss_node_table_v2_tti').val());
			tmp_db.uplink_capacity = $.trim($('#ss_node_table_uplink_capacity').val());
			tmp_db.downlink_capacity = $.trim($('#ss_node_table_downlink_capacity').val());
			tmp_db.read_buffer_size = $.trim($('#ss_node_table_v2_read_buffer_size').val());
			tmp_db.write_buffer_size = $.trim($('#ss_node_table_v2_write_buffer_size').val());
			tmp_db.seed = $.trim($('#ss_node_table_v2_seed').val());
			tmp_db.congestion = E("ss_node_table_v2_congestion").checked ? '1' : '0';
		} else if (tmp_db.transport == "ws") {
			tmp_db.ws_host = $.trim($('#ss_node_table_v2_http_host').val());
			tmp_db.ws_path = $.trim($('#ss_node_table_v2_http_path').val());
		} else if (tmp_db.transport == "h2") {
			tmp_db.h2_host = $.trim($('#ss_node_table_v2_http_host').val());
			tmp_db.h2_path = $.trim($('#ss_node_table_v2_http_path').val());
			tmp_db.health_check = E("ss_node_table_v2_health_check").checked ? '1' : '0';
			if(tmp_db.health_check == "1"){
				tmp_db.read_idle_timeout = $.trim($('#ss_node_table_v2_idle_timeout').val());
				tmp_db.health_check_timeout = $.trim($('#ss_node_table_v2_health_check_timeout').val());
			}
		} else if (tmp_db.transport == "quic") {
			tmp_db.quic_guise = $.trim($('#ss_node_table_v2_quic_guise').val());
			tmp_db.quic_key = $.trim($('#ss_node_table_v2_quic_key').val());
			tmp_db.quic_security = $.trim($('#ss_node_table_v2_quic_security').val());
		} else if (tmp_db.transport == "grpc") {
			tmp_db.serviceName = $.trim($('#ss_node_table_v2_serviceName').val());
			tmp_db.grpc_mode = $.trim($('#ss_node_table_v2_grpc_mode').val());
			tmp_db.initial_windows_size = $.trim($('#ss_node_table_v2_initial_windows_size').val());
			tmp_db.health_check = E("ss_node_table_v2_health_check").checked ? '1' : '0';
			if(tmp_db.health_check == "1"){
				tmp_db.idle_timeout = $.trim($('#ss_node_table_v2_idle_timeout').val());
				tmp_db.health_check_timeout = $.trim($('#ss_node_table_v2_health_check_timeout').val());
				tmp_db.permit_without_stream = $.trim($('#ss_node_table_v2_permit_without_stream').val());
			}			
		}
	}else if(flag == 'trojan'){
		tmp_db.v2ray_protocol = "trojan";
		tmp_db.password = $.trim($('#ss_node_table_password').val());
		tmp_db.tls = E("ss_node_table_v2_tls").checked ? '1' : '0';
		if(tmp_db.tls == "1"){
			tmp_db.tls_host = $.trim($('#ss_node_table_tls_host').val());
			tmp_db.insecure = E("ss_node_table_insecure").checked ? '1' : '0';
			tmp_db.tls_sessionTicket = $.trim($('#ss_node_table_tls_sessionTicket').val());
		}
	}else if(flag == 'hysteria'){	//helloworld-full
		tmp_db.type = "hysteria";	//helloworld-full
		tmp_db.v2ray_protocol = "hysteria";	//helloworld-full
		tmp_db.hy2_auth = $.trim($('#ss_node_table_hy2_auth').val());	//helloworld-full
		tmp_db.flag_obfs = $.trim($('#ss_node_table_flag_obfs').val());	//helloworld-full
		if(tmp_db.flag_obfs == "1"){	//helloworld-full
			tmp_db.salamander = $.trim($('#ss_node_table_salamander').val());	//helloworld-full
		}	//helloworld-full
		tmp_db.fast_open = E("ss_node_table_fast_open").checked ? '1' : '0';	//helloworld-full
		tmp_db.tls_host = $.trim($('#ss_node_table_tls_host').val());	//helloworld-full
		tmp_db.insecure = E("ss_node_table_insecure").checked ? '1' : '0';	//helloworld-full
		tmp_db.uplink_capacity = $.trim($('#ss_node_table_uplink_capacity').val());	//helloworld-full
		tmp_db.downlink_capacity = $.trim($('#ss_node_table_downlink_capacity').val());	//helloworld-full
	}

	dbus["ssconf_basic_json_" + node_idx] = Base64.encode(JSON.stringify(tmp_db));
	dbus["ssconf_basic_mode_" + node_idx] = $.trim($('#ss_node_table_mode').val());
	dbus["ssconf_basic_jsontype_" + node_idx] = "0";
	dbus["ssconf_basic_node_" + node_idx] = node_idx;
	//push data to add new node
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "dummy_script.sh", "params":[], "fields": dbus };
	$.ajax({
		type: "POST",
		cache:false,
		url: "/_api/",
		data: JSON.stringify(postData),
		dataType: "json",
		success: function(response) {
			refresh_table();
			if(add == 1)
				E("ss_node_table_server").value = "";
			if ((E("continue_add_box").checked) == false || add == 0) {
				E("ss_node_table_alias").value = "";
				E("ss_node_table_port").value = "";
				E("ss_node_table_password").value = "";
				E("ss_node_table_method").value = "aes-256-cfb";
				E("ss_node_table_v2_ivCheck").value = "none";
				E("ss_node_table_mode").value = "1";
				E("ss_node_table_plugin").value = "none"
				E("ss_node_table_plugin_opts").value = "";
				E("ss_node_table_protocol").value = "origin";
				E("ss_node_table_protocol_param").value = "";
				E("ss_node_table_obfs").value = "plain";
				E("ss_node_table_obfs_param").value = "";
				E("ss_node_table_v2_vmess_id").value = "";
				E("ss_node_table_v2_alter_id").value = "";
				E("ss_node_table_v2_protocol").value = "vmess";
				if(add == 1)
					cancel_add_rule();
			}
		}
	});

}
function add_ss_node_conf(flag) {
	node_max += 1;

	if(!$.trim($('#ss_node_table_alias').val())){
		alert("节点名不能为空！！");
		return false;
	}
	add_edit_node(flag, node_max, 1);
}
function remove_conf_table(o) {
	var id = $(o).attr("id");
	var ids = id.split("_");
	id = ids[ids.length - 1];
	if((parseInt(db_ss["ssconf_basic_node"]) == id) && db_ss["ssconf_basic_enable"] == "1"){
		alert("警告：这个节点正在运行，无法删除！")
		return false;
	}
	console.log("删除第", id, "个节点！！！")

	var dbus_tmp = {};
	var new_nodes = ss_nodes.concat()
	new_nodes.splice(new_nodes.indexOf(id), 1);
	//first: mark all node from ss_nodes data as empty
	for (var i = 0; i < ss_nodes.length; i++) {
		dbus_tmp["ssconf_basic_json_" + ss_nodes[i]] = "";
		dbus_tmp["ssconf_basic_jsontype_" + ss_nodes[i]] = "";
		dbus_tmp["ssconf_basic_mode_" + ss_nodes[i]] = "";
	}
	//second: rewrite new node data in order
	for (var i = 0; i < new_nodes.length; i++) {
		if(db_ss["ssconf_basic_json_" + new_nodes[i]])
			dbus_tmp["ssconf_basic_json_" + (i + 1)] = db_ss["ssconf_basic_json_" + new_nodes[i]];
		else
			dbus_tmp["ssconf_basic_json_" + (i + 1)] = "";
		if(db_ss["ssconf_basic_jsontype_" + ss_nodes[i]])
			dbus_tmp["ssconf_basic_jsontype_" + (i + 1)] = db_ss["ssconf_basic_jsontype_" + new_nodes[i]] || "0";
		else
			dbus_tmp["ssconf_basic_jsontype_" + (i + 1)] = "0";
		if(db_ss["ssconf_basic_mode_" + ss_nodes[i]])
			dbus_tmp["ssconf_basic_mode_" + (i + 1)] = db_ss["ssconf_basic_mode_" + new_nodes[i]] || "0";
		else
			dbus_tmp["ssconf_basic_mode_" + (i + 1)] = "";
	}
	//filer values
	var post_data = compfilter(db_ss, dbus_tmp);
	for (var key in post_data){
		if(key.indexOf("ssconf_basic_json_") != -1)
			post_data[key] = Base64.encode(post_data[key]);
	}
	//console.log("post_data:", post_data);
	//post_data
	var id_1 = parseInt(Math.random() * 100000000);
	var postData = {"id": id_1, "method": "dummy_script.sh", "params":[], "fields": post_data };
	$.ajax({
		type: "POST",
		cache:false,
		url: "/_api/",
		data: JSON.stringify(postData),
		dataType: "json",
		success: function(response) {
			$('#ss_node_list_table tr:nth-child(' + id + ')').remove();
			refresh_dbss();
			reorder_trs();
			refresh_options();
		}
	});
}

function edit_conf_table(o) {
	var p = "ss_node_table_";
	var id = $(o).attr("id");
	var ids = id.split("_");
	id = ids[ids.length - 1];
	edit_id = id;
	if((parseInt(db_ss["ssconf_basic_node"]) == id) && db_ss["ssconf_basic_enable"] == "1"){
		alert("提醒：这个节点正在运行！\n如果更改了其中的参数，需要重新点击【保存&应用】才能生效！")
	}
	var c = confs[id];
	conf2obj(c, p);
	var j = JSON.parse(c["json"]);

	E("cancelBtn").style.display = "";
	E("add_node").style.display = "none";
	E("edit_node").style.display = "";
	E("continue_add").style.display = "none";
	E("ssTitle").style.display = "none";
	E("ssrTitle").style.display = "none";
	E("v2rayTitle").style.display = "none";
	E("TrojanTitle").style.display = "none";
	E("HysteriaTitle").style.display = "none";	//helloworld-full
	if (j.v2ray_protocol == "shadowsocksr") {
		E("ssrTitle").style.display = "";
		$("#ssrTitle").html("编辑SSR账号");
		tabclickhandler(1);
	} else if (j.v2ray_protocol == "vmess" || j.v2ray_protocol == "vless") {
		E("v2rayTitle").style.display = "";
		$("#v2rayTitle").html("编辑V2Ray账号");
		tabclickhandler(2);
	}else if (j.v2ray_protocol == "shadowsocks") {
		E("ssTitle").style.display = "";
		$("#ssTitle").html("编辑ss账号");
		tabclickhandler(0);
	}else if (j.v2ray_protocol == "trojan") {
		E("TrojanTitle").style.display = "";
		$("#TrojanTitle").html("编辑Trojan账号");
		tabclickhandler(3);
	}else if (j.v2ray_protocol == "hysteria") {	//helloworld-full
		E("HysteriaTitle").style.display = "";	//helloworld-full
		$("#HysteriaTitle").html("编辑Hysteria账号");	//helloworld-full
		tabclickhandler(4);	//helloworld-full
	}
	if(E("ssconf_basic_row").value == "all"){
		var pos = $("#node_" + id)[0].offsetTop - 200;
		pos = pos < 0 ? 0 : pos;
		$(".contentM_qis").css("top", pos + "px");
	}else{
		$(".contentM_qis").css("top", "0px");
	}
	$('body').prepend(tableApi.genFullScreen());
	$('.fullScreen').fadeIn(300);
	$("#vpnc_settings").fadeIn(300);
}
function edit_ss_node_conf(flag) {
	add_edit_node(flag, edit_id, 0);
	$("#vpnc_settings").fadeOut(300);
	$("body").find(".fullScreen").fadeOut(300, function() { tableApi.removeElement("fullScreen"); });
}

function generate_node_info() {
	//console.log("节点排列情况:", ss_nodes);
	//console.log("共有节点数量:", node_nu, "个");
	//console.log("最大节点序号:", node_max);
	//console.log("当前节点位置:", node_idx);
	//console.log("正在使用节点:", parseInt(db_ss["ssconf_basic_node"])||"");

	// 没有节点的时候，弹出添加节点的layer层
	if (node_nu == 0 && poped == 0) pop_node_add();
	// 生成节点对象，用于节点表格、节点下拉表等的制作
	confs = {};
	for (var j = 0; j < ss_nodes.length; j++) {
		var idx = ss_nodes[j];
		var obj = {};
		//写入节点index
		obj["node"] = idx;
		//write node type
		if (typeof(db_ss["ssconf_basic_json_" + idx]) != "undefined"){
			obj["json"] = db_ss["ssconf_basic_json_" + idx];
			obj["mode"] = db_ss["ssconf_basic_mode_" + idx];
			if(db_ss["ssconf_basic_json_" + idx].v2ray_protocol == "shadowsocks")
				obj["type"] = "0";
			else if(db_ss["ssconf_basic_json_" + idx].v2ray_protocol == "shadowsocksr")
				obj["type"] = "1";
			else if(db_ss["ssconf_basic_json_" + idx].v2ray_protocol == "vmess" || db_ss["ssconf_basic_json_" + idx].v2ray_protocol == "vless")
				obj["type"] = "2";
			else if(db_ss["ssconf_basic_json_" + idx].v2ray_protocol == "trojan")
				obj["type"] = "3";
			else if(db_ss["ssconf_basic_json_" + idx].v2ray_protocol == "hysteria")
				obj["type"] = "4";
		}

		//生成一个节点的所有信息到对应对象
		if (obj != null) {
			confs[idx] = obj;
		}
	}
	//console.log("所有节点信息：", confs);
}
function refresh_table() {
	$.ajax({
		type: "GET",
		url: "/_api/ssconf",
		dataType: "json",
		cache:false,
		async: false,
		success: function(data) {
			db_ss = data.result[0];
			confdecode(db_ss);
			generate_node_info();
			refresh_options();
			refresh_html();
		}
	});
}
function refresh_html() {
	//console.log("refresh_html");
	// how many row to show
	var pageH = parseInt(E("FormTitle").style.height.split("px")[0]);
	var nodeT = 304;
	if(db_ss["ssconf_basic_row"]){
		if(db_ss["ssconf_basic_row"] == "all"){
			nodeN = node_nu;
		}else{
			nodeN = parseInt(db_ss["ssconf_basic_row"]);
		}
	}
	if(node_nu < 15) nodeN = node_nu;
	var nodeL  = parseInt((pageH-nodeT)/trsH) - 3;
	nodeH = nodeN*trsH
	if (nodeN > nodeL){
		//var maxH = node_nu*trsH + trsH
		$("#ss_list_table").attr("style", "height:" + (nodeH + trsH) + "px");
	}else{
		$("#ss_list_table").removeAttr("style");
	}

	//console.log("页面整体高度：", pageH);
	//console.log("最大能显示行：", nodeL);
	//console.log("定义的显示行：", nodeN);
	//console.log("实际显示的行：", ss_nodes.length);
	//console.log("节点列表上界：", nodeT);
	//console.log("节点列表高度：", nodeH);
	// write option to ssconf_basic_row 
	$("#ssconf_basic_row").find('option').remove().end();
	for (var i = 10; i <= nodeL; i++) {
		$("#ssconf_basic_row").append('<option value="' + i + '">' + i + '</option>');
	}
	if (node_nu > nodeL){
		$("#ssconf_basic_row").append('<option value="all">全部显示</option>');
	}
	E("ssconf_basic_row").value = db_ss["ssconf_basic_row"]||nodeL;
	
	// define col width in different situation
	if(node_nu && E("ssconf_basic_ping_node") != "off" && E("ssconf_basic_ping_node") != ""){
		var width = ["", "5%", "30%", "30%", "8%", "12%", "10%", "5%", ];
	}else{
		var width = ["", "6%", "32%", "32%", "10%", "10%", "10%" ];
	}
	// make dynamic element
	var html = '';
	html += '<div class="nodeTable" style="height:' + trsH + 'px; margin: -1px 0px 0px 0px; width: 750px;">'
	html += '<table width="750px" border="0" align="center" cellpadding="4" cellspacing="0" class="FormTable_table" style="margin:-1px 0px 0px 0px;">'
	html += '<tr height="' + trsH + 'px">'
	html += '<th style="width:' + width[1] + ';">序号</th>'
	html += '<th style="width:' + width[2] + ';cursor:pointer" onclick="hide_name();" title="点我隐藏节点名称信息!" >节点名称</th>'
	html += '<th style="width:' + width[3] + ';cursor:pointer" onclick="hide_server();" title="点我隐藏服务器信息!" >服务器地址</th>'
	html += '<th style="width:' + width[4] + ';">类型</th>'
	if(node_nu && db_ss["ssconf_basic_ping_node"] != "off" && E("ssconf_basic_ping_node") != ""){
		html += '<th style="width:' + width[5] + ';" id="ping_th">ping/丢包</th>'
	}
	html += '<th style="width:' + width[6] + ';">编辑</th>'
	html += '<th style="width:' + width[7] + ';">使用</th>'
	html += '</tr>'
	html += '</table>'
	html += '</div>'
	
	//html += '<div class="nodeTable" style="top: ' + nodeT + 'px; width: 750px; height: ' + nodeH + 'px; overflow: hidden; position: absolute;">'
	html += '<div class="nodeTable" style="width: 750px; height: ' + nodeH + 'px; overflow: hidden;">'
	html += '<div id="ss_node_list_table_main" style="width: 750px; height: ' + nodeH + 'px; overflow: hidden scroll; padding-right: 35px;">'
	html += '<table id="ss_node_list_table" style="margin:-1px 0px 0px 0px;" width="750px" border="0" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="list_table">'
	
	for (var i = 0; i < ss_nodes.length; i++) {
		var c = confs[ss_nodes[i]];
		var j = JSON.parse(c["json"]);
	//for (var field in confs) {
		//var c = confs[field];
		html += '<tr id="node_' + c["node"] + '">';
		//序号
		html +='<td style="width:' + width[1] + ';" id="node_order_' + (i + 1) + '" class="dragHandle">' + (i + 1) + '</td>';
		//节点名称
		//html += '<td style="width:' + width[2] + ';" class="dragHandle node_name" title="' + c["group"] + '&#10;' + c["name"] + '" id="ss_node_name_' + c["node"] + '" onMouseOver="show_info(this)">'
		html += '<td style="width:' + width[2] + ';" class="dragHandle node_name" title="' + j.alias + '" id="ss_node_name_' + c["node"] + '">'
		html += '<div class="shadow1" style="display: none;"></div>'
		html += '<div class="nickname">' + j.alias + '</div>';
		html += '</td>';
		//server
		html += '<td style="width:' + width[3] + ';" class="node_server" id="server_' + c["node"] + '">';
		html += '<div style="display: none;" class="shadow2"></div>';
		html += '<div class="server">' + j.server + '</div>';
		html += '</td>';
		//节点类型
		html +='<td style="width:' + width[4] + ';">';
		if(j.v2ray_protocol == "shadowsocks")
			html +='ss';
		else if(j.v2ray_protocol == "shadowsocksr")
			html +='ssr';
		else if(j.v2ray_protocol == "vmess" || j.v2ray_protocol == "vless")
			html +='v2ray';
		else if(j.v2ray_protocol == "trojan")
			html +='trojan';
		else if(j.v2ray_protocol == "hysteria")
			html +='hysteria';
		html +='</td>';
		//ping/丢包
		if(node_nu && db_ss["ssconf_basic_ping_node"] != "off" && E("ssconf_basic_ping_node") != ""){
			html += '<td style="width:' + width[5] + ';" id="ss_node_ping_' + c["node"] + '" class="ping"></td>';
		}
		//节点编辑
		html += '<td style="width:' + width[6] + ';">'
		html += '<input style="margin:-2px 0px -4px -2px;" id="dd_node_' + c["node"] + '" class="edit_btn" type="button" onclick="edit_conf_table(this);" value=""><input style="margin:-2px 0px -4px -2px;" id="td_node_' + c["node"] + '" class="remove_btn" type="button" onclick="remove_conf_table(this);" value="">'
		html += '</td>';
		//节点应用
		html += '<td style="width:' + width[7] + ';">'
		html += '<div class="deactivate_icon" id="apply_ss_node_' + c["node"] + '" onclick="apply_this_ss_node(this);"></div>';
		html += '</td>';
		html += '</tr>';
	}
	html += '</table>'
	html += '</div>'
	html += '</div>'
	// botton region
	html += '<div align="center" class="nodeTable" id="node_button" style="width: 750px;margin-top:20px">'
	html += '<input style="margin-left:10px" id="add_ss_node" class="button_gen" onClick="Add_profile()" type="button" value="添加节点"/>'
	if(node_nu){
		html += '<input style="margin-left:10px" class="button_gen" type="button" onclick="save()" value="保存&应用">'
	}
	html += '<input id="reset_select" style="margin-left:10px; display:none" class="button_gen" onClick="select_default_node(1)" type="button" value="取消"/>'
	html += '</div>'
	// remove dynamic table
	$('.nodeTable').remove();
	// add dynamic table
	$('#ss_list_table').before(html);
	if(node_max != 0 && node_max != node_nu ){
		console.log("自动调整顺序！")
		save_new_order();
	}
	// ask or not ask for ping
	if(E("ssconf_basic_ping_node").value != "off" && E("ssconf_basic_ping_node").value != ""){
		if(ping_result != ""){
			write_ping(ping_result);
		}else{
			ping_test();
		}
	}
	// select default node
	select_default_node(2);
	// make row moveable
	if(E("ssconf_basic_dragable").checked){
		order_adjustment();
	}
	var params_input = ["ssconf_failover_s1", "ssconf_failover_s2_1", "ssconf_failover_s2_2", "ssconf_failover_s3_1", "ssconf_failover_s3_2", "ssconf_failover_s4_1", "ssconf_failover_s4_2", "ssconf_failover_s4_3", "ssconf_failover_s5", "ssconf_basic_interval", "ssconf_basic_row", "ssconf_basic_ping_node", "ssconf_basic_ping_method", "ssconf_dns_china", "ssconf_foreign_dns", "ssconf_basic_kcp_lserver", "ssconf_basic_kcp_lport", "ssconf_basic_kcp_server", "ssconf_basic_kcp_port", "ssconf_basic_kcp_parameter", "ssconf_basic_rule_update", "ssconf_basic_rule_update_time", "ssconf_subscribe_mode", "ssconf_basic_online_links_goss", "ssconf_basic_node_update", "ssconf_basic_node_update_day", "ssconf_basic_node_update_hr", "ssconf_basic_exclude", "ssconf_basic_include", "ssconf_base64_links", "ssconf_acl_default_port", "ssconf_acl_default_mode", "ssconf_basic_kcp_password", "ssconf_reboot_check", "ssconf_basic_week", "ssconf_basic_day", "ssconf_basic_inter_min", "ssconf_basic_inter_hour", "ssconf_basic_inter_day", "ssconf_basic_inter_pre", "ssconf_basic_time_hour", "ssconf_basic_time_min", "ssconf_basic_tri_reboot_time", "ssconf_basic_server_resolver", "ssconf_failover_enable", "ssconf_failover_c1", "ssconf_failover_c2", "ssconf_failover_c3", "ssconf_basic_tablet", "ssconf_basic_netflix_enable", "ssconf_basic_dragable", "ssconf_basic_enable", "ssconf_basic_gfwlist_update", "ssconf_basic_tfo", "ssconf_basic_chnroute_update", "ssconf_basic_cdn_update", "ssconf_basic_dns_hijack", "ssconf_basic_mcore"];
	var _base64 = ["ssconf_dnsmasq", "ssconf_wan_white_ip", "ssconf_wan_white_domain", "ssconf_wan_black_ip", "ssconf_wan_black_domain", "ssconf_online_links", "ssconf_basic_custom"];
	for (var i = 0; i < _base64.length; i++) {
		if(db_ss[_base64[i]])
			E(_base64[i]).value = Base64.decode(db_ss[_base64[i]]);
	}
	for (var i = 0; i < params_input.length; i++) {
		var el = E(params_input[i]);
		if (el != null && el.getAttribute("type") == "checkbox" && db_ss[params_input[i]]) {
			el.checked = db_ss[params_input[i]] == "1" ? true:false;
			continue;
		}
		if (el != null && db_ss[params_input[i]]) {
			el.value = db_ss[params_input[i]];
		}
	}
}
function hide_name(){
	//var sw = $(".node_name").width();
	var sw = $(".node_name")[0].clientWidth - 4;
	if($(".shadow1").css("display") == "block"){
		$(".nickname").show(300);
		$(".shadow1").hide(300);
	}else{
		$(".nickname").hide(300);
		$(".shadow1").show(300);
		$(".shadow1").css("width", sw)
	}
}
function hide_server(){
	//var sw = $(".node_server").width();
	var sw = $(".node_server")[0].clientWidth - 4;
	if($(".shadow2").css("display") == "block"){
		$(".server").show(300);
		$(".shadow2").hide(300);
	}else{
		$(".server").hide(300);
		$(".shadow2").show(300);
		$(".shadow2").css("width", sw)
	}
}
function order_adjustment(){
	$("#ss_node_list_table").tableDnD({
		dragHandle: ".dragHandle",
		onDragClass: "myDragClass",
		onDrop: function() {
			save_new_order();
		}
	});
	$("#ss_node_list_table tr").hover(function() {
		  $(this.cells[0]).addClass('showDragHandle');
		  $(this.cells[1]).addClass('showDragHandle');
	}, function() {
		  $(this.cells[0]).removeClass('showDragHandle');
		  $(this.cells[1]).removeClass('showDragHandle');
	});
}
function save_new_order(){
	getNowFormatDate();
	var table = E("ss_node_list_table");
	var tr = table.getElementsByTagName("tr");
	var dbus_tmp = {};

	//first: mark all node from ss_nodes data as empty
	for (var i = 0; i < tr.length; i++) {
		var rowid = tr[i].getAttribute("id").split("_")[1];
		dbus_tmp["ssconf_basic_json_" + rowid] = "";
		dbus_tmp["ssconf_basic_jsontype_" + rowid] = "";
		dbus_tmp["ssconf_basic_mode_" + rowid] = "";
	}
	//second: write new data in order
	for (var i = 0; i < tr.length; i++) {
		var rowid = tr[i].getAttribute("id").split("_")[1];
		// 如果移动的节点是正在使用的，需要更改到新的位置
		if(db_ss["ssconf_basic_node"] == rowid){
			dbus_tmp["ssconf_basic_node"] = String(i+1);
		}
		// 如果移动的节点是备用节点的，需要更改到新的位置
		if(db_ss["ssconf_failover_s4_3"] && db_ss["ssconf_failover_s4_3"] == rowid){
			dbus_tmp["ssconf_failover_s4_3"] = String(i+1);
		}
		// 生成新的所有节点的信息
		if(db_ss["ssconf_basic_json_" + rowid])
			dbus_tmp["ssconf_basic_json_" + (i + 1)] = db_ss["ssconf_basic_json_" + rowid];
		else
			dbus_tmp["ssconf_basic_json_" + (i + 1)] = "";
		if(db_ss["ssconf_basic_jsontype_" + rowid])
			dbus_tmp["ssconf_basic_jsontype_" + (i + 1)] = db_ss["ssconf_basic_jsontype_" + rowid] || "0";
		else
			dbus_tmp["ssconf_basic_jsontype_" + (i + 1)] = "";
		if(db_ss["ssconf_basic_mode_" + rowid])
			dbus_tmp["ssconf_basic_mode_" + (i + 1)] = db_ss["ssconf_basic_mode_" + rowid] || "1";
		else
			dbus_tmp["ssconf_basic_mode_" + (i + 1)] = "";
	}

	//filer values
	var post_data = compfilter(db_ss, dbus_tmp);
	for (var key in post_data){
		if(key.indexOf("ssconf_basic_json_") != -1)
			post_data[key] = Base64.encode(post_data[key]);
	}
	//console.log("post_data:", post_data);
	//post data
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "dummy_script.sh", "params":[], "fields": post_data };
	$.ajax({
		type: "POST",
		cache:false,
		url: "/_api/",
		data: JSON.stringify(postData),
		dataType: "json",
		success: function(response) {
			refresh_dbss();
			reorder_trs();
			refresh_options();
			getNowFormatDate();
			ss_node_sel();
		}
	});
}
function reorder_trs(){
	var trs = $("#ss_node_list_table tr");
	for (var i = 0; i < trs.length; i++) {
		// 改写显示的顺序
		var new_nu = i + 1;
		//tr
		$('#ss_node_list_table tr:nth-child(' + new_nu + ')').attr("id", "node_" + new_nu);
		//$('#ss_node_list_table tr:nth-child(' + new_nu + ')').removeAttr("class");
		//$('#ss_node_list_table tr:nth-child(' + new_nu + ')').removeAttr("style");
		//序号
		$('#ss_node_list_table tr:nth-child(' + new_nu + ') td:nth-child(1)').attr("id", "node_order_" + new_nu);
		$('#ss_node_list_table tr:nth-child(' + new_nu + ') td:nth-child(1)').html(String(new_nu));
		//节点名称
		$('#ss_node_list_table tr:nth-child(' + new_nu + ') td:nth-child(2)').attr("id", "ss_node_name_" + new_nu);
		//服务器地址
		$('#ss_node_list_table tr:nth-child(' + new_nu + ') td:nth-child(3)').attr("id", "server_" + new_nu);
		//类型
		$('#ss_node_list_table tr:nth-child(' + new_nu + ') td:nth-child(4)').attr("id", "server_" + new_nu);
		if($('#ss_node_list_table tr:nth-child(' + new_nu + ') td:nth-child(5)').attr("id") != undefined){
			//ping/丢包
			$('#ss_node_list_table tr:nth-child(' + new_nu + ') td:nth-child(5)').attr("id", "ss_node_ping_" + new_nu);
			//编辑节点
			$('#ss_node_list_table tr:nth-child(' + new_nu + ') td:nth-child(6) input:nth-child(1)').attr("id", "dd_node_" + new_nu);
			$('#ss_node_list_table tr:nth-child(' + new_nu + ') td:nth-child(6) input:nth-child(2)').attr("id", "td_node_" + new_nu);
			//应用节点
			$('#ss_node_list_table tr:nth-child(' + new_nu + ') td:nth-child(7) div').attr("id", "apply_ss_node_" + new_nu);
		}else{
			//编辑节点
			$('#ss_node_list_table tr:nth-child(' + new_nu + ') td:nth-child(5) input:nth-child(1)').attr("id", "dd_node_" + new_nu);
			$('#ss_node_list_table tr:nth-child(' + new_nu + ') td:nth-child(5) input:nth-child(2)').attr("id", "td_node_" + new_nu);
			//应用节点
			$('#ss_node_list_table tr:nth-child(' + new_nu + ') td:nth-child(6) div').attr("id", "apply_ss_node_" + new_nu);
		}
	}
	//console.log("更改顺序OK");
}
function select_default_node(o){
	var sel_node = E("sstable_node").value || "1";
	$(".activate_icon").addClass("deactivate_icon");
	$(".activate_icon").removeClass("activate_icon");
	if (sel_node != db_ss["ssconf_basic_node"]){
		E("reset_select").style.display = "";
	}else{
		E("reset_select").style.display = "none";
	}
	if(o == 1){
		//定义取消按钮点击行为
		if(db_ss["ssconf_basic_enable"] == "1"){
			//开启开关，节点选择为db_ss["ssconf_basic_node"]
			E("ssconf_basic_enable").checked = true;
			$("#apply_ss_node_" + db_ss["ssconf_basic_node"]).addClass("activate_icon");
			$("#apply_ss_node_" + db_ss["ssconf_basic_node"]).removeClass("deactivate_icon");
			if(node_idx && node_nu > nodeN){
				var rows2scroll = parseInt(((node_idx*trsH - nodeH*0.5)/trsH));
				E("ss_node_list_table_main").scrollTop = rows2scroll*trsH;
			}
		}else{
			//关闭开关，则清除节点的勾选
			E("ssconf_basic_enable").checked = false;
		}
	}else if(o == 2){
		//定义点击总开关行为 + 表格加载完毕行为
		if(E("ssconf_basic_enable").checked){
			//用户点击开启了总开关，节点选择为db_ss["ssconf_basic_node"]，没有就默认选1
			$("#apply_ss_node_" + sel_node).addClass("activate_icon");
			$("#apply_ss_node_" + sel_node).removeClass("deactivate_icon");
			if(node_idx && node_nu > nodeN){
				var rows2scroll = parseInt(((node_idx*trsH - nodeH*0.5)/trsH));
				E("ss_node_list_table_main").scrollTop = rows2scroll*trsH;
			}
		}
	}else if(o == 3){
		//从其它标签切换到节点列表行为
		if(E("ssconf_basic_enable").checked){
			$("#apply_ss_node_" + sel_node).addClass("activate_icon");
			$("#apply_ss_node_" + sel_node).removeClass("deactivate_icon");
			node_idx_1 = $.inArray(E("sstable_node").value, ss_nodes) + 1;
			if(node_idx_1 && node_nu > nodeN){
				var rows2scroll = parseInt(((node_idx_1*trsH - nodeH*0.5)/trsH));
				E("ss_node_list_table_main").scrollTop = rows2scroll*trsH;
			}
		}
	}
}
function apply_this_ss_node(rowdata) {
	cancel_add_rule();
	var enable_id = $(rowdata).attr("id");
	var enable_id = enable_id.split("_")[3];
	var $activateItem = $(rowdata);
	var flag = $activateItem.hasClass("activate_icon") ? "disconnect" : "connect";
	$(".activate_icon").addClass("deactivate_icon");
	$(".activate_icon").removeClass("activate_icon");
	if(flag == "disconnect") {
		$activateItem.addClass("deactivate_icon");
		$activateItem.removeClass("activate_icon");
		E("reset_select").style.display = ""
		E("ssconf_basic_enable").checked = false;
	}else {
		$activateItem.addClass("activate_icon");
		$activateItem.removeClass("deactivate_icon");
		dbus["ssconf_basic_node"] = enable_id;
		if(db_ss["ssconf_basic_node"] != enable_id){
			E("reset_select").style.display = ""
		}else{
			E("reset_select").style.display = "none"
		}
		E("ssconf_basic_enable").checked = true;
	}
	E("sstable_node").value = enable_id;
	ss_node_sel();
}

function ping_switch() {
	//当ping功能关闭时，保存ssconf_basic_ping_node的关闭值，然后刷新表格以隐藏ping显示
	var dbus_post = {};
	if(E("ssconf_basic_ping_node").value == "off" || E("ssconf_basic_ping_node").value == ""){
		E("ssconf_basic_ping_method").style.display = "none";
		E("sstable_ping_btn").style.display = "none";
		dbus_post["ssconf_basic_ping_node"] = "off";
		//now post
		var id = parseInt(Math.random() * 100000000);
		var postData = {"id": id, "method": "dummy_script.sh", "params":[], "fields": dbus_post};
		$.ajax({
			type: "POST",
			cache:false,
			url: "/_api/",
			data: JSON.stringify(postData),
			dataType: "json",
			success: function(response) {
				if (response.result == id){
					//清空内存中的ping结果，在未刷新界面情况下，下次打开ping功能就能重新请求了
					ping_result = "";
					$(".show-btn1").trigger("click");
					refresh_table();
				}
			}
		});
	}else{
		E("ssconf_basic_ping_method").style.display = "";
		E("sstable_ping_btn").style.display = "";
	}
}
function ping_now() {
	//点击【开始ping！】，需要重新请求一次后台脚本来ping，所以刷新一次表格，然后ping
	var dbus_post = {};
	dbus_post["ssconf_basic_ping_node"] = E("ssconf_basic_ping_node").value;
	dbus_post["ssconf_basic_ping_method"] = E("ssconf_basic_ping_method").value;

	//now post
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "dummy_script.sh", "params":[], "fields": dbus_post};
	$.ajax({
		type: "POST",
		cache:false,
		url: "/_api/",
		data: JSON.stringify(postData),
		dataType: "json",
		success: function(response) {
			if (response.result == id){
				//清空内存中的ping结果，表格渲染完成后会重新请求的
				ping_result = "";
				$(".show-btn1").trigger("click");
				refresh_table();
			}
		}
	});
}
function ping_test() {
	//提交ping请求，拿到ping结果
	if(E("ssconf_basic_ping_node").value == "off" || E("ssconf_basic_ping_node").value == ""){
		return false;
	}else if(E("ssconf_basic_ping_node").value == "0"){
		$(".ping").html("测试中...");
	}else{
		$(".ping").html("");
		$("#ss_node_ping_" + E("ssconf_basic_ping_node").value).html("测试中...");
	}
	//now post
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "ss_ping.sh", "params":[], "fields": ""};
	$.ajax({
		type: "POST",
		async: true,
		cache:false,
		url: "/_api/",
		data: JSON.stringify(postData),
		dataType: "json",
		success: function(response) {
			get_result();
		},
		error: function(XmlHttpRequest, textStatus, errorThrown){
			//console.log(XmlHttpRequest.responseText);
			$(".ping").html("失败!");
		},
		timeout: 60000
	});
}
function get_result() {
	$.ajax({
		type: "GET",
		async: true,
		cache:false,
		url: "/_temp/ping.log",
		dataType: "text",
		success: function(response) {
			if (response.search("XU6J03M6") != -1) {
				write_ping(response.replace("XU6J03M6", " "));
			} else 
				setTimeout("get_result();", 500);
		},
		error: function(){
			setTimeout("get_result();", 1000);
		}
	});
}
function write_ping(r){
	if(E("ssconf_basic_ping_node") == "off"){
		return false;
	}
	if ((String(r)).length <= 2){
		if(db_ss["ssconf_basic_ping_node"] == "0"){
			$(".ping").html("超时！");
		}else{
			$(".ping").html("");
			$("#ss_node_ping_" + db_ss["ssconf_basic_ping_node"]).html("超时！");
		}
	}else{
		ping_result = r;
		ps = eval(Base64.decode(r));
		for(var i = 0; i<ps.length; i++){
			var nu = parseInt(ps[i][0]);
			var ping = parseFloat(ps[i][1]);
			var loss = ps[i][2];
			if (!ping){
				if(E("ssconf_basic_ping_method").value == 1){
					test_result = '<font color="#FF0000">failed</font>';
				}else{
					if(loss == ""){
						test_result = '<font color="#FF0000">failed</font>';
					}else{
						test_result = '<font color="#FF0000">failed/' + loss + '</font>';
					}
				}
			}else{
				if(E("ssconf_basic_ping_method").value == 1){
					$('#ping_th').html("ping");
					if (ping <= 50){
						test_result = '<font color="#1bbf35">' + ping.toPrecision(3) +'ms</font>';
					}else if (ping > 50 && ping <= 100) {
						test_result = '<font color="#3399FF">' + ping.toPrecision(3) +'ms</font>';
					}else{
						test_result = '<font color="#f36c21">' + ping.toPrecision(3) +'ms</font>';
					}
				}else{
					$('#ping_th').html("ping/丢包");
					if (ping <= 50){
						test_result = '<font color="#1bbf35">' + ping.toPrecision(3) +'ms/' + loss + '</font>';
					}else if (ping > 50 && ping <= 100) {
						test_result = '<font color="#3399FF">' + ping.toPrecision(3) +'ms/' + loss + '</font>';
					}else{
						test_result = '<font color="#f36c21">' + ping.toPrecision(3) +'ms/' + loss + '</font>';
					}
				}
			}
			if($('#ss_node_ping_' + nu))
				$('#ss_node_ping_' + nu).html(test_result);
		}
	}
}
function save_row(action) {
	var dbus_post = {};
	//设定要显示的节点列表行数
	dbus_post["ssconf_basic_row"] = E("ssconf_basic_row").value;
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "dummy_script.sh", "params":[], "fields": dbus_post};
	$.ajax({
		type: "POST",
		cache:false,
		url: "/_api/",
		data: JSON.stringify(postData),
		dataType: "json",
		success: function(response) {
			if (response.result == id){
				$(".show-btn1").trigger("click");
				refresh_table();
			}
		}
	});
}

function updatelist(arg) {
	var dbus_post = {};
	db_ss["ssconf_basic_action"] = "8";
	dbus_post["ssconf_basic_rule_update"] = E("ssconf_basic_rule_update").value;
	dbus_post["ssconf_basic_rule_update_time"] = E("ssconf_basic_rule_update_time").value;
	dbus_post["ssconf_basic_gfwlist_update"] = E("ssconf_basic_gfwlist_update").checked ? '1' : '0';
	dbus_post["ssconf_basic_chnroute_update"] = E("ssconf_basic_chnroute_update").checked ? '1' : '0';
	dbus_post["ssconf_basic_cdn_update"] = E("ssconf_basic_cdn_update").checked ? '1' : '0';
	push_data("ss_rule_update.sh", arg,  dbus_post);
}
function version_show() {
	if(!db_ss["ssconf_basic_version_local"]) db_ss["ssconf_basic_version_local"] = "0.0.0"
	$("#ss_version_show").html("<a class='hintstyle' href='javascript:void(0);'><i>当前版本：" + db_ss['ssconf_basic_version_local'] + "</i></a>");
	if(db_scarch["softcenter_arch"]=="armv7l")
		scarch="arm";
	else if(db_scarch["softcenter_arch"]=="aarch64")
		scarch="arm64";
	else
		scarch=db_scarch["softcenter_arch"];
	$.ajax({
		url: 'https://raw.githubusercontent.com/zusterben/plan_f/master/bin/version.json.js',
		type: 'GET',
		dataType: 'json',
		success: function(res) {
			if (typeof(res["version"]) != "undefined" && res["version"].length > 0) {
				if (versionCompare(res["version"], db_ss["ssconf_basic_version_local"])) {
					$("#updateBtn").html("<i>升级到：" + res.version + "</i>");
				}
			}
		}
	});
}
function message_show() {
	if (db_ss["ssconf_close_mesg"] == "0") return
	$.ajax({
		url: 'https://gist.githubusercontent.com/zusterben/9603cd181504b88cb82fd2f925a20550/raw/helloworld_msg.json?_=' + new Date().getTime(),
		type: 'GET',
		dataType: 'json',
		cache: false,
		success: function(res) {
			var rand_1 = parseInt(Math.random() * 100)
			// 通知1，一般通知下更新日志，如果已经升级到最新版本，则不再显示更新日志
			if (res["msg_1"] && res["switch_1"]){
				if (rand_1 < res["switch_1"]){
					if (versionCompare(res["version"], db_ss["ssconf_basic_version_local"])) {
						$("#fixed_msg").append('<li id="msg_1" style="list-style: none;height:23px">' + res["msg_1"] + '</li>');
					}
				}
			}
			// 通知2，其它重要通知的时候使用
			if (res["msg_2"] && res["switch_2"]){
				if (rand_1 < res["switch_2"]){
					$("#fixed_msg").append('<li id="msg_2" style="list-style: none;height:23px">' + res["msg_2"] + '</li>');
				}
			}
			// 广告位，广告不能放太多，要优质，稍多的话限制显示数量，以滚动形式显示，免得太碍人眼
			var ads_count = 0;
			var rand_2 = parseInt(Math.random() * 100)
			for(var i = 3; i < 10; i++){
				if (res["msg_" + i] && res["switch_" + i]){
					if (rand_2 < res["switch_" + i]){
						$("#scroll_msg").append('<li id="msg_' + i + '" style="list-style: none;height:23px">' + res["msg_" + i] + '</li>');
						ads_count++;
					}
				}
			}
			// 如果只有两个广告，就全部显示，且不进行滚动
			//console.log(ads_count + "个广告！")
			if (ads_count == 0) return;
			if (ads_count <= 2){
				$("#scroll_msg").css("height", (ads_count * 23) + "px");
				return;
			}
			//超过两个广告，则广告显示高度为推送的高度
			if (res["scroll_line"]){
				$("#scroll_msg").css("height", (res["scroll_line"] * 23) + "px");
			}else{
				$("#scroll_msg").css("height", "23px");
			}
			//鼠标放上广告停止滚动
			$("#scroll_msg").on("mouseover", function() {
				stop_scroll = 1;
			});
			//鼠标移开恢复滚动
			$("#scroll_msg").on("mouseleave", function() {
				stop_scroll = 0;
			});
			//开始滚动，每个广告停留5s
			if (res["ads_time"]){
				setInterval("scroll_msg();", res["ads_time"]);
			}else{
				setInterval("scroll_msg();", 5000);
			}
		},
		error: function(XmlHttpRequest, textStatus, errorThrown){
			console.log(XmlHttpRequest.responseText);
		}
	});
}
function scroll_msg() {
	if(stop_scroll == 0) {
		$('#scroll_msg').stop().animate({scrollTop: 23}, 500, 'swing', function() {
			$(this).find('li:last').after($('li:first', this));
		});
	}
}
function update_ss() {
	var dbus_post = {};
	db_ss["ssconf_basic_action"] = "7";
	push_data("ss_update.sh", "update",  dbus_post);
}

function tabSelect(w) {
	for (var i = 0; i <= 10; i++) {
		$('.show-btn' + i).removeClass('active');
		$('#tablet_' + i).hide();
	}
	$('.show-btn' + w).addClass('active');
	$('#tablet_' + w).show();
}

function toggle_func() {
	$("#ssconf_basic_enable").click(
	function() {
		select_default_node(2);
		if (E("ssconf_basic_enable").checked) {
			if(node_max == 0){
				alert("你还没有任何节点，无法开启！");
				return false;
			}
			E("reset_select").style.display = db_ss["ssconf_basic_enable"] == "1" ? "none":"";
		}else{
			E("reset_select").style.display = db_ss["ssconf_basic_enable"] == "1" ? "":"none";
		}
	});
	$(".show-btn0").click(
		function() {
			tabSelect(0);
			$('#apply_button').show();
			ss_node_sel();
		});
	$(".show-btn1").click(
		function() {
			tabSelect(1);
			$('#apply_button').hide();
			$(".nodeTable").show();
			select_default_node(3);
		});
	$(".show-btn2").click(
		function() {
			tabSelect(2);
			$('#apply_button').hide();
			verifyFields();
		});
	$(".show-btn3").click(
		function() {
			tabSelect(3);
			$('#apply_button').show();
			update_visibility();
			autoTextarea(E("ssconf_dnsmasq"), 0, 500);
		});
	$(".show-btn4").click(
		function() {
			tabSelect(4);
			$('#apply_button').show();
			autoTextarea(E("ssconf_wan_white_ip"), 0, 400);
			autoTextarea(E("ssconf_wan_white_domain"), 0, 400);
			autoTextarea(E("ssconf_wan_black_ip"), 0, 400);
			autoTextarea(E("ssconf_wan_black_domain"), 0, 400);
		});
	$(".show-btn5").click(
		function() {
			tabSelect(5);
			$('#apply_button').show();
			verifyFields();
			autoTextarea(E("ssconf_kcp_parameter"), 0, 100);
		});
	$(".show-btn6").click(
		function() {
			tabSelect(6);
			$('#apply_button').hide();
			update_visibility();
		});
	$(".show-btn7").click(
		function() {
			tabSelect(7);
			$('#apply_button').show();
			refresh_acl_table();
			//update_visibility();
		});
	$(".show-btn8").click(
		function() {
			tabSelect(8);
			$('#apply_button').show();
			update_visibility();
		});
	$(".show-btn9").click(
		function() {
			tabSelect(9);
			$('#apply_button').hide();
			get_log();
		});
	$("#update_log").click(
		function() {
			window.open("https://github.com/zusterben/plan_f");
		});
	$("#log_content2").click(
		function() {
			x = -1;
		});
	$(".sub-btn1").click(
	function() {
		$('.sub-btn1').addClass('active2');
		$('.sub-btn2').removeClass('active2');
		verifyFields()
	});
	$(".sub-btn2").click(
	function() {
		$('.sub-btn1').removeClass('active2');
		$('.sub-btn2').addClass('active2');
		verifyFields()
	});
	var default_tab = parseInt(E("ssconf_basic_tablet").checked ? "1":"0");
	if (node_nu == 0 && poped == 0) {
		$(".show-btn1").trigger("click");
	}else{
		$(".show-btn" + default_tab).trigger("click");
	}
}
function get_ss_status() {
	if (db_ss['ssconf_basic_enable'] != "1") {
		E("ss_state2").innerHTML = "国外连接 - " + "Waiting...";
		E("ss_state3").innerHTML = "国内连接 - " + "Waiting...";
		return false;
	}

	if(db_ss["ssconf_failover_enable"] == "1"){
		get_ss_status_back();
	}else{
		get_ss_status_front();
	}
}
function get_ss_status_front() {
	if (ws_enable != 1){
		get_ss_status_front_httpd();
		return false;
	}
	if (window.location.protocol != "http:"){
		get_ss_status_front_httpd();
		return false;
	}
	wss = new WebSocket("ws://" + hostname + ":8030/");
	wss.onopen = function() {
		//console.log('成功建立websocket链接，开始获取后台状态1...');
		wss_open = 1;
		get_ss_status_front_websocket();
	};
	wss.onerror = function(event) {
		//console.log('WS Error 1: ' + event.data);
		wss_open = 0;
		get_ss_status_front_httpd();
	};
	wss.onclose = function() {
		//console.log('WS DISCONNECT');
		wss_open = 0;
		get_ss_status_front_httpd();
	};
	wss.onmessage = function(event) {
		// 运行状态
		var res = event.data;
		//console.log(res);
		if(res.indexOf("@@") != -1){
			var arr = res.split("@@");
			if (arr[0] == "" || arr[1] == "") {
				E("ss_state2").innerHTML = "国外连接 - " + "Waiting for first refresh...";
				E("ss_state3").innerHTML = "国内连接 - " + "Waiting for first refresh...";
			} else {
				E("ss_state2").innerHTML = arr[0];
				E("ss_state3").innerHTML = arr[1];
			}
		}else{
			E("ss_state2").innerHTML = "国外连接 - " + "Waiting ...";
			E("ss_state3").innerHTML = "国内连接 - " + "Waiting ...";
		}
	}
}
function get_ss_status_front_httpd2(id){
	$.ajax({
		type: "POST",
		async: true,
		cache:false,
		url: "/_result/"+id,
		dataType: "json",
		success: function(response) {
			if (typeof response.result == "number"){
				setTimeout("get_ss_status_front_httpd2("+response.result+");", 1000);
			}
			else {
				var arr = response.result.split("@@");
				if (arr[0] == "" || arr[1] == "") {
					E("ss_state2").innerHTML = "国外连接 - " + "Waiting for first refresh...";
					E("ss_state3").innerHTML = "国内连接 - " + "Waiting for first refresh...";
				} else {
					E("ss_state2").innerHTML = arr[0];
					E("ss_state3").innerHTML = arr[1];
				}
			}
		}
	});
}
function get_ss_status_front_httpd() {
	if (submit_flag == "1") {
		//console.log("wait for 5s to get next status...")
		setTimeout("get_ss_status_front_httpd();", 5000);
		return false;
	}
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "ss_status.sh", "params":[], "fields": ""};
	$.ajax({
		type: "POST",
		url: "/_api/",
		async: true,
		data: JSON.stringify(postData),
		dataType: "json",
		success: function(ssstatus) {
			//console.log(ssstatus);
			if (typeof ssstatus.result == "number"){
				get_ss_status_front_httpd2(ssstatus.result);
			}
			else {
				var arr = ssstatus.result.split("@@");
				if (arr[0] == "" || arr[1] == "") {
					E("ss_state2").innerHTML = "国外连接 - " + "Waiting for first refresh...";
					E("ss_state3").innerHTML = "国内连接 - " + "Waiting for first refresh...";
				} else {
					E("ss_state2").innerHTML = arr[0];
					E("ss_state3").innerHTML = arr[1];
				}
			}
		}
	});
	//refreshRate = Math.floor(Math.random() * 4000) + 4000;
	//1: 2-3s, 2:4-7s, 3:8-15s, 4:16-31s, 5:32-63s
	var time_plus = Math.pow("2", String(db_ss['ssconf_basic_interval']||"2")) * 1000;
	var time_base = time_plus - 1000;
	refreshRate = Math.floor(Math.random() * time_base) + time_plus ;
	setTimeout("get_ss_status_front_httpd();", refreshRate);
}
function get_ss_status_front_websocket() {
	if (submit_flag == "1") {
		//console.log("wait for 5s to get next status...")
		setTimeout("get_ss_status_front_websocket();", 5000);
		return false;
	}
	
	try {
		wss.send("sh /jffs/softcenter/scripts/ss_status.sh ws");
	} catch (ex) {
		console.log('Cannot send: ' + ex);
	}
	if (wss_open == "1"){
		var time_plus = Math.pow("2", String(db_ss['ssconf_basic_interval']||"2")) * 1000;
		var time_base = time_plus - 1000;
		refreshRate = Math.floor(Math.random() * time_base) + time_plus ;
		setTimeout("get_ss_status_front_websocket();", refreshRate);
	}
}
function get_ss_status_back() {
	if (E("ssconf_basic_interval").value == "1"){
		var time_wait = 3000;
	}else if(E("ssconf_basic_interval").value == "2"){
		var time_wait = 7000;
	}else if(E("ssconf_basic_interval").value == "3"){
		var time_wait = 15000;
	}else if(E("ssconf_basic_interval").value == "4"){
		var time_wait = 31000;
	}else if(E("ssconf_basic_interval").value == "5"){
		var time_wait = 63000;
	}
	//console.log("time_wait: ", time_wait);
	
	if (ws_enable != 1){
		get_ss_status_back_httpd();
		return false;
	}
	if (window.location.protocol != "http:"){
		get_ss_status_back_httpd();
		return false;
	}
	//wss = new WebSocket('ws://192.168.60.1:8030/');
	wss = new WebSocket("ws://" + hostname + ":8030/");
	wss.onopen = function() {
		//console.log('成功建立websocket链接，开始获取后台状态2...');
		wss_open = 1;
		get_ss_status_back_websocket();
	};
	wss.onerror = function(event) {
		//console.log('WS Error 2: ' + event.data);
		wss_open = 0;
		get_ss_status_back_httpd();
	};
	wss.onclose = function() {
		//console.log('WS DISCONNECT');
		wss_open = 0;
		get_ss_status_back_httpd();
	};
	wss.onmessage = function(event) {
		// 运行状态
		var res = event.data;
		//console.log(res);
		if(res.indexOf("@@") != -1){
			var arr = res.split("@@");
			if (arr[0] == "" || arr[1] == "") {
				E("ss_state2").innerHTML = "国外连接 - " + "Waiting for first refresh...";
				E("ss_state3").innerHTML = "国内连接 - " + "Waiting for first refresh...";
			} else {
				E("ss_state2").innerHTML = arr[0];
				E("ss_state3").innerHTML = arr[1];
			}
			if (arr[2] == "1") {
				var dbus_post = {};
				dbus_post["ssconf_heart_beat"] = "0";
				push_data("dummy_script.sh", "", dbus_post, "2");
				// require(['/res/layer/layer.js'], function(layer) {
				// 	layer.confirm('<li>科学上网插件页面需要刷新！</li><br /><li>由于故障转移功能已经在后台切换了节点，为了保证页面显示正确配置！需要刷新此页面！</li><br /><li>确定现在刷新吗？</li>', {
				// 		time: 3e4,
				// 		shade: 0.8
				// 	}, function(index) {
				// 		layer.close(index);
				// 		refreshpage();
				// 	}, function(index) {
				// 		layer.close(index);
				// 		return false;
				// 	});
				// });
			}
		}else{
			E("ss_state2").innerHTML = "国外连接 - " + "Waiting ...";
			E("ss_state3").innerHTML = "国内连接 - " + "Waiting ...";
		}
	};
}

function get_ss_status_back_websocket() {
	try {
		wss.send("cat /tmp/upload/ss_status.txt");
	} catch (ex) {
		console.log('Cannot send: ' + ex);
	}
	if (wss_open == "1"){
		setTimeout("get_ss_status_back_websocket();", 1000);
	}
}
function get_ss_status_back_httpd() {
	if (db_ss['ssconf_basic_enable'] != "1") {
		E("ss_state2").innerHTML = "国外连接 - " + "Waiting...";
		E("ss_state3").innerHTML = "国内连接 - " + "Waiting...";
		return false;
	}
	$.ajax({
		url: '/_temp/ss_status.txt?_=' + new Date().getTime(),
		type: 'GET',
		dataType: 'html',
		async: true,
		cache:false,
		success: function(response) {
			var res = response.trim();
			if(res.indexOf("@@") != -1){
				var arr = res.split("@@");
				if (arr[0] == "" || arr[1] == "") {
					E("ss_state2").innerHTML = "国外连接 - " + "Waiting for first refresh...";
					E("ss_state3").innerHTML = "国内连接 - " + "Waiting for first refresh...";
				} else {
					E("ss_state2").innerHTML = arr[0];
					E("ss_state3").innerHTML = arr[1];
				}
			}
		},
		error: function(xhr) {
			E("ss_state2").innerHTML = "国外连接 - " + "Waiting...";
			E("ss_state3").innerHTML = "国内连接 - " + "Waiting...";
		}
	});
	if (E("ssconf_basic_interval").value == "1"){
		var time_wait = 3000;
	}else if(E("ssconf_basic_interval").value == "2"){
		var time_wait = 7000;
	}else if(E("ssconf_basic_interval").value == "3"){
		var time_wait = 15000;
	}else if(E("ssconf_basic_interval").value == "4"){
		var time_wait = 31000;
	}else if(E("ssconf_basic_interval").value == "5"){
		var time_wait = 63000;
	}
	setTimeout("get_ss_status_back_httpd();", time_wait);
}

function close_ssf_status() {
	$("#ssf_status_div").fadeOut(200);
	STATUS_FLAG = 0;
}
function close_ssc_status() {
	$("#ssc_status_div").fadeOut(200);
	STATUS_FLAG = 0;
}
function lookup_status_log(s) {
	STATUS_FLAG = 1;
	if(s == 1){
		$("#ssf_status_div").fadeIn(500);
		get_status_log(1);
	}else{
		$("#ssc_status_div").fadeIn(500);
		get_status_log(2);
	}
}
function get_status_log(s) {
	if(STATUS_FLAG == 0) return;
	
	if(s == 1){
		var file = '/_temp/ssf_status.txt';
		var retArea = E("log_content_f");
	}else{
		var file = '/_temp/ssc_status.txt';
		var retArea = E("log_content_c");
	}
	$.ajax({
		url: file,
		type: 'GET',
		dataType: 'html',
		async: true,
		cache:false,
		success: function(response) {
			if(E("tablet_2").style.display == "none"){
				return false;
			}
			if (_responseLen == response.length) {
				noChange_status++;
			} else {
				noChange_status = 0;
			}
			if (noChange_status > 10) {
				return false;
			} else {
				setTimeout('get_status_log("' + s + '");', 1500);
			}
			retArea.value = response;
			if(E("ssconf_failover_c4").checked == false && E("ssconf_failover_c5").checked == false){
				retArea.scrollTop = retArea.scrollHeight;
			}
			_responseLen = response.length;
		},
		error: function(xhr) {
			retArea.value = "暂无任何日志，获取日志失败！";
		}
	});
}
function get_log_httpd() {
	$.ajax({
		url: '/_temp/ss_log.txt',
		type: 'GET',
		dataType: 'html',
		async: true,
		cache:false,
		success: function(response) {
			var retArea = E("log_content1");
			if (response.search("XU6J03M6") != -1) {
				retArea.value = response.replace("XU6J03M6", " ");
				var pageH = parseInt(E("FormTitle").style.height.split("px")[0]); 
				if(pageH){
					autoTextarea(E("log_content1"), 0, (pageH - 308));
				}else{
					autoTextarea(E("log_content1"), 0, 980);
				}
				return true;
			}
			if (_responseLen == response.length) {
				noChange++;
			} else {
				noChange = 0;
			}
			if (noChange > 5) {
				return false;
			} else {
				setTimeout("get_log();", 300);
			}
			retArea.value = response;
			_responseLen = response.length;
			if(E("tablet_9").style.display == "none"){
				return false;
			}
		},
		error: function(xhr) {
			E("log_content1").value = "获取日志失败！";
		}
	});
}
function get_log() {
	if (ws_flag != 1){
		get_log_httpd();
		return false;
	}
	wsl = new WebSocket("ws://" + hostname + ":8030/");
	wsl.onopen = function() {
		//console.log('wsl：成功建立websocket链接，开始获取日志...');
		E('log_content1').value = "";
		wsl.send("cat /tmp/upload/ss_log.txt");
	};
	//wsl.onclose = function() {
	//	console.log('wsl： DISCONNECT');
	//};
	wsl.onerror = function(event) {
		//console.log('wsl： Error: ' + event.data);
		get_log_httpd();
	};
	wsl.onmessage = function(event) {
		if(event.data != "XU6J03M6"){
			E('log_content1').value += event.data + '\n';
		}else{
			E("log_content1").scrollTop = E("log_content1").scrollHeight;
			wsl.close();
		}
	};
}
function get_realtime_log() {
	$.ajax({
		url: '/_temp/ss_log.txt',
		type: 'GET',
		async: true,
		cache:false,
		dataType: 'text',
		success: function(response) {
			var retArea = E("log_content3");
			if (response.search("XU6J03M6") != -1) {
				retArea.value = response.replace("XU6J03M6", " ");
				E("ok_button").style.display = "";
				retArea.scrollTop = retArea.scrollHeight;
				count_down_close();
				submit_flag="0";
				return true;
			}
			if (_responseLen == response.length) {
				noChange++;
			} else {
				noChange = 0;
			}
			if (noChange > 1000) {
				return false;
			} else {
				setTimeout("get_realtime_log();", 100);
			}
			retArea.value = response.replace("XU6J03M6", " ");
			retArea.scrollTop = retArea.scrollHeight;
			_responseLen = response.length;
		},
		error: function() {
			setTimeout("get_realtime_log();", 500);
		}
	});
}
function count_down_close() {
	if (x == "0") {
		hideSSLoadingBar();
	}
	if (x < 0) {
		E("ok_button1").value = "手动关闭"
		return false;
	}
	E("ok_button1").value = "自动关闭（" + x + "）"
		--x;
	setTimeout("count_down_close();", 1000);
}

function getACLConfigs() {
	var dict = {};
	acl_node_max = 0;
	for (var field in db_acl) {
		names = field.split("_");
		dict[names[names.length - 1]] = 'ok';
	}
	acl_confs = {};
	var p = "ssconf_acl";
	var params = ["ip", "port", "mode"];
	for (var field in dict) {
		var obj = {};
		if (typeof db_acl[p + "_name_" + field] == "undefined") {
			obj["name"] = db_acl[p + "_ip_" + field];
		} else {
			obj["name"] = db_acl[p + "_name_" + field];
		}
		for (var i = 0; i < params.length; i++) {
			var ofield = p + "_" + params[i] + "_" + field;
			if (typeof db_acl[ofield] == "undefined") {
				obj = null;
				break;
			}
			obj[params[i]] = db_acl[ofield];
		}
		if (obj != null) {
			var node_a = parseInt(field);
			if (node_a > acl_node_max) {
				acl_node_max = node_a;
			}
			obj["acl_node"] = field;
			acl_confs[field] = obj;
		}
	}
	return acl_confs;
}
function addTr() {
	var acls = {};
	var p = "ssconf_acl";
	acl_node_max += 1;
	var params = ["ip", "name", "port", "mode"];
	for (var i = 0; i < params.length; i++) {
		acls[p + "_" + params[i] + "_" + acl_node_max] = $('#' + p + "_" + params[i]).val();
	}
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "dummy_script.sh", "params":[], "fields": acls};
	$.ajax({
		type: "POST",
		cache:false,
		url: "/_api/",
		data: JSON.stringify(postData),
		dataType: "json",
		error: function(xhr) {
			console.log("error in posting config of table");
		},
		success: function(response) {
			//confs = generate_node_info();
			refresh_acl_table();
			E("ssconf_acl_name").value = ""
			E("ssconf_acl_ip").value = ""
		}
	});
	aclid = 0;
}
function delTr(o) {
	var id = $(o).attr("id");
	var ids = id.split("_");
	var p = "ssconf_acl";
	id = ids[ids.length - 1];
	var acls = {};
	var params = ["ip", "name", "port", "mode"];
	for (var i = 0; i < params.length; i++) {
		acls[p + "_" + params[i] + "_" + id] = "";
	}
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "dummy_script.sh", "params":[], "fields": acls};
	$.ajax({
		type: "POST",
		cache:false,
		url: "/_api/",
		data: JSON.stringify(postData),
		dataType: "json",
		success: function(response) {
			refresh_acl_table();
		}
	});
}
function refresh_acl_table(q) {
	$.ajax({
		type: "GET",
		url: "/_api/ssconf_acl",
		dataType: "json",
		async: false,
		success: function(data) {
			db_acl = data.result[0];
			refresh_acl_html();
			//write defaut rule mode when switching ss mode
			if (typeof db_acl["ssconf_acl_default_mode"] != "undefined") {
				if (E("sstable_mode").value == 1 && db_acl["ssconf_acl_default_mode"] == 1 || db_acl["ssconf_acl_default_mode"] == 0) {
					$('#ssconf_acl_default_mode').val(db_acl["ssconf_acl_default_mode"]);
				}
				if (E("sstable_mode").value == 2 && db_acl["ssconf_acl_default_mode"] == 2 || db_acl["ssconf_acl_default_mode"] == 0) {
					$('#ssconf_acl_default_mode').val(db_acl["ssconf_acl_default_mode"]);
				}
				if (E("sstable_mode").value == 3 && db_acl["ssconf_acl_default_mode"] == 3 || db_acl["ssconf_acl_default_mode"] == 0) {
					$('#ssconf_acl_default_mode').val(db_acl["ssconf_acl_default_mode"]);
				}
				if (E("sstable_mode").value == 5 && db_acl["ssconf_acl_default_mode"] == 5 || db_acl["ssconf_acl_default_mode"] == 0) {
					$('#ssconf_acl_default_mode').val(db_acl["ssconf_acl_default_mode"]);
				}
			}
			//write default rule port
			if (typeof db_acl["ssconf_acl_default_port"] != "undefined") {
				$('#ssconf_acl_default_port').val(db_acl["ssconf_acl_default_port"]);
			} else {
				$('#ssconf_acl_default_port').val("all");
			}
			//write dynamic table value
			for (var i = 1; i < acl_node_max + 1; i++) {
				$('#ssconf_acl_mode_' + i).val(db_acl["ssconf_acl_mode_" + i]);
				$('#ssconf_acl_port_' + i).val(db_acl["ssconf_acl_port_" + i]);
				$('#ssconf_acl_name_' + i).val(db_acl["ssconf_acl_name_" + i]);
			}
			//set default rule port to all when game mode enabled
			set_default_port();
			//after table generated and value filled, set default value for first line_image1
			$('#ssconf_acl_mode').val("1");
			$('#ssconf_acl_port').val("80,443");
		}
	});
}
function set_mode_1() {
	//set the first line of the table, if mode is gfwlist mode or game mode,set the port to all
	if ($('#ssconf_acl_mode').val() == 0 || $('#ssconf_acl_mode').val() == 3) {
		$("#ssconf_acl_port").val("all");
		E("ssconf_acl_port").readonly = "readonly";
		E("ssconf_acl_port").title = "不可更改，游戏模式下默认全端口";
	} else if ($('#ssconf_acl_mode').val() == 1) {
		$("#ssconf_acl_port").val("80,443");
		E("ssconf_acl_port").readonly = "readonly";
		E("ssconf_acl_port").title = "";
	} else if ($('#ssconf_acl_mode').val() == 2 || $('#ssconf_acl_mode').val() == 5) {
		$("#ssconf_acl_port").val("22,53,587,465,995,993,143,80,443,853,9418");
		E("ssconf_acl_port").readonly = "";
		E("ssconf_acl_port").title = "";
	}
}
function set_mode_2(o) {
	var id2 = $(o).attr("id");
	var ids2 = id2.split("_");
	id2 = ids2[ids2.length - 1];
	if ($(o).val() == 0 || $(o).val() == 3) {
		$("#ssconf_acl_port_" + id2).val("all");
	} else if ($(o).val() == 1) {
		$("#ssconf_acl_port_" + id2).val("80,443");
	} else if ($(o).val() == 2) {
		$("#ssconf_acl_port_" + id2).val("22,53,587,465,995,993,143,80,443,853,9418");
	}
}
function set_default_port() {
	if ($('#ssconf_acl_default_mode').val() == 3) {
		$("#ssconf_acl_default_port").val("all");
		E("ssconf_acl_default_port").readonly = "readonly";
		E("ssconf_acl_default_port").title = "不可更改，游戏模式下默认全端口";
	} else {
		E("ssconf_acl_default_port").readonly = "";
		E("ssconf_acl_default_port").title = "";
	}
}
function refresh_acl_html() {
	acl_confs = getACLConfigs();
	var n = 0;
	for (var i in acl_confs) {
		n++;
	}
	var code = '';
	// acl table th
	code += '<table width="750px" border="0" align="center" cellpadding="4" cellspacing="0" class="FormTable_table acl_lists" style="margin:-1px 0px 0px 0px;">'
	code += '<tr>'
	code += '<th width="23%">主机IP地址</th>'
	code += '<th width="23%">主机别名</th>'
	code += '<th width="23%">访问控制</th>'
	code += '<th width="23%">目标端口</th>'
	code += '<th width="8%">操作</th>'
	code += '</tr>'
	code += '</table>'
	// acl table input area
	code += '<table id="ACL_table" width="750px" border="0" align="center" cellpadding="4" cellspacing="0" class="list_table acl_lists" style="margin:-1px 0px 0px 0px;">'
	code += '<tr>'
	// ip addr
	code += '<td width="23%">'
	code += '<input type="text" maxlength="15" class="input_ss_table" id="ssconf_acl_ip" align="left" style="float:left;width:110px;margin-left:16px;text-align:center" autocomplete="off" onClick="hideClients_Block();" autocorrect="off" autocapitalize="off">'
	code += '<img id="pull_arrow" height="14px;" src="images/arrow-down.gif" align="right" onclick="pullLANIPList(this);" title="<#select_IP#>">'
	code += '<div id="ClientList_Block" class="clientlist_dropdown" style="margin-left:2px;margin-top:25px;"></div>'
	code += '</td>'
	// name
	code += '<td width="23%">'
	code += '<input type="text" id="ssconf_acl_name" class="input_ss_table" maxlength="50" style="width:140px;text-align:center" placeholder="" />'
	code += '</td>'
	// mode
	code += '<td width="23%">'
	code += '<select id="ssconf_acl_mode" style="width:140px;margin:0px 0px 0px 2px;text-align:center;text-align-last:center;padding-left: 12px;" class="input_option" onchange="set_mode_1(this);">'
	code += '<option value="0">不通过代理</option>'
	code += '<option value="1">gfwlist模式</option>'
	code += '<option value="2">大陆白名单模式</option>'
	code += '<option value="3">游戏模式</option>'
	code += '<option value="5">全局代理模式</option>'
	code += '<option value="6">回国模式</option>'
	code += '</select>'
	code += '</td>'
	// port
	code += '<td width="23%">'
	code += '<select id="ssconf_acl_port" style="width:152px;margin:0px 0px 0px 2px;text-align-last:center;padding-left: 12px;" class="input_option">'
	code += '<option value="80,443">80,443</option>'
	code += '<option value="22,53,587,465,995,993,143,80,443,853,9418">22,53,587,465,995,993,143,80,443,853,9418</option>'
	code += '<option value="all">all</option>'
	code += '</select>'
	code += '</td>'
	// add/delete
	code += '<td width="8%">'
	code += '<input style="margin-left: 6px;margin: -2px 0px -4px -2px;" type="button" class="add_btn" onclick="addTr()" value="" />'
	code += '</td>'
	code += '</tr>'
	// acl table rule area
	for (var field in acl_confs) {
		var ac = acl_confs[field];
		code += '<tr id="acl_tr_' + ac["acl_node"] + '">';
		
		code += '<td width="23%">' + ac["ip"] + '</td>';
		
		code += '<td width="23%">';
		code += '<input type="text" placeholder="' + ac["acl_node"] + '号机" id="ssconf_acl_name_' + ac["acl_node"] + '" name="ssconf_acl_name_' + ac["acl_node"] + '" class="input_option_2" maxlength="50" style="width:140px;" placeholder="" />';
		code += '</td>';
		
		code += '<td width="23%">';
		code += '<select id="ssconf_acl_mode_' + ac["acl_node"] + '" name="ssconf_acl_mode_' + ac["acl_node"] + '" style="width:140px;margin:0px 0px 0px 2px;" class="sel_option" onchange="set_mode_2(this);">';
		if ($("#ssconf_basic_mode").val() == 6) {
			code += '<option value="0">不通过代理</option>';
			code += '<option value="6">回国模式</option>';
		} else {
			code += '<option value="0">不通过代理</option>';
			code += '<option value="1">gfwlist模式</option>';
			code += '<option value="2">大陆白名单模式</option>';
			code += '<option value="3">游戏模式</option>';
			code += '<option value="5">全局代理模式</option>';
			code += '<option value="6">回国模式</option>';
		}
		code += '</select>'
		code += '</td>';
		
		code += '<td width="23%">';
		if (ac["mode"] == 3) {
			code += '<input type="text" id="ssconf_acl_port_' + ac["acl_node"] + '" name="ssconf_acl_port_' + ac["acl_node"] + '" class="input_option_2" maxlength="50" style="width:140px;" title="不可更改，游戏模式下默认全端口" readonly = "readonly" />';
		} else if (ac["mode"] == 0) {
			code += '<input type="text" id="ssconf_acl_port_' + ac["acl_node"] + '" name="ssconf_acl_port_' + ac["acl_node"] + '" class="input_option_2" maxlength="50" style="width:140px;" title="不可更改，不通过SS下默认全端口" readonly = "readonly" />';
		} else {
			code += '<input type="text" id="ssconf_acl_port_' + ac["acl_node"] + '" name="ssconf_acl_port_' + ac["acl_node"] + '" class="input_option_2" maxlength="50" style="width:140px;" placeholder="" />';
		}
		code += '</td>';
		
		code += '<td width="8%">';
		code += '<input style="margin: -2px 0px -4px -2px;" id="acl_node_' + ac["acl_node"] + '" class="remove_btn" type="button" onclick="delTr(this);" value="">'
		code += '</td>';
		code += '</tr>';
	}
	code += '<tr>';
	if (n == 0) {
		code += '<td width="23%">所有主机</td>';
	} else {
		code += '<td width="23%">其它主机</td>';
	}
	code += '<td width="23%">默认规则</td>';
	ssmode = E("sstable_mode").value;
	if (n == 0) {
		if (ssmode == 0) {
			code += '<td width="23%">SS关闭</td>';
		} else if (ssmode == 1) {
			code += '<td width="23%">gfwlist模式</td>';
		} else if (ssmode == 2) {
			code += '<td width="23%">大陆白名单模式</td>';
		} else if (ssmode == 3) {
			code += '<td width="23%">游戏模式</td>';
		} else if (ssmode == 5) {
			code += '<td width="23%">全局模式</td>';
		} else if (ssmode == 6) {
			code += '<td width="23%">回国模式</td>';
		}
	} else {
		code += '<td width="23%">';
		code += '<select id="ssconf_acl_default_mode" style="width:140px;margin:0px 0px 0px 2px;" class="sel_option" onchange="set_default_port();">';
		if (ssmode == 0) {
			code += '<td>SS关闭</td>';
		} else if (ssmode == 1) {
			code += '<option value="0">不通过代理</option>';
			code += '<option value="1" selected>gfwlist模式</option>';
		} else if (ssmode == 2) {
			code += '<option value="0">不通过代理</option>';
			code += '<option value="2" selected>大陆白名单模式</option>';
		} else if (ssmode == 3) {
			code += '<option value="0">不通过代理</option>';
			code += '<option value="3" selected>游戏模式</option>';
		} else if (ssmode == 5) {
			code += '<option value="0">不通过代理</option>';
			code += '<option value="5" selected>全局代理模式</option>';
		} else if (ssmode == 6) {
			code += '<option value="0">不通过代理</option>';
			code += '<option value="6" selected>回国模式</option>';
		}
		code += '</select>';
		code += '</td>';
	}
	code += '<td width="23%">';
	code += '<input type="text" id="ssconf_acl_default_port" class="input_option_2" maxlength="50" style="width:140px;" placeholder="" />';
	code += '</td>';
	code += '<td width="8%">';
	code += '</td>';
	code += '</tr>';
	code += '</table>';

	$(".acl_lists").remove();
	$('#ssconf_acl_table').after(code);
	
	showDropdownClientList('setClientIP', 'ip', 'all', 'ClientList_Block', 'pull_arrow', 'online');
}
function setClientIP(ip, name, mac) {
	E("ssconf_acl_ip").value = ip;
	E("ssconf_acl_name").value = name;
	hideClients_Block();
}
function pullLANIPList(obj) {
	var element = E('ClientList_Block');
	var isMenuopen = element.offsetWidth > 0 || element.offsetHeight > 0;
	if (isMenuopen == 0) {
		obj.src = "/images/arrow-top.gif"
		element.style.display = 'block';
	} else{
		hideClients_Block();
	}
}
function hideClients_Block() {
	E("pull_arrow").src = "/images/arrow-down.gif";
	E('ClientList_Block').style.display = 'none';
}
function close_proc_status() {
	$("#detail_status").fadeOut(200);
}
function get_proc_status() {
	$("#detail_status").fadeIn(500);
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "ss_proc_status.sh", "params":[], "fields": ""};
	$.ajax({
		type: "POST",
		cache:false,
		url: "/_api/",
		data: JSON.stringify(postData),
		dataType: "json",
		success: function(response) {
			if(response.result == id){
				write_proc_status();
			}
		}
	});
}
function write_proc_status() {
	$.ajax({
		url: '/_temp/ss_proc_status.txt',
		type: 'GET',
		cache:false,
		dataType: 'text',
		success: function(res) {
			$('#proc_status').val(res);
		}
	});
}
function get_online_nodes(action) {
	if (action == 0 || action == 1) {
		require(['/res/layer/layer.js'], function(layer) {
			layer.confirm('你确定要删除吗？', {
				shade: 0.8,
			}, function(index) {
				layer.close(index);
				save_online_nodes(action);
			}, function(index) {
				layer.close(index);
				return false;
			});
		});
	} else {
		save_online_nodes(action);
	}
}
function save_online_nodes(action) {
	db_ss["ssconf_basic_action"] = "13";
	var dbus_post = {};
	dbus_post["ssconf_online_links"] = Base64.encode(E("ssconf_online_links").value);
	dbus_post["ssconf_subscribe_mode"] = E("ssconf_subscribe_mode").value;
	dbus_post["ssconf_basic_online_links_goss"] = E("ssconf_basic_online_links_goss").value;
	dbus_post["ssconf_basic_node_update"] = E("ssconf_basic_node_update").value;
	dbus_post["ssconf_basic_node_update_day"] = E("ssconf_basic_node_update_day").value;
	dbus_post["ssconf_basic_node_update_hr"] = E("ssconf_basic_node_update_hr").value;
	dbus_post["ssconf_basic_exclude"] = E("ssconf_basic_exclude").value.replace(pattern,"") || "";
	dbus_post["ssconf_basic_include"] = E("ssconf_basic_include").value.replace(pattern,"") || "";
	dbus_post["ssconf_base64_links"] = E("ssconf_base64_links").value;
	if(ws_flag == 1){
		push_data_ws("ss_online_update.sh", action,  dbus_post);
	}else{
		push_data("ss_online_update.sh", action,  dbus_post);
	}
}
function set_cron(action) {
	var dbus_post = {};
	if(action == 1){
		//设定定时重启
		db_ss["ssconf_basic_action"] = "16";
		var cron_params1 = ["ssconf_reboot_check", "ssconf_basic_week", "ssconf_basic_day", "ssconf_basic_inter_min", "ssconf_basic_inter_hour", "ssconf_basic_inter_day", "ssconf_basic_inter_pre", "ssconf_basic_custom", "ssconf_basic_time_hour", "ssconf_basic_time_min"];
		for (var i = 0; i < cron_params1.length; i++) {
			dbus_post[cron_params1[i]] = E(cron_params1[i]).value;
		}
		
		if (!E("sstable_custom").value) {
			dbus_post["ssconf_basic_custom"] = "";
		} else {
			dbus_post["ssconf_basic_custom"] = Base64.encode(E("sstable_custom").value);
		}
	}else if(action == 2){
		//设定触发重启
		db_ss["ssconf_basic_action"] = "17";
		var cron_params2 = ["ssconf_basic_tri_reboot_time"]; //for ss
		for (var i = 0; i < cron_params2.length; i++) {
			dbus_post[cron_params2[i]] = E(cron_params2[i]).value;
		}
	}
	push_data("ss_reboot_job.sh", action, dbus_post);
}
function save_failover() {
	var dbus_post = {};
		db_ss["ssconf_basic_action"] = "19";
	var fov_inp = ["ssconf_failover_s1", "ssconf_failover_s2_1", "ssconf_failover_s2_2", "ssconf_failover_s3_1", "ssconf_failover_s3_2", "ssconf_failover_s4_1", "ssconf_failover_s4_2", "ssconf_failover_s4_3", "ssconf_failover_s5", "ssconf_basic_interval"];
	var fov_chk = ["ssconf_failover_enable", "ssconf_failover_c1", "ssconf_failover_c2", "ssconf_failover_c3"];
	for (var i = 0; i < fov_inp.length; i++) {
		dbus_post[fov_inp[i]] = E(fov_inp[i]).value;
	}
	for (var i = 0; i < fov_chk.length; i++) {
		dbus_post[fov_chk[i]] = E(fov_chk[i]).checked ? '1' : '0';
	}
	push_data("ss_status_reset.sh", "", dbus_post);
}
</script>
</head>
<body id="app" skin='<% nvram_get("sc_skin"); %>' onload="init();">
<div id="TopBanner"></div>
<div id="Loading" class="popup_bg"></div>
<div id="LoadingBar" class="popup_bar_bg_ks" style="z-index: 200;" >
<table cellpadding="5" cellspacing="0" id="loadingBarBlock" class="loadingBarBlock" align="center">
	<tr>
		<td height="100">
		<div id="loading_block3" style="margin:10px auto;margin-left:10px;width:85%; font-size:12pt;"></div>
		<div id="loading_block2" style="margin:10px auto;width:95%;"></div>
		<div id="log_content2" style="margin-left:15px;margin-right:15px;margin-top:10px;overflow:hidden">
			<textarea cols="50" rows="36" wrap="off" readonly="readonly" id="log_content3" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" style="border:1px solid #000;width:99%; font-family:'Lucida Console'; font-size:11px;background:transparent;color:#FFFFFF;outline: none;padding-left:3px;padding-right:22px;overflow-x:hidden"></textarea>
		</div>
		<div id="ok_button" class="apply_gen" style="background: #000;display: none;">
			<input id="ok_button1" class="button_gen" type="button" onclick="hideSSLoadingBar()" value="确定">
		</div>
		</td>
	</tr>
</table>
</div>
<table class="content" align="center" cellpadding="0" cellspacing="0">
	<tr>
		<td width="17">&nbsp;</td>
		<td valign="top" width="202">
			<div id="mainMenu"></div>
			<div id="subMenu"></div>
		</td>
		<td valign="top">
			<div id="tabMenu" class="submenuBlock"></div>
			<table width="98%" border="0" align="left" cellpadding="0" cellspacing="0" style="display: block;">
				<tr>
					<td align="left" valign="top">
						<div>
							<table width="760px" border="0" cellpadding="5" cellspacing="0" bordercolor="#6b8fa3" class="FormTitle" id="FormTitle">
								<tr>
									<td bgcolor="#4D595D" colspan="3" valign="top">
										<div>&nbsp;</div>
										<div id="title_name" class="formfonttitle"></div>
											<script type="text/javascript">
												var MODEL = '<% nvram_get("modelname"); %>';
												var HELLOWORLD_TITLE=" - " + pkg_name;
												$("#title_name").html(MODEL + " helloworld插件" + HELLOWORLD_TITLE);
												$("#ss_title").html(MODEL + " - helloworld");
											</script>
										<div style="float:right; width:15px; height:25px;margin-top:-20px">
											<img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img>
										</div>
										<div style="margin:10px 0 10px 5px;" class="splitLine"></div>
										<div class="SimpleNote" id="head_illustrate">
												<ul id="fixed_msg" style="padding:0;margin:0;line-height:1.8;">
													<li id="msg_0" style="list-style: none;height:23px">
														本插件是支持<a href="https://github.com/shadowsocks/shadowsocks-libev" target="_blank"><em><u>SS</u></em></a>
														、<a href="https://github.com/shadowsocksrr/shadowsocksr-libev" target="_blank"><em><u>SSR</u></em></a>
														、<a href="https://github.com/v2ray/v2ray-core" target="_blank"><em><u>V2ray</u></em></a>
														、<a href="https://github.com/XTLS/xray-core" target="_blank"><em><u>Xray</u></em></a>
														、<a href="https://github.com/trojan-gfw/trojan" target="_blank"><em><u>Trojan</u></em></a>
														、<a href="https://github.com/apernet/hysteria" target="_blank"><em><u>Hysteria</u></em></a>    	<!--helloworld-full-->
														六种客户端的科学上网工具。
														<a href="https://t.me/+NfDH2N_WAE81NzJl" target="_blank"><em>Telegram交流群</em></a>
													</li>
												</ul>
												<ul id="scroll_msg" style="padding:0;margin:0;line-height:1.8;overflow: hidden;">
												</ul>
										</div>
										<!-- this is the popup area for process status -->
										<div id="detail_status"  class="content_status" style="box-shadow: 3px 3px 10px #000;margin-top: -20px;display: none;">
											<div class="user_title">【ShadowSocksR Plus】状态检测</div>
											<div style="margin-left:15px"><i>&nbsp;&nbsp;目前本功能支持ss相关进程状态和iptables表状态检测。</i></div>
											<div style="margin: 10px 10px 10px 10px;width:98%;text-align:center;overflow:hidden">
												<textarea cols="63" rows="36" wrap="off" id="proc_status" style="width:98%;padding-left:13px;padding-right:33px;border:0px solid #222;font-family:'Lucida Console'; font-size:11px;background: transparent;color:#FFFFFF;outline: none;overflow-x:hidden;" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>
											</div>
											<div style="margin-top:5px;padding-bottom:10px;width:100%;text-align:center;">
												<input class="button_gen" type="button" onclick="close_proc_status();" value="返回主界面">
											</div>
										</div>
										<!-- this is the popup area for foreign status -->
										<div id="ssf_status_div"  class="content_status" style="box-shadow: 3px 3px 10px #000;margin-top: -20px;display: none;margin-left:0px;width:748px;">
											<div class="user_title">国外历史状态 - www.google.com.tw</div>
											<div style="margin-left:15px"><i>&nbsp;&nbsp;此功能仅在开启故障转移时生效。</i></div>
											<div style="margin: 10px 10px 10px 10px;width:98%;text-align:center;overflow:hidden;">
												<textarea cols="63" rows="36" wrap="off" id="log_content_f" style="width:98%;padding-left:13px;padding-right:33px;border:0px solid #222;font-family:'Lucida Console'; font-size:11px;background: transparent;color:#FFFFFF;outline: none;overflow-x:hidden;" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>
											</div>
											<div style="margin-top:5px;padding-bottom:10px;width:100%;text-align:center;">
												<input class="button_gen" type="button" onclick="download_SS_node(6);" value="下载日志">
												<input class="button_gen" type="button" onclick="close_ssf_status();" value="返回主界面">
												<input style="margin-left:10px" type="checkbox" id="ssconf_failover_c4">
												<lable>&nbsp;暂停日志刷新</lable>
											</div>
										</div>
										<!-- this is the popup area for china status -->
										<div id="ssc_status_div"  class="content_status" style="box-shadow: 3px 3px 10px #000;margin-top: -20px;display: none;margin-left:0px;width:748px;">
											<div class="user_title">国内历史状态 - www.baidu.com</div>
											<div style="margin-left:15px"><i>&nbsp;&nbsp;此功能仅在开启故障转移时生效。</i></div>
											<div style="margin: 10px 10px 10px 10px;width:98%;text-align:center;overflow:hidden;">
												<textarea cols="63" rows="36" wrap="off" id="log_content_c" style="width:98%;padding-left:13px;padding-right:33px;border:0px solid #222;font-family:'Lucida Console'; font-size:11px;background: transparent;color:#FFFFFF;outline: none;overflow-x:hidden;" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>
											</div>
											<div style="margin-top:5px;padding-bottom:10px;width:100%;text-align:center;">
												<input class="button_gen" type="button" onclick="download_SS_node(7);" value="下载日志">
												<input class="button_gen" type="button" onclick="close_ssc_status();" value="返回主界面">
												<input style="margin-left:10px" type="checkbox" id="ssconf_failover_c5">
											</div>
										</div>
										<div id="ss_switch_show" style="margin:-1px 0px 0px 0px;">
											<table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" id="ss_switch_table">
												<thead>
												<tr>
													<td colspan="2">开关</td>
												</tr>
												</thead>
												<tr>
												<th id="ss_switch">ShadowSocksR Plus开关</th>
													<td colspan="2">
														<div class="switch_field" style="display:table-cell;float: left;">
															<label for="ssconf_basic_enable">
																<input id="ssconf_basic_enable" class="switch" type="checkbox" style="display: none;">
																<div class="switch_container" >
																	<div class="switch_bar"></div>
																	<div class="switch_circle transition_style">
																		<div></div>
																	</div>
																</div>
															</label>
														</div>
														<div id="update_button" style="display:table-cell;float: left;position: absolute;margin-left:70px;padding: 5.5px 0px;">
															<a id="updateBtn" type="button" class="ss_btn" style="cursor:pointer" onclick="update_ss()">检查并更新</a>
														</div>
														<div id="ss_version_show" style="display:table-cell;float: left;position: absolute;margin-left:170px;padding: 5.5px 0px;">
															<a><i>当前版本：</i></a>
														</div>
														<div style="display:table-cell;float: left;margin-left:270px;position: absolute;padding: 5.5px 0px;">
															<a type="button" class="ss_btn" target="_blank" href="https://github.com/zusterben/plan_f/blob/master/Changelog.txt">更新日志</a>
														</div>
														<div style="display:table-cell;float: left;margin-left:350px;position: absolute;padding: 5.5px 0px;">
															<a type="button" class="ss_btn" href="javascript:void(0);" onclick="pop_help()">插件帮助</a>
														</div>
													</td>
												</tr>
											</table>
										</div>
										<div id="ss_status1" style="margin:-1px 0px 0px 0px;">
											<table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" >
												<tr id="ss_state">
												<th>插件运行状态</th>
													<td>
														<div style="display:table-cell;float: left;margin-left:0px;">
															<a class="hintstyle" href="javascript:void(0);" onclick="openssHint(0)">
																<span id="ss_state2">国外连接 - Waiting...</span>
																<br/>
																<span id="ss_state3">国内连接 - Waiting...</span>
															</a>
														</div>
														<div style="display:table-cell;float: left;margin-left:270px;position: absolute;padding: 10.5px 0px;">
															<!--<a type="button" class="ss_btn" style="cursor:pointer" onclick="pop_111(3)" href="javascript:void(0);">分流检测</a>-->
															<a type="button" class="ss_btn" target="https://ip.skk.moe/" href="https://ip.skk.moe/">分流检测</a>
														</div>
														<div style="display:table-cell;float: left;margin-left:350px;position: absolute;padding: 10.5px 0px;">
														<a type="button" class="ss_btn" style="cursor:pointer" onclick="get_proc_status()" href="javascript:void(0);">详细状态</a>
														</div>
													</td>
												</tr>
											</table>
										</div>
										<div id="tablets">
											<table style="margin:10px 0px 0px 0px;border-collapse:collapse" width="100%" height="37px">
												<tr>
													<td cellpadding="0" cellspacing="0" style="padding:0" border="1" bordercolor="#222">
														<input id="show_btn0" class="show-btn0" style="cursor:pointer" type="button" value="帐号设置" />
														<input id="show_btn1" class="show-btn1" style="cursor:pointer" type="button" value="节点管理" />
														<input id="show_btn2" class="show-btn2" style="cursor:pointer" type="button" value="故障转移" />
														<input id="show_btn3" class="show-btn3" style="cursor:pointer" type="button" value="DNS设定" />
														<input id="show_btn4" class="show-btn4" style="cursor:pointer" type="button" value="黑白名单" />
														<input id="show_btn5" class="show-btn5" style="cursor:pointer" type="button" value="KCP加速" />
														<input id="show_btn6" class="show-btn6" style="cursor:pointer" type="button" value="更新管理"/>
														<input id="show_btn7" class="show-btn7" style="cursor:pointer" type="button" value="访问控制" />
														<input id="show_btn8" class="show-btn8" style="cursor:pointer" type="button" value="附加功能" />
														<input id="show_btn9" class="show-btn9" style="cursor:pointer" type="button" value="查看日志" />
													</td>
												</tr>
											</table>
										</div>
										<div id="vpnc_settings"  class="contentM_qis pop_div_bg">
											<table class="QISform_wireless" border="0" align="center" cellpadding="5" cellspacing="0">
												<tr style="height:32px;">
													<td>
														<table width="100%" border="0" align="left" cellpadding="0" cellspacing="0" class="vpnClientTitle">
															<tr>
															<td width="20%" align="center" id="ssTitle" onclick="tabclickhandler(0);">添加SS配置</td>
															<td width="20%" align="center" id="ssrTitle" onclick="tabclickhandler(1);">添加SSR配置</td>
															<td width="20%" align="center" id="v2rayTitle" onclick="tabclickhandler(2);">添加V2Ray配置</td>
															<td width="20%" align="center" id="TrojanTitle" onclick="tabclickhandler(3);">添加Trojan配置</td>
															<td width="20%" align="center" id="HysteriaTitle" onclick="tabclickhandler(4);">添加Hysteria配置</td>
															</tr>
															</table>
													</td>
												</tr>
												<tr>
													<td>
														<div>
														<table id="table_edit" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" class="FormTable">
															<script type="text/javascript">
																$('#table_edit').forms([
																	{ title: '使用模式', id:'ss_node_table_mode', type:'select', func:'v', options:option_modes, style:'width:350px', value: "1"},
																	{ title: '使用模式', id:'ss_node_table_type', type:'text', maxlen:'64', style:'width:338px', hidden:"yes"},
														
																	{ title: '节点别名', rid:'ss_node_table_alias_tr', id:'ss_node_table_alias', type:'text', maxlen:'64', style:'width:338px'},
																	{ title: '服务器地址', rid:'ss_node_table_server_tr', id:'ss_node_table_server', type:'text', maxlen:'64', style:'width:338px'},
																	{ title: '服务器端口', rid:'ss_node_table_port_tr', id:'ss_node_table_port', type:'text', maxlen:'64', style:'width:338px'},
																	{ title: '密码', rid:'ss_node_table_password_tr', id:'ss_node_table_password', type:'text', maxlen:'64', style:'width:338px', hidden:"yes"},
																	{ title: '加密方式', rid:'ss_node_table_method_tr', id:'ss_node_table_method', type:'select', options:option_method, style:'width:350px', value: "aes-256-cfb", hidden:"yes"},
																	{ title: '加密方式', rid:'ss_node_table_method_ss_tr', id:'ss_node_table_method_ss', type:'select', options:option_method_aead, style:'width:350px', value: "none", hidden:"yes"},
																	{ title: '混淆插件 (obfs)', rid:'ss_node_table_plugin_tr', id:'ss_node_table_plugin', type:'select', func:'v', options:[["none", "关闭"], ["v2ray-plugin", "v2ray-plugin"], ["obfs-local", "obfs-local"]], style:'width:350px', value: "none", hidden:"yes"},
																	{ title: '混淆插件参数 (obfs_host)', rid:'ss_node_table_plugin_opts_tr', id:'ss_node_table_plugin_opts', type:'text', maxlen:'300', style:'width:338px', ph:'example.com', hidden:"yes"},
																	{ title: '协议 (protocol)', rid:'ss_node_table_protocol_tr', id:'ss_node_table_protocol', type:'select', func:'v', options:option_protocals, style:'width:350px', value: "0", hidden:"yes"},
																	{ title: '协议参数 (protocol_param)', rid:'ss_node_table_protocol_param_tr', id:'ss_node_table_protocol_param', type:'text', maxlen:'300', style:'width:338px', ph:'id:password', hidden:"yes"},
																	{ title: '混淆 (obfs)', rid:'ss_node_table_obfs_tr', id:'ss_node_table_obfs', type:'select', func:'v', options:option_obfs, style:'width:350px', value: "0", hidden:"yes"},
																	{ title: '混淆参数 (obfs_param)', rid:'ss_node_table_obfs_param_tr', id:'ss_node_table_obfs_param', type:'text', maxlen:'300', style:'width:338px', ph:'bing.com', hidden:"yes"},
																	{ title: '布隆过滤器', rid:'ss_node_table_v2_ivCheck_tr', id:'ss_node_table_v2_ivCheck', type:'select', func:'v', options:[["1", "开启"], ["0", "关闭"]], value: "1", hidden:"yes"},
																	{ title: '用户id（UUID）', rid:'ss_node_table_v2_vmess_id_tr', id:'ss_node_table_v2_vmess_id', type:'text', maxlen:'300', style:'width:338px', hidden:"yes"},
																	{ title: '额外ID (Alterld)', rid:'ss_node_table_v2_alter_id_tr', id:'ss_node_table_v2_alter_id', type:'text', maxlen:'300', style:'width:338px', hidden:"yes"},
																	{ title: '协议protocol（vmess/vless/trojan/ss）', rid:'ss_node_table_v2_protocol_tr', id:'ss_node_table_v2_protocol', type:'select', func:'v', options:[ "vmess", "vless", "trojan", "shadowsocks", "shadowsocksr", "wireguard", "socks", "http"], style:'width:350px', value: "vmess", hidden:"yes"},
																	{ title: '加密方式 (security)', rid:'ss_node_table_v2_security_tr', id:'ss_node_table_v2_security', type:'select', options:option_v2enc, style:'width:350px', value: "auto", hidden:"yes"},
																	{ title: 'VLESS 加密', rid:'ss_node_table_v2_encryption_tr', id:'ss_node_table_v2_encryption', type:'text', maxlen:'50', hidden:"yes", value: "none"},
																	{ title: '传输协议 (network)', rid:'ss_node_table_v2_transport_tr', id:'ss_node_table_v2_transport', type:'select', func:'v', options:["tcp", "mkcp", "ws", "h2", "quic", "grpc"], style:'width:350px', value: "tcp", hidden:"yes"},
																	{ title: 'tcp伪装类型 (type)', rid:'ss_node_table_v2_tcp_guise_tr', id:'ss_node_table_v2_tcp_guise', type:'select', func:'v', options:option_headtcp, style:'width:350px', value: "none", hidden:"yes"},
																	{ title: 'kcp伪装类型 (type)', rid:'ss_node_table_v2_kcp_guise_tr', id:'ss_node_table_v2_kcp_guise', type:'select', func:'v', options:option_headkcp, style:'width:350px', value: "none", hidden:"yes"},
																	{ title: '最大传输单元 (MTU)', rid:'ss_node_table_v2_mtu_tr', id:'ss_node_table_v2_mtu', type:'text', maxlen:'50', hidden:"yes", value: "1350"},
																	{ title: '传输时间间隔 (TTI)', rid:'ss_node_table_v2_tti_tr', id:'ss_node_table_v2_tti', type:'text', maxlen:'50', hidden:"yes", value: "50"},
																	{ title: '上行链路容量', rid:'ss_node_table_uplink_capacity_tr', id:'ss_node_table_uplink_capacity', type:'text', maxlen:'50', hidden:"yes", value: "5"},
																	{ title: '下行链路容量', rid:'ss_node_table_downlink_capacity_tr', id:'ss_node_table_downlink_capacity', type:'text', maxlen:'50', hidden:"yes", value: "20"},
																	{ title: '读取缓冲区大小', rid:'ss_node_table_v2_read_buffer_size_tr', id:'ss_node_table_v2_read_buffer_size', type:'text', maxlen:'50', hidden:"yes", value: "2"},
																	{ title: '写入缓冲区大小', rid:'ss_node_table_v2_write_buffer_size_tr', id:'ss_node_table_v2_write_buffer_size', type:'text', maxlen:'50', hidden:"yes", value: "2"},
																	{ title: '混淆密码（可选）', rid:'ss_node_table_v2_seed_tr', id:'ss_node_table_v2_seed', type:'text', maxlen:'50', hidden:"yes", ph:'没有请留空', value: ""},
																	{ title: '拥塞控制', rid:'ss_node_table_v2_congestion_tr', id:'sstable_v2_congestion', type:'checkbox', func:'v', hidden:"yes", value: false},
																	{ title: '伪装域名 (host)', rid:'ss_node_table_v2_http_host_tr', id:'ss_node_table_v2_http_host', type:'text', maxlen:'300', style:'width:338px', hidden:"yes"},
																	{ title: '路径 (path)', rid:'ss_node_table_v2_http_path_tr', id:'ss_node_table_v2_http_path', type:'text', maxlen:'300', style:'width:338px', ph:'没有请留空', hidden:"yes"},
																	{ title: 'TLS', rid:'ss_node_table_v2_tls_tr', id:'ss_node_table_v2_tls', type:'checkbox', func:'v', value:false, hidden:"yes"},
																	{ title: 'Reality', rid:'ss_node_table_v2_reality_tr', id:'ss_node_table_v2_reality', type:'checkbox', func:'v', value:false, hidden:"yes"},
																	{ title: 'Public key', rid:'ss_node_table_v2_reality_publickey_tr', id:'ss_node_table_v2_reality_publickey', type:'text', maxlen:'999', style:'width:338px', ph:'没有请留空', hidden:"yes"},
																	{ title: 'Short ID', rid:'ss_node_table_v2_reality_shortid_tr', id:'ss_node_table_v2_reality_shortid', type:'text', maxlen:'20', style:'width:338px', ph:'没有请留空', hidden:"yes"},
																	{ title: 'spiderX', rid:'ss_node_table_v2_reality_spiderx_tr', id:'ss_node_table_v2_reality_spiderx', type:'text', maxlen:'300', style:'width:338px', ph:'没有请留空', hidden:"yes"},
																	{ title: 'TLS伪装域名', rid:'ss_node_table_tls_host_tr', id:'ss_node_table_tls_host', type:'text', maxlen:'300', style:'width:338px', ph:'没有请留空', hidden:"yes"},
																	{ title: '指纹伪造', rid:'ss_node_table_v2_fingerprint_tr', id:'ss_node_table_v2_fingerprint', type:'select', func:'v', options:[["disable", "关闭"], ["firefox", "firefox"], ["chrome", "chrome"]],value: "disable", hidden:"yes"},
																	{ title: 'QUIC加密', rid:'ss_node_table_v2_quic_security_tr', id:'ss_node_table_v2_quic_security', type:'select', func:'v', options:[["none", "关闭"], ["aes-128-gcm", "aes-128-gcm"], ["chacha20-poly1305", "chacha20-poly1305"]],value: "none", hidden:"yes"},
																	{ title: 'QUIC Key', rid:'ss_node_table_v2_quic_key_tr', id:'ss_node_table_v2_quic_key', type:'text', maxlen:'300', ph:'没有请留空', hidden:"yes"},
																	{ title: '伪装类型', rid:'ss_node_table_v2_quic_guise_tr', id:'ss_node_table_v2_quic_guise', type:'select', func:'v', options:option_headkcp,value: "none", hidden:"yes"},
																	{ title: '允许不安全连接', rid:'ss_node_table_insecure_tr', id:'ss_node_table_insecure', type:'checkbox', func:'v', value:false, hidden:"yes"},
																	{ title: 'serviceName', rid:'ss_node_table_v2_serviceName_tr', id:'ss_node_table_v2_serviceName', type:'text', maxlen:'300', ph:'没有请留空', value: "none", hidden:"yes"},
																	{ title: 'gRPC/H2 Health Check', rid:'ss_node_table_v2_health_check_tr', id:'ss_node_table_v2_health_check', type:'checkbox', func:'v', value:false, hidden:"yes"},
																	{ title: 'gRPC/H2 Read Idle Timeout', rid:'ss_node_table_v2_idle_timeout_tr', id:'ss_node_table_v2_idle_timeout', type:'text', maxlen:'3', value: "60", hidden:"yes"},
																	{ title: 'Health Check Timeout', rid:'ss_node_table_v2_health_check_timeout_tr', id:'ss_node_table_v2_health_check_timeout', type:'text', maxlen:'3', value: "20", hidden:"yes"},
																	{ title: 'Permit Without Stream', rid:'ss_node_table_v2_permit_without_stream_tr', id:'ss_node_table_v2_permit_without_stream', type:'select', func:'v', options:[["1", "启用"], ["0", "关闭"]], value: "0", hidden:"yes"},
																	{ title: 'Initial Windows Size', rid:'ss_node_table_v2_initial_windows_size_tr', id:'ss_node_table_v2_initial_windows_size', type:'text', maxlen:'300', ph:'没有请留空', hidden:"yes"},
																	{ title: '流控', rid:'ss_node_table_v2_tls_flow_tr', id:'ss_node_table_v2_tls_flow', func:'v',type:'select', options: tls_flows, style:'width:350px', value: "xtls-rprx-vision", hidden:"yes"},
																	{ title: '多路复用 (Mux)', rid:'ss_node_table_v2_mux_tr', id:'ss_node_table_v2_mux', type:'checkbox', func:'v', value:false, hidden:"yes"},
																	{ title: 'Mux并发连接数', rid:'ss_node_table_v2_concurrency_tr', id:'ss_node_table_v2_concurrency', type:'text', maxlen:'300', style:'width:338px', hidden:"yes"},
														{ title: 'Session Ticket', rid:'ss_node_table_tls_sessionTicket_tr', id:'ss_node_table_tls_sessionTicket', type:'text', maxlen:'300', value: "0", hidden:"yes"},
				// hy2
																	{ title: '认证密码', rid:'ss_node_table_hy2_auth_tr', id:'ss_node_table_hy2_auth', type:'text', class:'hy2_elem', maxlen:'300', style:'width:400px'},	//helloworld-full
																	{ title: 'tcp fast open', rid:'ss_node_table_fast_open_tr', id:'ss_node_table_fast_open', type:'checkbox', func:'v', class:'hy2_elem', value: "false"},	//helloworld-full
																	{ title: '混淆类型', rid:'ss_node_table_flag_obfs_tr', id:'ss_node_table_flag_obfs', type:'select', class:'hy2_elem', func:'v', options:option_hy2_obfs, maxlen:'300', style:'width:412px', value: "0"},	//helloworld-full
																	{ title: '混淆密码', rid:'ss_node_table_salamander_tr', id:'ss_node_table_salamander', type:'text', class:'hy2_elem', maxlen:'300', style:'width:400px'},	//helloworld-full
																]);
															</script>
															</table>
														</div>
													</td>
												</tr>
											</table>
											<div style="margin-top:5px;padding-bottom:10px;width:100%;text-align:center;">
												<input class="button_gen" style="margin-left: 160px;" type="button" onclick="cancel_add_rule();" id="cancelBtn" value="返回">
												<input id="add_node" class="button_gen" type="button" onclick="add_ss_node_conf(save_flag);" value="添加">
												<input id="edit_node" style="display: none;" class="button_gen" type="button" onclick="edit_ss_node_conf(save_flag);" value="修改">
												<a id="continue_add" style="display: none;margin-left: 20px;"><input id="continue_add_box" type="checkbox"  />连续添加</a>
											</div>
											<!--===================================Ending of vpnc setting Content===========================================-->
										</div>
										<div id="tablet_0" style="display: none;">
											<table id="table_basic" width="100%" border="0" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
												<script type="text/javascript">
													$('#table_basic').forms([
														{ title: '节点选择', id:'sstable_node', type:'select', func:'onchange="ss_node_sel();"', options:[], value: "1"},
														{ title: '节点类型', id:'sstable_type', type:'select', options:[["0", "SS"], ["1", "SSR"], ["2", "V2RAY"], ["3", "TROJAN"], ["4", "SOCKS5"]], value: "0", hidden:"yes"},
														{ title: '模式', id:'sstable_mode', type:'select', func:'v', hint:'1', options:option_modes, value: "1"},
														{ title: '服务器', id:'sstable_alias', type:'text', maxlen:'100', hidden:"yes"},
														{ title: '服务器', id:'sstable_server', type:'text', maxlen:'100'},
														{ title: '服务器端口', id:'sstable_port', type:'text', maxlen:'100'},
														{ title: '密码', id:'sstable_password', type:'password', maxlen:'100', peekaboo:'1', hidden:"yes"},
														{ title: '加密方式', id:'sstable_method_ss', type:'select', func:'v', hint:'5', options:option_method_aead, hidden:"yes"},
														{ title: '加密方式', id:'sstable_method', type:'select', func:'v', hint:'5', options:option_method, hidden:"yes"},
														{ title: '混淆插件 (obfs)', id:'sstable_plugin', type:'select', func:'v', options:[["none", "关闭"], ["v2ray-plugin", "v2ray-plugin"], ["obfs-local", "obfs-local"]], value: "none", hidden:"yes"},
														{ title: '混淆插件参数 (obfs_host)', id:'sstable_plugin_opts', type:'text', maxlen:'100', ph:'bing.com', hidden:"yes"},
														{ title: '协议 (protocol)', id:'sstable_protocol', type:'select', func:'v', options:option_protocals, hidden:"yes"},
														{ title: '协议参数 (protocol_param)', id:'sstable_protocol_param', type:'password', hint:'54', maxlen:'100', ph:'id:password', peekaboo:'1', hidden:"yes"},
														{ title: '混淆 (obfs)', id:'sstable_obfs', type:'select', func:'v', options:option_obfs, hidden:"yes"},
														{ title: '混淆参数 (obfs_param)', id:'sstable_obfs_param', type:'text', hint:'11', maxlen:'300', ph:'cloudflare.com;bing.com', hidden:"yes"},
														{ title: '布隆过滤器', id:'sstable_v2_ivCheck', type:'select', func:'v', options:[["1", "开启"], ["0", "关闭"]], value: "1", hidden:"yes"},
														{ title: '用户id (UUID)', id:'sstable_v2_vmess_id', type:'password', hint:'49', maxlen:'300', style:'width:300px;', peekaboo:'1', hidden:"yes"},
														{ title: '额外ID (Alterld)', id:'sstable_v2_alter_id', type:'text', hint:'48', maxlen:'50', hidden:"yes"},
														{ title: '协议(vmess/vless/trojan/ss/ssr)', id:'sstable_v2_protocol', type:'select', func:'v', options:[ "vmess", "vless", "trojan", "shadowsocks", "shadowsocksr", "wireguard", "socks", "http"], value: "vmess", hidden:"yes"},
														{ title: '加密方式 (security)', id:'sstable_v2_security', type:'select', hint:'47', options:option_v2enc, hidden:"yes"},
														{ title: 'VLESS 加密', id:'sstable_v2_encryption', type:'text', maxlen:'50', hidden:"yes", value: "none"},
														{ title: '传输协议 (network)', id:'sstable_v2_transport', type:'select', func:'v', hint:'35', options:["tcp", "mkcp", "ws", "h2", "quic", "grpc"], hidden:"yes"},
														{ title: '* tcp伪装类型 (type)', id:'sstable_v2_tcp_guise', type:'select', func:'v', hint:'36', options:option_headtcp, hidden:"yes"},
														{ title: '* kcp伪装类型 (type)', id:'sstable_v2_kcp_guise', type:'select', func:'v', hint:'37', options:option_headkcp, hidden:"yes"},
														{ title: '最大传输单元 (MTU)', id:'sstable_v2_mtu', type:'text', maxlen:'50', hidden:"yes", value: "1350"},
														{ title: '传输时间间隔 (TTI)', id:'sstable_v2_tti', type:'text', maxlen:'50', hidden:"yes", value: "50"},
														{ title: '上行链路容量', id:'sstable_uplink_capacity', type:'text', maxlen:'50', hidden:"yes", value: "5"},
														{ title: '下行链路容量', id:'sstable_downlink_capacity', type:'text', maxlen:'50', hidden:"yes", value: "20"},
														{ title: '读取缓冲区大小', id:'sstable_v2_read_buffer_size', type:'text', maxlen:'50', hidden:"yes", value: "2"},
														{ title: '写入缓冲区大小', id:'sstable_v2_write_buffer_size', type:'text', maxlen:'50', hidden:"yes", value: "2"},
														{ title: '混淆密码（可选）', id:'sstable_v2_seed', type:'text', maxlen:'50', hidden:"yes", ph:'没有请留空', value: ""},
														{ title: '拥塞控制', id:'sstable_v2_congestion', type:'checkbox', func:'v', hidden:"yes", value: false},
														{ title: '* 伪装域名 (host)', id:'sstable_v2_http_host', type:'text', maxlen:'300', ph:'没有请留空', hidden:"yes"},
														{ title: '* 路径 (path)', id:'sstable_v2_http_path', type:'text', maxlen:'300', ph:'没有请留空', hidden:"yes"},
														{ title: 'TLS', id:'sstable_v2_tls', type:'checkbox', func:'v', hidden:"yes"},
														{ title: 'Reality', id:'sstable_v2_reality', type:'checkbox', func:'v', hidden:"yes"},
														{ title: 'Public key', id:'sstable_v2_reality_publickey', type:'text', maxlen:'999', ph:'没有请留空', hidden:"yes", hint:'112'},
														{ title: 'Short ID', id:'sstable_v2_reality_shortid', type:'text', maxlen:'20', ph:'没有请留空', hidden:"yes", hint:'113'},
														{ title: 'spiderX', id:'sstable_v2_reality_spiderx', type:'text', maxlen:'300', ph:'没有请留空', hidden:"yes", hint:'114'},
														{ title: 'TLS伪装域名', id:'sstable_tls_host', type:'text', maxlen:'300', ph:'没有请留空', hidden:"yes"},
														{ title: '指纹伪造', id:'sstable_v2_fingerprint', type:'select', func:'v', options:[["disable", "关闭"], ["firefox", "firefox"], ["chrome", "chrome"]],value: "disable", hidden:"yes"},
														{ title: 'QUIC加密', id:'sstable_v2_quic_security', type:'select', func:'v', options:[["none", "关闭"], ["aes-128-gcm", "aes-128-gcm"], ["chacha20-poly1305", "chacha20-poly1305"]],value: "none", hidden:"yes"},
														{ title: 'QUIC Key', id:'sstable_v2_quic_key', type:'text', maxlen:'300', ph:'没有请留空', hidden:"yes"},
														{ title: '伪装类型', id:'sstable_v2_quic_guise', type:'select', func:'v', options:option_headkcp,value: "none", hidden:"yes"},
														{ title: '允许不安全连接', id:'sstable_insecure', type:'checkbox', func:'v', hidden:"yes"},
														{ title: 'serviceName', id:'sstable_v2_serviceName', type:'text', maxlen:'300', ph:'没有请留空', hidden:"yes"},
														{ title: 'gRPC/H2 Health Check', id:'sstable_v2_health_check', type:'checkbox', func:'v', hidden:"yes"},
														{ title: 'gRPC/H2 Read Idle Timeout', id:'sstable_v2_idle_timeout', type:'text', maxlen:'3', ph:'没有请留空', hidden:"yes"},
														{ title: 'Health Check Timeout', id:'sstable_v2_health_check_timeout', type:'text', maxlen:'3', ph:'没有请留空', hidden:"yes"},
														{ title: 'Permit Without Stream', id:'sstable_v2_permit_without_stream', type:'select',func:'v', options:[["1", "启用"], ["0", "关闭"]], value: "0", hidden:"yes"},
														{ title: 'Initial Windows Size', id:'sstable_v2_initial_windows_size', type:'text', maxlen:'6', ph:'没有请留空', hidden:"yes"},
														{ title: '流控', id:'sstable_v2_tls_flow', type:'select', func:'v', options:tls_flows, value: "xtls-rprx-vision", hidden:"yes"},
														{ title: '多路复用 (Mux)', id:'sstable_v2_mux', type:'checkbox', func:'v', hint:'31', hidden:"yes"},
														{ title: 'Mux并发连接数', id:'sstable_v2_concurrency', type:'text', hint:'32', maxlen:'300', hidden:"yes"},
														{ title: 'Session Ticket', id:'sstable_tls_sessionTicket', type:'text', maxlen:'300', value: "0", hidden:"yes"},
				// hy2
														{ title: '认证密码', id:'sstable_hy2_auth', type:'text', class:'hy2_elem', maxlen:'300', style:'width:400px'},	//helloworld-full
														{ title: 'tcp fast open', id:'sstable_fast_open', type:'checkbox', class:'hy2_elem', value: "false"},	//helloworld-full
														{ title: '混淆类型', id:'sstable_flag_obfs', type:'select', class:'hy2_elem', func:'v', options:option_hy2_obfs, maxlen:'300', style:'width:412px', value: "0"},	//helloworld-full
														{ title: '混淆密码', id:'sstable_salamander', type:'text', class:'hy2_elem', maxlen:'300', style:'width:400px'},	//helloworld-full
													]);
												</script>
											</table>
										</div>
										<div id="tablet_1" style="display: none;">
											<div id="ss_list_table"></div>
										</div>
										<div id="tablet_2" style="display: none;">
											<table id="table_failover" style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" >
												<script type="text/javascript">
													var fa1 = ["2", "3", "4", "5"];
													var fa2_1 = ["10", "15", "20"];
													var fa2_2 = ["2", "3", "4", "5", "6", "7", "8"];
													var fa3_1 = ["10", "15", "20"];
													var fa3_2 = ["100", "150", "200", "250", "300", "350", "400", "450", "500", "1000"];
													var fa4_1 = [["0", "关闭插件"], ["1", "重启插件"], ["2", "切换到"]];
													var fa4_2 = [["1", "备用节点"], ["2", "下个节点"]];
													var fa5 = [["1", "2s - 3s"], ["2", "4s - 7s"], ["3", "8s - 15s"], ["4", "16s - 31s"], ["5", "32s - 63s"]];
													$('#table_failover').forms([
														{ title: '故障转移开关', id:'ssconf_failover_enable',type:'checkbox', func:'v', value:false},
														{ title: '故障转移设置', rid:'failover_settings_1', multi: [
															{ suffix:'<div style="margin-top: 5px;">' },
															{ id:'ssconf_failover_c1', type:'checkbox', value:false },
															{ suffix:'<lable>&nbsp;国外连续发生&nbsp;</lable>' },
															{ id:'ssconf_failover_s1', type:'select', style:'width:auto', options:fa1, value:'3'},
															{ suffix:'<lable>&nbsp;次故障；<br /></lable>' },
															{ suffix:'</div>' },
															//line3
															{ suffix:'<div style="margin-top: 5px;">' },
															{ id:'ssconf_failover_c2', type:'checkbox', value:false },
															{ suffix:'<lable>&nbsp;最近&nbsp;</lable>' },
															{ id:'ssconf_failover_s2_1', type:'select', style:'width:auto', options:fa2_1, value:'15'},
															{ suffix:'<lable>&nbsp;次国外状态检测中，故障次数超过&nbsp;</lable>' },
															{ id:'ssconf_failover_s2_2', type:'select', style:'width:auto', options:fa2_2, value:'4'},
															{ suffix:'<lable>&nbsp;次；<br /></lable>' },
															{ suffix:'</div>' },
															//line4
															{ suffix:'<div style="margin-top: 5px;">' },
															{ id:'ssconf_failover_c3', type:'checkbox', value:false },
															{ suffix:'<lable>&nbsp;最近&nbsp;</lable>' },
															{ id:'ssconf_failover_s3_1', type:'select', style:'width:auto', options:fa3_1, value:'20'},
															{ suffix:'<lable>&nbsp;次国外状态检测中，平均延迟超过&nbsp;</lable>' },
															{ id:'ssconf_failover_s3_2', type:'select', style:'width:auto', options:fa3_2, value:'500'},
															{ suffix:'<lable>ms<br /></lable>' },
															{ suffix:'</div>' },
															//line5
															{ suffix:'<div style="margin-top: 5px;">' },
															{ suffix:'<lable>&nbsp;以上有一个条件满足，则&nbsp;</lable>' },
															{ id:'ssconf_failover_s4_1', type:'select', style:'width:auto', func:'v', options:fa4_1, value:'2'},
															{ id:'ssconf_failover_s4_2', type:'select', style:'width:auto', func:'v', options:fa4_2, value:'2'},
															{ id:'ssconf_failover_s4_3', type:'select', style:'width:170px', func:'v', options:[]},
															{ suffix:'<lable id="ssconf_failover_text_1">&nbsp;，即在节点列表内顺序循环。&nbsp;</lable>' },
															{ suffix:'</div>' },
														]},
														{ title: '状态检测时间间隔', rid:'interval_settings', multi: [
															{ id:'ssconf_basic_interval', type:'select', style:'width:auto',options:fa5, value:'2'},
															{ suffix:'<small>&nbsp;默认:4 - 7s</small>' },
														]},
														{ title: '历史记录保存数量', rid:'failover_settings_2', multi: [
															{ suffix:'<lable>最多保留&nbsp;</lable>' },
															{ id:'ssconf_failover_s5', type:'select', style:'width:auto',options:["1000", "2000", "3000", "4000"], value:'2000'},
															{ suffix:'<lable>&nbsp;行日志&nbsp;</lable>' },
														]},
														{ title: '查看历史状态', rid:'failover_settings_3', multi: [
															{ suffix:'<a type="button" id="look_logf" class="ss_btn" style="cursor:pointer" onclick="lookup_status_log(1)">国外状态历史</a>&nbsp;' },
															{ suffix:'<a type="button" id="look_logc" class="ss_btn" style="cursor:pointer" onclick="lookup_status_log(2)">国内状态历史</a>' },
														]},
													]);
												</script>
											</table>
											<div align="center" style="margin-top: 10px;">
												<input class="button_gen" type="button" onclick="save()" value="保存&amp;应用">
												<input style="margin-left:10px" id="ssconf_failover_save" class="button_gen" onclick="save_failover()" type="button" value="保存本页设置">
											</div>
											
										</div>
										<div id="tablet_3" style="display: none;">
											<table id="table_dns" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
												<script type="text/javascript">
													var option_dnsc = [["1", "运营商DNS【自动获取】"], ["2", "阿里DNS1【223.5.5.5】"], ["3", "阿里DNS2【223.6.6.6】"], ["4", "114DNS1【114.114.114.114】"], ["5", "114DNS2【114.114.115.115】"], ["6", "cnnic DNS1【1.2.4.8】"], ["7", "cnnic DNS2【210.2.4.8】"], ["8", "oneDNS1【117.50.11.11】"], ["9", "oneDNS2【117.50.11.22】"], ["10", "百度DNS【180.76.76.76】"], ["11", "DNSpod DNS【119.29.29.29】"]];
													var option_dnsf = [ ["1", "pdnsd"], ["2", "chinadns-ng"], ["3", "dns2socks"], ["4", "smartdns"], ["8", "direct"]];
													var ph1 = "需端口号如:8.8.8.8:53"
													var ph2 = "需端口号如:8.8.8.8#53"
													var ph3 = "# 填入自定义的dnsmasq设置，一行一个&#10;# 例如hosts设置:&#10;address=/weibo.com/2.2.2.2&#10;# 防DNS劫持设置:&#10;bogus-nxdomain=220.250.64.18"
													$('#table_dns').forms([
														{ title: '选择中国DNS', id: 'ssconf_dns_china', type:'select', func:'u', options:option_dnsc, style:'width:auto;', value:'11'},
														{ title: '选择外国DNS', hint:'26', rid:'dns_plan_foreign', id: 'ssconf_foreign_dns', type:'select', func:'u', options:option_dnsf, style:'width:auto;', value:'4'},
														{ title: 'DNS劫持(原chromecast功能)', id:'ssconf_basic_dns_hijack', type:'checkbox', func:'v', hint:'106', value:true},
														{ title: '节点域名解析DNS服务器', hint:'107', id: 'ssconf_basic_server_resolver', type:'select', func:'u', options:option_dnsc, style:'width:auto;', value:'1'},	
														{ title: '自定义dnsmasq', id:'ssconf_dnsmasq', type:'textarea', hint:'34', rows:'12', ph:ph3},
													]);
												</script>
											</table>
										</div>
										<div id="tablet_4" style="display: none;">
											<table id="table_wblist" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
												<script type="text/javascript">
													var ph1 = "# 填入不需要走代理的外网ip地址，一行一个，格式（IP/CIDR）如下&#10;2.2.2.2&#10;3.3.3.3&#10;4.4.4.4/24";
													var ph2 = "# 填入不需要走代理的域名，一行一个，格式如下：&#10;google.com&#10;facebook.com&#10;# 需要清空电脑DNS缓存，才能立即看到效果。";
													var ph3 = "# 填入需要强制走代理的外网ip地址，一行一个，格式（IP/CIDR）如下：&#10;5.5.5.5&#10;6.6.6.6&#10;7.7.7.7/8";
													var ph4 = "# 填入需要强制走代理的域名，一行一个，格式如下：&#10;baidu.com&#10;taobao.com&#10;# 需要清空电脑DNS缓存，才能立即看到效果。";
													$('#table_wblist').forms([
														{ title: 'IP/CIDR白名单<br><br><font color="#ffcc00">添加不需要走代理的外网ip地址</font>', id:'ssconf_wan_white_ip', type:'textarea', hint:'38', rows:'7', ph:ph1},
														{ title: '域名白名单<br><br><font color="#ffcc00">添加不需要走代理的域名</font>', id:'ssconf_wan_white_domain', type:'textarea', hint:'39', rows:'7', ph:ph2},
														{ title: 'IP/CIDR黑名单<br><br><font color="#ffcc00">添加需要强制走代理的外网ip地址</font>', id:'ssconf_wan_black_ip', type:'textarea', hint:'40', rows:'7', ph:ph3},
														{ title: '域名黑名单<br><br><font color="#ffcc00">添加需要强制走代理的域名</font>', id:'ssconf_wan_black_domain', type:'textarea', hint:'41', rows:'7', ph:ph4},
													]);
												</script>
											</table>
										</div>
										<div id="tablet_5" style="display: none;">
											<table id="table_kcp" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
												<script type="text/javascript">
													var ph1 = "# 填入你的kcptun运行参数，每个参数用空格隔开，格式如下：&#10;--crypt salsa20 --key mjy211 --sndwnd 1024 --rcvwnd 1024 --mtu 1300 --nocomp --mode fast2";
													$('#table_kcp').forms([
														{ title: 'KCP加速开关', id:'ssconf_basic_use_kcp', type:'checkbox', func:'v', value:false},
														{ title: 'kcp本地监听地址：端口 （-l）', multi: [
															{ id: 'ssconf_basic_kcp_lserver', type: 'text', maxlen:'200', style:'width:120px;', value:'127.0.0.1'},
															{ suffix: '&nbsp;:&nbsp;' },
															{ id: 'ssconf_basic_kcp_lport', type: 'text', maxlen:'200', style:'width:44px;', value:'1091'},
														]},
														{ title: 'kcp服务器地址：端口 （-r）', multi: [
															{ id: 'ssconf_basic_kcp_server', type: 'text', maxlen:'200', style:'width:120px;'},
															{ suffix: '&nbsp;:&nbsp;' },
															{ id: 'ssconf_basic_kcp_port', type: 'text', maxlen:'200', style:'width:44px;'},
														]},
														{ title: '密码 (--key)', rid:'sstable_kcp_password_tr', id:'ssconf_basic_kcp_password', type:'password', maxlen:'200', style:'width:120px;', ph:'没有请留空'},
														{ title: 'KCP参数', rid:'sstable_kcp_parameter_tr', id:'ssconf_kcp_parameter', type:'textarea', rows:'4', ph:ph1},
													]);
												</script>
											</table>
										</div>
										<div id="tablet_6" style="display: none;">
											<table id="table_rules" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" >
												<script type="text/javascript">
													var option_ruleu = [];
													for (var i = 0; i < 24; i++){
														var _tmp = [];
														_i = i < 10 ? String("0" + i) : String(i)
														_tmp[0] = i;
														_tmp[1] = _i + ":00时";
														option_ruleu.push(_tmp);
													}
													function addCommas(nStr) {
														nStr += '';
														var x = nStr.split('.');
														var x1 = x[0];
														var x2 = x.length > 1 ? '.' + x[1] : '';
														var rgx = /(\d+)(\d{3})/;
														while (rgx.test(x1)) {
														    x1 = x1.replace(rgx, '$1' + ',' + '$2');
														}
														return x1 + x2;
													}
													//var ipsn='<% nvram_get("chnroute_ips"); %>'
													var gfwl = addCommas('<% nvram_get("ipset_numbers"); %>');
													var chnl = addCommas('<% nvram_get("chnroute_numbers"); %>');
													var chnn = addCommas('<% nvram_get("chnroute_ips"); %>');
													var cdnn = addCommas('<% nvram_get("cdn_numbers"); %>');
													$('#table_rules').forms([
														{ title: 'gfwlist域名数量', multi: [
															{ suffix: '<em>'+ gfwl +'</em>&nbsp;条，版本：' },
															{ suffix: '<a href="https://github.com/zusterben/plan_f/blob/master/rules/gfwlist.conf" target="_blank">' },
															{ suffix: '<i><% nvram_get("update_ipset"); %></i></a>' },
														]},
														{ title: '大陆白名单IP段数量', multi: [
															{ suffix: '<em>'+ chnl +'</em>&nbsp;行，包含 <em>' + chnn + '</em>&nbsp;个ip地址，版本：' },
															{ suffix: '<a href="https://github.com/zusterben/plan_f/blob/master/rules/chnroute.txt" target="_blank">' },
															{ suffix: '<i><% nvram_get("update_chnroute"); %></i></a>' },
														]},
														{ title: '国内域名数量（cdn名单）', multi: [
															{ suffix: '<em>'+ cdnn +'</em>&nbsp;条，版本：' },
															{ suffix: '<a href="https://github.com/zusterben/plan_f/blob/master/rules/cdn.txt" target="_blank">' },
															{ suffix: '<i><% nvram_get("update_cdn"); %></i></a>' },
														]},
														{ title: '规则定时更新任务', hint:'44', multi: [
															{ id:'ssconf_basic_rule_update', type:'select', func:'u', style:'width:auto', options:[["0", "禁用"], ["1", "开启"]], value:'0'},
															{ id:'ssconf_basic_rule_update_time', type:'select', style:'width:auto', options:option_ruleu, value:'4'},
															{ suffix: '<a id="update_choose">' },
															{ suffix: '<input type="checkbox" id="ssconf_basic_gfwlist_update" title="选择此项应用gfwlist自动更新">gfwlist' },
															{ suffix: '<input type="checkbox" id="ssconf_basic_chnroute_update">chnroute' },
															{ suffix: '<input type="checkbox" id="ssconf_basic_cdn_update">CDN</a>' },
															{ suffix: '&nbsp;<a type="button" class="ss_btn" style="cursor:pointer" onclick="updatelist(1)">保存设置</a>' },
															{ suffix: '&nbsp;<a type="button" class="ss_btn" style="cursor:pointer" onclick="updatelist(2)">立即更新</a>' },
														]}
													]);
												</script>
											</table>
											<table id="table_subscribe" style="margin:8px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
												<script type="text/javascript">
													var option_noded = [["7", "每天"], ["1", "周一"], ["2", "周二"], ["3", "周三"], ["4", "周四"], ["5", "周五"], ["6", "周六"], ["6", "周日"]];
													var option_nodeh = [];
													for (var i = 0; i < 24; i++){
														var _tmp = [];
														_i = String(i)
														_tmp[0] = _i;
														_tmp[1] = _i + "点";
														option_nodeh.push(_tmp);
													}
													var ph1 = "填入需要订阅的地址，多个地址分行填写";
													var ph2 = "多个关键词用英文逗号分隔，如：测试,过期,剩余,曼谷,M247,D01,硅谷";
													var ph3 = "多个关键词用英文逗号分隔，如：香港,深圳,NF,BGP";
													$('#table_subscribe').forms([
														{ title: 'SSR/v2ray/Trojan订阅设置', thead:'1'},
														{ title: '订阅地址管理（支持SSR/v2ray/Trojan）', id:'ssconf_online_links', type:'textarea', rows:'8', ph:ph1},
														{ title: '订阅节点模式设定（SSR/v2ray/Trojan）', id:'ssconf_subscribe_mode', type:'select', style:'width:auto', options:option_modes, value:'1'},
														{ title: '下载订阅时走SS/SSR/v2ray/Trojan代理网络', id:'ssconf_basic_online_links_goss', type:'select', style:'width:auto', options:[["0", "不走代理"], ["1", "走代理"]], value:'0'},
														{ title: '订阅计划任务', multi: [
															{ id:'ssconf_basic_node_update', type:'select', style:'width:auto', func:'u', options:[["0", "禁用"], ["1", "开启"]], value:'0'},
															{ id:'ssconf_basic_node_update_day', type:'select', style:'width:auto', options:option_noded, value:'6'},
															{ id:'ssconf_basic_node_update_hr', type:'select', style:'width:auto', options:option_nodeh, value:'3'},
														]},
														{ title: '[排除]关键词（含关键词的节点不会添加）', rid:'ssconf_basic_exclude_tr', id:'ssconf_basic_exclude', type:'text', hint:'110', maxlen:'300', style:'width:95%', ph:ph2},
														{ title: '[包括]关键词（含关键词的节点才会添加）', rid:'ssconf_basic_include_tr', id:'ssconf_basic_include', type:'text', hint:'111', maxlen:'300', style:'width:95%', ph:ph3},
														{ title: '删除节点', multi: [
															{ suffix:'<a type="button" class="ss_btn" style="cursor:pointer" onclick="get_online_nodes(0)">删除全部节点</a>'},
															{ suffix:'&nbsp;<a type="button" class="ss_btn" style="cursor:pointer" onclick="get_online_nodes(1)">删除全部订阅节点</a>'},
														]},
														{ title: '订阅操作', multi: [
															{ suffix:'<a type="button" class="ss_btn" style="cursor:pointer" onclick="get_online_nodes(2)">仅保存设置</a>'},
															{ suffix:'&nbsp;<a type="button" class="ss_btn" style="cursor:pointer" onclick="get_online_nodes(3)">保存并订阅</a>'},
														]},
													]);
												</script>
											</table>
											<table id="table_link" style="margin:8px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
												<script type="text/javascript">
													var ph1 = "填入以ss://或者ssr://或者vmess://或者trojan://开头的链接，多个链接请分行填写";
													$('#table_subscribe').forms([
														{ title: '通过SS/SSR/vmess/Trojan链接添加服务器', thead:'1'},
														{ title: 'SS/SSR/vmess/Trojan链接', id:'ssconf_base64_links', type:'textarea', rows:'9', ph:ph1},
														{ title: '操作', suffix:'<a type="button" class="ss_btn" style="cursor:pointer" onclick="get_online_nodes(4)">解析并保存为节点</a>'},
													]);
												</script>
											</table>
										</div>
										<div id="tablet_7" style="display: none;">
											<div id="ssconf_acl_table"></div>
											<div id="ACL_note" style="margin:10px 0 0 5px">
												<div><i>1&nbsp;&nbsp;默认状态下，所有局域网的主机都会走当前节点的模式（主模式），相当于即不启用局域网访问控制。</i></div>
												<div><i>2&nbsp;&nbsp;当你设置默认规则为不通过代理，添加了主机走大陆白名单模式，则只有添加的主机才会走代理(大陆白名单模式)。</i></div>
												<div><i>3&nbsp;&nbsp;当你设置默认规则为正在使用节点的模式，除了添加的主机才会走相应的模式，未添加的主机会走默认规则的模式。</i></div>
												<div><i>4&nbsp;&nbsp;如果为使用的节点配置了KCP协议，因为它们不支持udp，所以不能控制主机走游戏模式。</i></div>
												<div><i>5&nbsp;&nbsp;如果需要自定义端口范围，适用英文逗号和冒号，参考格式：80,443,5566:6677,7777:8888</i></div>
											</div>
										</div>
										<div id="tablet_8" style="display: none;">
											<table id="table_addons" style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" >
												<script type="text/javascript">
													var title1 = "填写说明：&#13;此处填写1-23之间任意小时&#13;小时间用逗号间隔，如：&#13;当天的8点、10点、15点则填入：8,10,15"
													var option_rebc = [["0", "关闭"], ["1", "每天"], ["2", "每周"], ["3", "每月"], ["4", "每隔"], ["5", "自定义"]];
													var option_rebw = [["1", "一"], ["2", "二"], ["3", "三"], ["4", "四"], ["5", "五"], ["6", "六"], ["7", "日"]];
													var option_rebd = [];
													for (var i = 1; i < 32; i++){
														var _tmp = [];
														_i = String(i)
														_tmp[0] = _i;
														_tmp[1] = _i + "日";
														option_rebd.push(_tmp);
													}
													var option_rebim = ["1", "5", "10", "15", "20", "25", "30"];
													var option_rebih = [];
													for (var i = 1; i < 13; i++) option_rebih.push(String(i));
													var option_rebid = [];
													for (var i = 1; i < 31; i++) option_rebid.push(String(i));
													var option_rebip = [["1", "分钟"], ["2", "小时"], ["3", "天"]];
													var option_rebh = [];
													for (var i = 0; i < 24; i++){
														var _tmp = [];
														_i = String(i)
														_tmp[0] = _i;
														_tmp[1] = _i + "时";
														option_rebh.push(_tmp);
													}
													var option_rebm = [];
													for (var i = 0; i < 61; i++){
														var _tmp = [];
														_i = String(i)
														_tmp[0] = _i;
														_tmp[1] = _i + "分";
														option_rebm.push(_tmp);
													}
													var option_trit = [["0", "关闭"], ["2", "每隔2分钟"], ["5", "每隔5分钟"], ["10", "每隔10分钟"], ["15", "每隔15分钟"], ["20", "每隔20分钟"], ["25", "每隔25分钟"], ["30", "每隔30分钟"]];
													var pingm = [["1", "ping(1次/节点)"], ["2", "ping(5次/节点)"], ["3", "ping(10次/节点)"], ["4", "ping(20次/节点)"]];
													$('#table_addons').forms([
														{ td: '<tr><td class="smth" style="font-weight: bold;" colspan="2">定时任务</td></tr>'},
														{ title: '&nbsp;&nbsp;&nbsp;&nbsp;插件定时重启设定', multi: [
															{ id:'ssconf_reboot_check', type:'select', style:'width:auto', func:'v', options:option_rebc, value:'0'},
															{ id:'ssconf_basic_week', type:'select', style:'width:auto', css:'re2', options:option_rebw, value:'1'},
															{ id:'ssconf_basic_day', type:'select', style:'width:auto', css:'re3', options:option_rebd, value:'1'},
															{ id:'ssconf_basic_inter_min', type:'select', style:'width:auto', css:'re4_1', options:option_rebim, value:'1'},
															{ id:'ssconf_basic_inter_hour', type:'select', style:'width:auto', css:'re4_2', options:option_rebih, value:'1'},
															{ id:'ssconf_basic_inter_day', type:'select', style:'width:auto', css:'re4_3', options:option_rebid, value:'1'},
															{ id:'ssconf_basic_inter_pre', type:'select', style:'width:auto', func:'v', css:'re4', options:option_rebip, value:'1'},
															{ id:'ssconf_basic_custom', type:'text', style:'width:150px', css:'re5', ph:'8,10,15', title:title1},
															{ suffix:'<span class="re5">&nbsp;小时</span>'},
															{ id:'ssconf_basic_time_hour', type:'select', style:'width:auto', css:'re1 re2 re3 re4_3', options:option_rebh, value:'0'},
															{ id:'ssconf_basic_time_min', type:'select', style:'width:auto', css:'re1 re2 re3 re4_3 re5', options:option_rebm, value:'0'},
															{ suffix:'&nbsp;<span class="re1 re2 re3 re4 re5">重启插件</span>'},
															{ suffix:'&nbsp;<a type="button" class="ss_btn" style="cursor:pointer" onclick="set_cron(1)">保存设置</a>'},
														]},
														{ title: '&nbsp;&nbsp;&nbsp;&nbsp;插件触发重启设定', multi: [
															{ id:'ssconf_basic_tri_reboot_time', type:'select', style:'width:auto', help:'109', func:'u', options:option_trit, value:'0'},
															{ suffix:'<span id="ssconf_basic_tri_reboot_time_note">&nbsp;解析服务器IP，如果发生变更，则重启插件！</span>'},
															{ suffix:'&nbsp;<a type="button" class="ss_btn" style="cursor:pointer" onclick="set_cron(2)">保存设置</a>'},
														]},
														{ td: '<tr><td class="smth" style="font-weight: bold;" colspan="2">节点列表</td></tr>'},
														{ title: '&nbsp;&nbsp;&nbsp;&nbsp;ping测试设置', multi: [
															{ id:'ssconf_basic_ping_node', type:'select', style:'width:auto;max-width:220px', func:'onchange="ping_switch();"', options:[]},
															{ id:'ssconf_basic_ping_method', type:'select', style:'width:auto', help:'109', options:pingm, value:'1'},
															{ suffix:'&nbsp;<input id="sstable_ping_btn" class="ss_btn" style="cursor:pointer;" onClick="ping_now()" type="button" value="开始ping！"/>'},
														]},
														{ title: '&nbsp;&nbsp;&nbsp;&nbsp;节点列表最大显示行数', id:'ssconf_basic_row', type:'select', func:'onchange="save_row();"', style:'width:auto', options:[]},
														{ title: '&nbsp;&nbsp;&nbsp;&nbsp;开启节点排序功能', id:'ssconf_basic_dragable', func:'v', type:'checkbox', value:true},
														{ title: '&nbsp;&nbsp;&nbsp;&nbsp;设置节点列表为默认标签页', id:'ssconf_basic_tablet', func:'v', type:'checkbox', value:false}, 
														{ title: '&nbsp;&nbsp;&nbsp;&nbsp;开启netflix支持', id:'ssconf_basic_netflix_enable', func:'v', type:'checkbox', value:false},
														{ td: '<tr><td class="smth" style="font-weight: bold;" colspan="2">性能优化</td></tr>'},
														{ title: '&nbsp;&nbsp;&nbsp;&nbsp;ss/ssr/trojan 开启多核心支持', id:'ssconf_basic_mcore', help:'108', type:'checkbox', value:true},
														{ title: '&nbsp;&nbsp;&nbsp;&nbsp;ss-libev / v2ray 开启tcp fast open', id:'ssconf_basic_tfo', type:'checkbox', value:false},
													]);
												</script> 
											</table>
										</div>
										<div id="tablet_9" style="display: none;">
												<div id="log_content" style="margin-top:-1px;overflow:hidden;">
													<textarea cols="63" rows="36" wrap="on" readonly="readonly" id="log_content1" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>
												</div>
										</div>
										<div class="apply_gen" id="loading_icon">
											<img id="loadingIcon" style="display:none;" src="/images/InternetScan.gif">
										</div>
										<div id="apply_button" class="apply_gen">
											<input class="button_gen" type="button" onclick="save()" value="保存&应用">
										</div>
									</td>
								</tr>
							</table>
						</div>
					</td>
				</tr>
			</table>
		</td>
		<td width="10" align="center" valign="top"></td>
	</tr>
</table>
<div id="footer"></div>
</body>
</html>

