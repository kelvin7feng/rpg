doNameSpace("pkgSysStat")

function GetRadioHealth(player)
    return GetCurrentHealth(player)/GetMaxHealth(player)
end

function GetCurrentHealth(player)
    return player.stat.dCurrentHealth
end

function GetMaxHealth(player)
    return player.stat.maxHealth:GetValue()
end

function SetMaxHealth(player, dMaxHealth)
    player.stat.maxHealth = Stat:new(dMaxHealth)
    player.stat.dCurrentHealth = player.stat.maxHealth:GetValue()

    -- print("player.stat.dCurrentHealth ========== ", player.stat.dCurrentHealth)
end

function DoDamage(player, attacker)

    if pkgGlobalConfig.GodMode and pkgActorManager.IsMainPlayer(player) then
        return
    end
    
    local bHit, dDamage, bIsCritical, dCritical = pkgAttrLogic.CalcOneAttack(attacker.tbAttr, player.tbAttr)

    -- 优化: 连续受击的情况需要处理
    if not pkgFSMManger.IsInState(player, pkgStateDefination.State.HURT) then
        -- player:SetHurt(true)
    end
    
    pkgSysAI.AddAttackerToHateList(player, attacker)
    if bHit then
        player.stat:TakeDamage(dDamage)

        pkgPopupTextUI.PlayPopupText(player, pkgPopupTextUI.PopupType.NORMAL, dDamage)

        if bIsCritical then
            pkgPopupTextUI.PlayPopupText(player, pkgPopupTextUI.PopupType.CRITICAL)
        end

        pkgEventManager.PostEvent(pkgClientEventDefination.PLAYER_HP_CHANGE, player, dDamage)
    else
        pkgPopupTextUI.PlayPopupText(player, pkgPopupTextUI.PopupType.MISS)
    end
end