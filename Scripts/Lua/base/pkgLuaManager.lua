doNameSpace("pkgLuaManager")

function Init()
	local go = pkgGlobalGoMgr.GetGlobalGo()
	KG.LuaMonoBehaviour.Bind(go, "pkgLuaManager")
end

function Awake()
	
end

function Start()
	
end

function Update()
	if _G.__loading then
		return
	end
	pkgTimer.Update(0.03)
	pkgInputMgr.Update()
	pkgFSMManger.UpdateFSM()
	pkgAIManager.UpdateAction()
	pkgSysAI.UpdateCheckFOV()
	pkgSocket.ReceiveMsg()
end

--[[function FixedUpdate()
	print("FixedUpdate")
end

function LateUpdate()
	print("LateUpdate")
end--]]