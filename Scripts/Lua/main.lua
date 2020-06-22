
import "UnityEngine"
_G.ue = UnityEngine

require "luapack"
cjson = require "cjson"
bit = require "tool/bitop"

require("initPath")
require("share/load")
require("startHeader")

randomSeed()

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
	--pkgGameController.Init()
	pkgTriggerManager.Init()
	pkgProtocolManager.Init()
	pkgSysBattle.Init()
	pkgSysMonster.Init()
	-- init ui
	pkgUIBaseViewMgr.showByViewPath("game/ui/pkgStartUI")
end

local function start()
	init()
end

function __G_traceback_from_lua__(msg,lbpLevelOffset)
	local tracebackStr = debug.traceback()
	print("LUA ERROR:" .. tostring(msg) .. "\n" .. tracebackStr .. "\n")
	return msg
end

xpcall(start, __G_traceback_from_lua__)