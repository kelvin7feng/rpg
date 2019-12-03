PlayerStayState = class(BaseState)

function PlayerStayState:ctor(stateName)
    
end

function PlayerStayState:OnEnter()
    print(self.fsm.owner:GetId() .. ", PlayerStayState:OnEnter()")
    pkgSysPlayer.Stay(self.fsm.owner)
end

function PlayerStayState:OnUpdate()
    if self.fsm.owner.inputDestination then
        print(self.fsm.owner:GetId() .. ", Stay --------> Move")
        self.fsm:Switch(pkgStateDefination.State.MOVE, self.fsm.owner.inputDestination)
        return
    end

    if self.fsm.owner.attackSkill then
        print(self.fsm.owner:GetId() .. ", Stay --------> Attack")
        self.fsm:Switch(pkgStateDefination.State.ATTACK, self.fsm.owner.attackSkill)
        return
    end

    if self.fsm.owner.bDie then
        print(self.fsm.owner:GetId() .. ", Stay --------> Die")
        self.fsm:Switch(pkgStateDefination.State.DIE)
        return
    end

    if self.fsm.owner.bHurt then
        LOG_DEBUG(self.fsm.owner:GetId() .. ", Stay --------> Hurt")
        self.fsm:Switch(pkgStateDefination.State.HURT)
        return
    end
end

function PlayerStayState:OnLeave()
    print(self.fsm.owner:GetId() .. ", PlayerStayState:OnLeave()")
end