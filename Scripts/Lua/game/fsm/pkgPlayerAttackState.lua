PlayerAttackState = class(BaseState)

function PlayerAttackState:ctor(stateName)
end

function PlayerAttackState:OnEnter(...)
    --print("PlayerAttackState:OnEnter()")
    local tbParamters = {...}
    local currentAttackSkill = tbParamters[1]
    pkgSysSkill.Attack(self.fsm.owner, currentAttackSkill)
end

function PlayerAttackState:OnUpdate()
    if not self.fsm.owner.attackSkill then
        self.fsm:Switch(pkgStateDefination.State.STAY)
    end

    if self.fsm.owner.bComboCheck and self.fsm.owner.dComboClick > 0 then
        pkgSysSkill.Attack(self.fsm.owner, self.fsm.owner.attackSkill + 1)
        self.fsm.owner.bComboCheck = false
        self.fsm.owner.dComboClick = 0
    end

    if self.fsm.owner.bHurt then
        --LOG_DEBUG(self.fsm.owner:GetId() .. ", Attack --------> Hurt")
        self.fsm:Switch(pkgStateDefination.State.HURT)
        return
    end
end

function PlayerAttackState:OnLeave()
    --print("PlayerAttackState:OnLeave()")
    self.fsm.owner.attackSkill = nil
    pkgSysSkill.SetAttackSkill(self.fsm.owner, nil)
end