doNameSpace("APIAction")

function ResetInterrupt(agent)
    if agent.aiData.bInterruptByHate then
        agent.aiData.bInterruptByHate = false
    end
end

function ResetHurt(agent)
    if agent.aiData.bIsHurt then
        agent.aiData.bIsHurt = false
    end
end

function MoveForward(agent)
    local pos = pkgSysMonster.GetForwardPos(agent, 5)
    pkgSysPlayer.SetMoveSpeed(agent, agent.aiData:GetFieldConfig(pkgConfigFieldDefination.Monster.SPEED_OF_RUN))
    pkgSysPlayer.SetDestination(agent, pos)

    pkgSysPlayer.SetAnimationMoveSpeed(agent, 0.8)

    return true
end

function MoveRandomly(agent)
    local pos = pkgSysMonster.GetRandomMovePos(agent)
    pkgSysPlayer.SetMoveSpeed(agent, agent.aiData:GetFieldConfig(pkgConfigFieldDefination.Monster.SPEED_OF_WALK))
    pkgSysPlayer.SetDestination(agent, pos)

    pkgSysPlayer.SetAnimationMoveSpeed(agent, 0.3)

    return true
end

function ChaseTarget(agent)
    
    local targetEnemy = agent.aiData:GetTargetEnemy()
    if not targetEnemy then
        return false
    end
    
    pkgSysPlayer.SetMoveSpeed(agent, agent.aiData:GetFieldConfig(pkgConfigFieldDefination.Monster.SPEED_OF_RUN))
    pkgSysPlayer.SetDestination(agent, pkgSysPosition.GetCurrentPos(targetEnemy))

    local dAttackDistance = agent.aiData:GetFieldConfig(pkgConfigFieldDefination.Monster.DISTANCE_OF_ATTACK)
    if dAttackDistance < 0.5 then
        dAttackDistance = 1
    end

    pkgSysPlayer.SetAnimationMoveSpeed(agent, 0.8)
    pkgSysPlayer.SetStoppingDistance(agent, dAttackDistance + 0.1)

    return true
end

function OnChaseTargetStop(agent)
    pkgSysPlayer.SetStoppingDistance(agent, 0)
end

function UpdateMoveDestination(agent)
    local targetEnemy = agent.aiData:GetTargetEnemy()
    if not targetEnemy then
        return false
    end

    pkgSysPlayer.SetDestination(agent, pkgSysPosition.GetCurrentPos(targetEnemy))
end

function Attack(agent)

    local targetEnemy = agent.aiData:GetTargetEnemy()
    if not targetEnemy then
        return false
    end

    if pkgFSMManger.IsInState(agent, pkgStateDefination.State.ATTACK) then
        return false
    end

    pkgSysPosition.FaceToDir(agent, pkgSysPosition.GetCurrentPos(targetEnemy), false)
    pkgSysSkill.SetAttackSkill(agent, 0)

    return true
end

function GetHit(agent)
    return true
end
