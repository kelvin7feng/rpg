PlayerDieState = class(BaseState)

function PlayerDieState:ctor(stateName)
    
end

function PlayerDieState:OnEnter()
    LOG_DEBUG(self.fsm.owner:GetId() .. ", PlayerDieState:OnEnter()")
    pkgSysPlayer.Die(self.fsm.owner)
end

function PlayerDieState:OnUpdate()
    if not self.fsm.owner.bDie then
        LOG_DEBUG(self.fsm.owner:GetId() .. ", Die --------> stay")
        self.fsm:Switch(pkgStateDefination.State.STAY)
        return
    end
end

function PlayerDieState:OnLeave()
    LOG_DEBUG(self.fsm.owner:GetId() .. ", PlayerDieState:OnLeave()")
end