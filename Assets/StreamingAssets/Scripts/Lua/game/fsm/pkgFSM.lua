FSM = class()

function FSM:ctor(owner)
    self.owner = owner
    self.states = {}
    self.curState = nil
end

-- 添加状态
function FSM:AddState(baseState)
    baseState.fsm = self
    self.states[baseState.stateName] = baseState
end

-- 初始化默认状态
function FSM:SetInitState(stateName)
    if self.states[stateName] then
        self.curState = self.states[stateName]
    end
end

-- 更新当前状态
function FSM:Update()
    self.curState:OnUpdate()
end

-- 检查当前状态
function FSM:IsInState(stateName)
    if stateName == self:GetCurrentState() then
        return true
    else
        return false
    end
end

-- 切换状态
function FSM:Switch(stateName, ...)
    if self.curState.stateName ~= stateName then
        self.curState:OnLeave()
        self.curState = self.states[stateName]
        self.curState:OnEnter(...)
    end
end

-- 获取当前状态
function FSM:GetCurrentState()
    return self.curState.stateName
end