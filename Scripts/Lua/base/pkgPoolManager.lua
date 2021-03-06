doNameSpace("pkgPoolManager")

m_bHaveInited = m_bHaveInited or false
m_tbPool = m_tbPool or {}

function Init()

    if bHaveInited then
        LOG_DEBUG("pool manager have initialed......")
        return
    end
    bHaveInited = true
    
    if #pkgPoolDefination.CachePool > 0 then
        for key, tbPoolInfo in pairs(pkgPoolDefination.CachePool) do
            PreInstantiate(key, tbPoolInfo)
        end
    end
end

function PreInstantiate(key, tbPoolInfo)
    for i = 1, tbPoolInfo.dCount do
        local objPoolManager = pkgGlobalGoMgr.GetPoolManager()
        local function onLoadComplete(prefab)
            local obj = UnityEngine.GameObject.Instantiate(prefab, UnityEngine.Vector3(0,0,0), UnityEngine.Quaternion.identity)
            obj.transform:SetParent(objPoolManager.transform, false)
            obj.name = string.format("%s_%d", tbPoolInfo.strAssetName, i)
            Push(key, obj)
        end
        pkgAssetBundleMgr.LoadAssetBundle(tbPoolInfo.strAssetBundleName, tbPoolInfo.strAssetName, onLoadComplete)
    end

end

function Push(key, obj)
    if not m_tbPool[key] then
        m_tbPool[key] = {}
    end

    local objPoolManager = pkgGlobalGoMgr.GetPoolManager()
    obj.transform:SetParent(objPoolManager.transform)

    obj:SetActive(false)
    table.insert(m_tbPool[key], obj)
end

function Pop(key)
    if not m_tbPool[key] then
        return nil
    end

    if #m_tbPool[key] <= 0 then
        return nil
    end
    
    local obj = table.remove(m_tbPool[key], 1)
    obj:SetActive(true)

    return obj
end

function GetFromPool(key)
    return Pop(key)
end

function ReturnToPool(key, obj)
    return Push(key, obj)
end