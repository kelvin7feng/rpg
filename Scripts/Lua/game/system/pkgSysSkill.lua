doNameSpace("pkgSysSkill")

function Attack(player, attackSkill)
    local animator = player.animator
    if animator then
        pkgAnimatorMgr.SetTrigger(animator, pkgAnimatorDefination.AnimatorParamter.ATTACK_ONCE)
        pkgAnimatorMgr.SetInteger(animator, pkgAnimatorDefination.AnimatorParamter.ATTACK_TYPE, attackSkill)
        pkgAnimatorMgr.SetInteger(animator, pkgAnimatorDefination.AnimatorParamter.ANIMATION_TYPE, pkgAnimatorDefination.AnimationType.ATTACK)
    end    
end

function SetComboCheck(player, bCheck)
    player.bComboCheck = bCheck
end

function SetComboClick(player, dComboClick)
    player.dComboClick = dComboClick
end

function CanCombo(player)
    return player.bComboCheck
end

function SetAttackSkill(player, attackSkill)

    -- 技能结束了,并且还在攻击状态,就不处理了,等待状态切换
    if not player.attackSkill and pkgFSMManger.IsInState(player, pkgStateDefination.State.ATTACK) then
        return
    end
    
    player.attackSkill = attackSkill

    if not attackSkill then
        pkgAnimatorMgr.SetInteger(player.animator, pkgAnimatorDefination.AnimatorParamter.ATTACK_TYPE, 0)
    end

    if pkgFSMManger.IsInState(player, pkgStateDefination.State.ATTACK) 
        and CanCombo(player) then
        SetComboClick(player, player.dComboClick + 1)
    end
end

function ComboCheck(player)
    if pkgFSMManger.IsInState(player, pkgStateDefination.State.ATTACK) then
        pkgSysSkill.SetComboCheck(player, true)
    end
end

function AttackBegin(player)
    local playerPos = pkgSysPosition.GetCurrentPos(player)
    local tbEnemy = pkgActorManager.GetAllEnemy(player)
    if #tbEnemy > 0 then
        for _, objEnemy in ipairs(tbEnemy) do
            local targetPos = pkgSysPosition.GetCurrentPos(objEnemy)
            local dir = targetPos - playerPos
            if UnityEngine.Vector3.Angle(dir, player.transform.forward) < 70 then
                if UnityEngine.Vector3.Distance(targetPos, playerPos) < 3 then
                    LOG_DEBUG("I hit you now!")
                    pkgSysStat.DoDamage(objEnemy, player, math.random(3,5))
                end
            end
        end
    else
        LOG_DEBUG("there are not enemy")
    end
end

function AttackEnd(player)
    SetComboCheck(player, false)
    SetComboClick(player, 0)
    SetAttackSkill(player, nil)
end

function HurtEnd(player)
    player:SetHurt(false)
end