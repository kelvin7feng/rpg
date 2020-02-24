import "UnityEngine"

require "luapack"

require("config/configHeader")

require("tool/toolHeader")
require("base/baseHeader")
require("share/shareHeader")
require("net/socket/socketHeader")
require("net/protocol/protocalHeader")

require("game/ai/aiHeader")
require("game/defination/definationHeader")
require("game/logic/logicHeader")
require("game/system/systemHeader")
require("game/ui/uiHeader")
require("game/entity/entityHeader")
require("game/fsm/fsmHeader")
require("game/stat/statHeader")

local function initDebug()
	local breakSocketHandle,debugXpCall = require("LuaDebugjit")("localhost",7003)
	LuaTimer.Add(0,1000,function(id)
		breakSocketHandle()
	end)
end

function hex(s)
	s=string.gsub(s,"(.)",function (x) return string.format("%02X",string.byte(x)) end)
	return s
end

local function init()
	-- initDebug()
	pkgTimer.Init()
	pkgGlobalGoMgr.Init()
	pkgPoolManager.Init()
	pkgLuaManager.Init()
	pkgCanvasMgr.Init()
	pkgGameController.Init()
	pkgTriggerManager.Init()
	pkgProtocolManager.InitProtocol()
	
	pkgSocket.ConnectToServer(pkgGlobalConfig.GATEWAT_IP, pkgGlobalConfig.GATEWAY_PORT)
end

local function start()
	local function onLoadComplete(prefab)
		init()
	end
	
	init()
end

function __G_traceback_from_lua__(msg,lbpLevelOffset)
	local tracebackStr = debug.traceback()
	print("LUA ERROR:" .. tostring(msg) .. "\n" .. tracebackStr .. "\n")
	return msg
end

xpcall(start, __G_traceback_from_lua__)