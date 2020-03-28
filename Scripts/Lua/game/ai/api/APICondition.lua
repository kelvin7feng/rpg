doNameSpace("APICondition")

function IsPause(agent)
    return agent.aiData.bIsPause
end

function IsIdle(agent)
    return true
end

function IsRandomMovement(agent)
    return math.random(1,100) > 50 and true or false
end

function EndMove(agent)
    if pkgStateDefination.State.MOVE == agent.fsm:GetCurrentState() then
        return false
    end

    return true
end

function IsHurt(agent)
    return agent.aiData.bIsHurt
end

function IsDead(agent)
    return agent.stat:GetHp() <= 0
end

function CanInterrupt(agent)
    if IsDead(agent)
        --or IsHurt(agent)
        or agent.aiData.bInterruptByHate then
        return true
    end

    return false
end

function IsInFOV(agent)
    return agent.aiData:GetHateListCount() > 0 and true or false
end

function IsGreatThanDistanceOfAttack(agent)
    local targetEnemy = agent.aiData:GetTargetEnemy()
    if not targetEnemy then
        return false
    end

    local dAttackDistance = agent.aiData:GetFieldConfig(pkgConfigFieldDefination.Monster.DISTANCE_OF_ATTACK)
    local dTempDistance = UnityEngine.Vector3.Distance(pkgSysPosition.GetCurrentPos(agent), pkgSysPosition.GetCurrentPos(targetEnemy))
    if dTempDistance > dAttackDistance then
        return true
    end

    return false
end

function IsSkillEnd(agent)
    return pkgFSMManger.IsInState(agent, pkgStateDefination.State.ATTACK)
end
