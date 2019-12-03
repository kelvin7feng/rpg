PlayerDieState = class(BaseState)

function PlayerDieState:ctor(stateName)
    
end

function PlayerDieState:OnEnter()
    print(self.fsm.owner:GetId() .. ", PlayerDieState:OnEnter()")
    pkgSysPlayer.Die(self.fsm.owner)
end

function PlayerDieState:OnUpdate()
    
end

function PlayerDieState:OnLeave()
    print(self.fsm.owner:GetId() .. ", PlayerDieState:OnLeave()")
end