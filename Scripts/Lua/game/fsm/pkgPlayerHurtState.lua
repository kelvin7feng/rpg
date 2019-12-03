pkgPlayerHurtState = class(BaseState)

function pkgPlayerHurtState:ctor(stateName)
    
end

function pkgPlayerHurtState:OnEnter()
    LOG_DEBUG(self.fsm.owner:GetId() .. ", pkgPlayerHurtState:OnEnter()")
    pkgSysPlayer.GetHurt(self.fsm.owner)
end

function pkgPlayerHurtState:OnUpdate()
    if not self.fsm.owner.bHurt then
        LOG_DEBUG(self.fsm.owner:GetId() .. ", Hurt --------> Stay")
        self.fsm:Switch(pkgStateDefination.State.STAY)
        return
    end
end

function pkgPlayerHurtState:OnLeave()
    LOG_DEBUG(self.fsm.owner:GetId() .. ", pkgPlayerHurtState:OnLeave()")
end