doNameSpace("pkgUIImageMgr")

function SetGray(gameObject, bool)
    local imgCmpt = gameObject:GetComponent(UnityEngine.UI.Image)
    if not imgCmpt then
        return
    end
    
    local function onLoadComplete(prefab)
        imgCmpt.material = prefab
    end

    if bool then
        pkgAssetBundleMgr.LoadAssetBundle("mat_xs_ui_grey", "XS-UI-Grey", onLoadComplete)
    else
        pkgAssetBundleMgr.LoadAssetBundle("mat_xs_ui_default", "XS-UI-Default", onLoadComplete)
    end
end

function SetGrayRecursive(gameObject, bool)
    SetGray( gameObject, bool )
    for transform in Slua.iter( gameObject.transform ) do
        SetGrayRecursive( transform.gameObject, bool )
    end
end