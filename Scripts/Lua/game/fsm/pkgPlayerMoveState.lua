PlayerMoveState = class(BaseState)

function PlayerMoveState:ctor(stateName)
    self.m_destination = nil
end

function PlayerMoveState:OnEnter(...)
    local tbParamters = {...}
    self.m_destination = tbParamters[1]
    LOG_DEBUG(self.fsm.owner:GetId() .. ", PlayerMoveState:OnEnter()")
end

function PlayerMoveState:OnUpdate()

    if self.fsm.owner.inputDestination then
        pkgSysPlayer.MoveToDestination(self.fsm.owner, self.fsm.owner.inputDestination)
    else
        pkgSysPlayer.Stop(self.fsm.owner)
        self.fsm:Switch(pkgStateDefination.State.STAY)
        return
    end
    
    if self.fsm.owner.attackSkill then
        LOG_DEBUG("Move --------> Attack")
        pkgSysPlayer.Stop(self.fsm.owner)
        self.fsm:Switch(pkgStateDefination.State.ATTACK, self.fsm.owner.attackSkill)
        return
    end

    if self.fsm.owner.bDie then
        LOG_DEBUG(self.fsm.owner:GetId() .. ", Move --------> Die")
        pkgSysPlayer.Stop(self.fsm.owner)
        self.fsm:Switch(pkgStateDefination.State.DIE)
        return
    end

    if self.fsm.owner.bHurt then
        LOG_DEBUG(self.fsm.owner:GetId() .. ", Move --------> Hurt")
        pkgSysPlayer.Stop(self.fsm.owner)
        self.fsm:Switch(pkgStateDefination.State.HURT)
        return
    end
end

function PlayerMoveState:OnLeave()
    LOG_DEBUG(self.fsm.owner:GetId() .. ", PlayerMoveState:OnLeave()")
    self.fsm.owner.inputDestination = nil
end