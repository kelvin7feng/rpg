doNameSpace("pkgSysEffect")

local function DestoryEffect(effectNode)

    if not effectNode or not effectNode.obj then
        return
    end

    local obj = effectNode.obj
    local particle = obj.gameObject:GetComponent(UnityEngine.ParticleSystem)
    if particle then
        particle:Stop()
    end

    pkgPoolManager.ReturnToPool(pkgPoolDefination.PoolType.SWORD_HIT_EFFECT, obj)
end

function PlayEffect(dEffectId, parentTransform, position, dDuration)
    
    local effectCfg = _cfg.effect[dEffectId]
    if not effectCfg then
        LOG_DEBUG("dEffectId is nil:" .. tostring(dEffectId))
        return nil
    end

    local bIsLoop = false
    local dDuration = dDuration or effectCfg[pkgEffectDefination.ConfigField.DURATION]
    if dDuration and dDuration ~= 0 then
        bIsLoop = true
    end
    
    local obj = pkgPoolManager.GetFromPool(pkgPoolDefination.PoolType.SWORD_HIT_EFFECT)
    if parentTransform then
        obj.transform:SetParent(parentTransform)
    end
    if position then
        obj.transform.position = position
    end
    
    local effectNode = EffectNode:new({dEffectId = dEffectId, obj = obj})
    if bIsLoop and dDuration > 0 then
        pkgTimer.AddOnceTimer("PlayEffect", dDuration/1000, 
        function()
            DestoryEffect(effectNode)
        end)
    end

    return effectNode
end

function StopPlay(effectNode)
    DestoryEffect(effectNode)
end

function PlayWeaponEffect(objWeapon)
    local objHitEffect = objWeapon.transform:Find("HitEffectPos")
    if not objHitEffect then
        return false
    end

    PlayEffect(1, nil, objHitEffect.transform.position)
end