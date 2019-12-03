doNameSpace("pkgAssetBundleMgr")

State = {
    LOADING       = 1,
    LOADED        = 2,
}

assetVariant = ".unity3d"
m_tbAssetBundleState = {}
m_tbAssetBundleWaiting = {}

function LoadAssetBundle(strAssetBundleName, strAssetName, funcCallBack)
    if not strAssetBundleName then
        print("LoadAssetBundle strAssetBundleName is nil")
        return
    end

    if not strAssetName then
        print("LoadAssetBundle strAssetName is nil")
        return
    end

    if not funcCallBack then
        print("LoadAssetBundle funcCallBack is nil")
        return
    end

    local strABNameWithVariant = string.format("%s%s",strAssetBundleName, assetVariant)
    if pkgApplicationTool.IsOnMobile() then
        local tbABState = m_tbAssetBundleState[strABNameWithVariant]
        if not tbABState then
            m_tbAssetBundleState[strABNameWithVariant] = State.LOADING
        else
            if tbABState == State.LOADING then
                if not m_tbAssetBundleWaiting[strABNameWithVariant] then
                    m_tbAssetBundleWaiting[strABNameWithVariant] = {}
                end
                table.insert(m_tbAssetBundleWaiting[strABNameWithVariant], {strAssetBundleName, strAssetName, funcCallBack})
                return
            end
        end
    
        local function onLoadedCallBack(go)
            funcCallBack(go)
            if m_tbAssetBundleState[strABNameWithVariant] ~= State.LOADED then
                m_tbAssetBundleState[strABNameWithVariant] = State.LOADED
            end
            if m_tbAssetBundleWaiting[strABNameWithVariant] then
                for i=#m_tbAssetBundleWaiting[strABNameWithVariant],1,-1 do
                    pkgAssetBundleMgr.LoadAssetBundle(unpack(m_tbAssetBundleWaiting[strABNameWithVariant][i]))
                    table.remove(m_tbAssetBundleWaiting[strABNameWithVariant], i)
                end
                m_tbAssetBundleWaiting[strABNameWithVariant] = nil
            end
        end
        KG.AssetBundleUtils.Instance:LoadAssetAsync(strABNameWithVariant, strAssetName, onLoadedCallBack)
    else
        local asset = KG.AssetLoader.LoadAssetAsync(strABNameWithVariant, strAssetName)
            LuaTimer.Add(30, function(id)
                LuaTimer.Delete(id)
                if asset then
                    funcCallBack(asset)
                end
        end)
    end
end

function LoadAssetBundleSync(strAssetBundleName, funcCallBack)
    if not strAssetBundleName then
        print("LoadAssetBundle strAssetBundleName is nil")
        return
    end

    KG.AssetBundleUtils.Instance:LoadAssetSync(string.format("%s%s",strAssetBundleName, assetVariant), funcCallBack)
end