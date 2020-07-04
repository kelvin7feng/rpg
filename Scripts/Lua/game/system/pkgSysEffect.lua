doNameSpace("pkgSysEffect")

le_dIndex = 0

local function GetIndex()
    le_dIndex = le_dIndex + 1
    return le_dIndex
end

local function DestoryEffect(effectNode)
    
    if not effectNode or not effectNode.obj then
        return
    end

    -- UI播放的特效,可能在关闭界面时销毁
    -- to do: 动态补全特效,或改成UI不使用缓存池
    if Slua.IsNull(effectNode.obj) then
        print("effect have been destoryed")
        return
    end

    local obj = effectNode.obj
    local particle = obj:GetComponent(UnityEngine.ParticleSystem)
    if particle then
        particle:Stop()
    end

    pkgPoolManager.ReturnToPool(effectNode.dEffectId, obj)
end

function PlayEffect(dEffectId, parentTransform, position, dDuration)
    local effectCfg = _cfg.effect[dEffectId]
    if not effectCfg then
        LOG_DEBUG("dEffectId is nil:" .. tostring(dEffectId))
        return nil
    end
    
    local obj = pkgPoolManager.GetFromPool(dEffectId)
    if not obj then
        print("pool is not water.")
        local prefab = pkgAssetBundleMgr.LoadAssetBundleSync(effectCfg.bundleName, effectCfg.assetName)
        if not prefab then
            return nil
        end
        obj = UnityEngine.GameObject.Instantiate(prefab, UnityEngine.Vector3(0,0,0), UnityEngine.Quaternion.identity)
    end

    if parentTransform then
        obj.transform:SetParent(parentTransform, false)
    end

    if position then
        obj.transform.position = position
    else
        local rectTransform = obj:GetComponent(UnityEngine.RectTransform)
        if not rectTransform then
            rectTransform = obj:AddComponent(UnityEngine.RectTransform)
        end
        rectTransform.offsetMin = UnityEngine.Vector2(0, 0);
        rectTransform.offsetMax = UnityEngine.Vector2(0, 0);
        rectTransform.localScale = UnityEngine.Vector3(1,1,1)
    end
    
    local dDuration = 0
    local bIsLoop = false
    local particleSystems = obj:GetComponentsInChildren(UnityEngine.ParticleSystem)
    for particleSystem in Slua.iter(particleSystems) do
        if particleSystem.main.duration > dDuration then
            dDuration = particleSystem.main.duration
        end
        if particleSystem.main.loop then
            bIsLoop = particleSystem.main.loop
        end
    end

    local effectNode = EffectNode:new({dEffectId = dEffectId, obj = obj, dIndex = GetIndex()})
    if not bIsLoop and dDuration > 0 then
        pkgTimer.AddOnceTimer("PlayEffect", dDuration + 0.1, 
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

function SetEffectActive(effectNode, bActive)
    if effectNode and effectNode.obj then
        effectNode.obj:SetActive(bActive)
    end
end