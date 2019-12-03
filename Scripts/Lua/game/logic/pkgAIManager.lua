doNameSpace("pkgAIManager")

m_tbTask = m_tbTask or {}
m_tbRunningAction = m_tbRunningAction or {}

function UpdateAction()
    for objAction, _ in pairs(m_tbRunningAction) do
        local luaAction = GetLuaTask(objAction)
        if luaAction.OnUpdate ~= nil and luaAction.bIsRunning == true then
            luaAction:OnUpdate()
        end
    end
end

function GetLuaTask(obj)
    return m_tbTask[obj]
end

function CreateLuaTask(obj, strLuaCls)
    local strCreate = string.format("return %s:new()", strLuaCls) 
    local luaTask = loadstring(strCreate)()
    if not luaTask then
        print(string.format("create %s failed...", strLuaCls))
        return
    end
    local playerController = obj.Agent.gameObject:GetComponent(PlayerController)
    local owner = pkgActorManager.GetActor(playerController:GetPlayerId())
    if not owner then

    end
    luaTask.owner = owner
    luaTask.task = obj
    m_tbTask[obj] = luaTask

    return luaTask
end

function OnActionInit(objAction, strLuaCls)
    local luaAction = CreateLuaTask(objAction, strLuaCls)
    luaAction:OnInit()
end

function OnActionStop(objAction)
    local luaAction = GetLuaTask(objAction)
    luaAction.bIsRunning = false
    luaAction:OnStop()
    m_tbRunningAction[objAction] = false
end

function OnActionPause(objAction)
    local luaAction = GetLuaTask(objAction)
    luaAction:OnPause()
end

function OnActionExecute(objAction)
    local luaAction = GetLuaTask(objAction)
    luaAction.bIsRunning = true
    luaAction:OnExecute()
    m_tbRunningAction[objAction] = true
end

function OnActionUpdate(objAction)
    local luaAction = GetLuaTask(objAction)
    luaAction:OnUpdate()
end

function OnConditionInit(objCondition, strLuaCls)
    local luaCondition = CreateLuaTask(objCondition, strLuaCls) 
    luaCondition:OnInit()  
end

function OnConditionCheck(objCondition)
    local luaCondition = GetLuaTask(objCondition) 
    luaCondition:OnCheck() 
  end