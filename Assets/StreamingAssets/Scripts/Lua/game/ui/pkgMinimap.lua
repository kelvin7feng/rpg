doNameSpace("pkgMinimap")

minimapUI = minimapUI or nil

function Init()
    local function onLoadComplete(prefab)
        minimapUI = UnityEngine.GameObject.Instantiate(prefab)
        pkgCanvasMgr.AddToCanvas(pkgCanvasDefination.CanvasName.MAIN_UI, minimapUI)

        local rectTransform = minimapUI:GetComponent(UnityEngine.RectTransform)
        rectTransform.offsetMin = UnityEngine.Vector2(0, 0);
        rectTransform.offsetMax = UnityEngine.Vector2(0, 0);
        rectTransform.localScale = UnityEngine.Vector3(1,1,1)

        local targetPlayer = pkgActorManager.GetMainPlayer()
        local objMinimap = minimapUI.transform:Find("MinimapCamera")
        local minimapFollow = objMinimap:GetComponent(KG.MinimapFollow)
        minimapFollow:SetTarget(targetPlayer.transform)
    end
    
    pkgAssetBundleMgr.LoadAssetBundle("ui", "Minimap", onLoadComplete)
end