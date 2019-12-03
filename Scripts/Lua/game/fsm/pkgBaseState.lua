BaseState = class()

function BaseState:ctor(stateName)
    self.fsm = nil
    self.stateName = stateName
end

function BaseState:OnEnter(...)
    print("BaseState:OnEnter()")
end

function BaseState:OnUpdate()
    print("BaseState:OnUpdate()")
end

function BaseState:OnLeave()
    print("BaseState:OnLeave()")
end