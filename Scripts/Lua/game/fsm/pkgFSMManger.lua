doNameSpace("pkgFSMManger")

m_tbFSM = {}

function InitPlayerFSM(player)
    local fsm = FSM:new(player)
    fsm:AddState(PlayerStayState:new(pkgStateDefination.State.STAY))
    fsm:AddState(PlayerMoveState:new(pkgStateDefination.State.MOVE))
    fsm:AddState(PlayerAttackState:new(pkgStateDefination.State.ATTACK))
    fsm:AddState(PlayerDieState:new(pkgStateDefination.State.DIE))
    fsm:AddState(pkgPlayerHurtState:new(pkgStateDefination.State.HURT))
    fsm:SetInitState(pkgStateDefination.State.STAY)
    player.fsm = fsm
    AddFSM(fsm)
end

function InitMonsterFSM(player)
    local fsm = FSM:new(player)
    fsm:AddState(PlayerStayState:new(pkgStateDefination.State.STAY))
    fsm:AddState(PlayerMoveState:new(pkgStateDefination.State.MOVE))
    fsm:AddState(PlayerAttackState:new(pkgStateDefination.State.ATTACK))
    fsm:AddState(PlayerDieState:new(pkgStateDefination.State.DIE))
    fsm:AddState(pkgPlayerHurtState:new(pkgStateDefination.State.HURT))
    fsm:SetInitState(pkgStateDefination.State.STAY)
    player.fsm = fsm
    AddFSM(fsm)
end

function AddFSM(fsm)
    m_tbFSM[fsm] = fsm
end

function RemoveFSM(fsm)
    if m_tbFSM[fsm] then
        m_tbFSM[fsm] = nil
    end
end

function UpdateFSM()
    for _,fsm in pairs(m_tbFSM) do
        fsm.curState:OnUpdate()
    end
end

function IsInState(player, stateName)
    
    if not stateName then
        return false
    end
    
    return player.fsm:IsInState(stateName)
end

function OnAnimationCallback(dPlayerId, parameter)
    local player = pkgActorManager.GetActor(dPlayerId)
    if not player then
        return false
    end

    if pkgSysSkill[parameter] then
        pkgSysSkill[parameter](player)
    end
end

function PrintCurrentState(player)
    print(player:GetId(), player.fsm:GetCurrentState())
end