doNameSpace("pkgFlyWordUI")

flyWordUI = flyWordUI or nil

FlyWordType = {
    [1]             = "TxtNormal",
    NORMAL          = 1,
}

function Init()
    local function onLoadComplete(prefab)
        flyWordUI = UnityEngine.GameObject.Instantiate(prefab)
        pkgCanvasMgr.AddToCanvas(pkgCanvasDefination.CanvasName.FLY_WORD_UI, flyWordUI)

        local rectTransform = flyWordUI:GetComponent(UnityEngine.RectTransform)
        rectTransform.offsetMin = UnityEngine.Vector2(0, 0);
        rectTransform.offsetMax = UnityEngine.Vector2(0, 0);
        rectTransform.localScale = UnityEngine.Vector3(1,1,1)
    end
    
    pkgAssetBundleMgr.LoadAssetBundle("ui", "FlyWordUI", onLoadComplete)
end

function PlayFlyWord(player, dType, dVal)
    if not player and not dType and not dVal then
        return
    end

    local position = pkgSysPosition.GetTopHeaderPos(player)
    local camera = UnityEngine.Camera.main
    local positionOnScreen = camera:WorldToScreenPoint(position)

    local obj = pkgPoolManager.GetFromPool(pkgPoolDefination.PoolType.FLY_WORD)
    if flyWordUI then
        obj.transform:SetParent(flyWordUI.transform)
    end
    if position then
        obj.transform.position = positionOnScreen
    end

    pkgUITool.SetActiveByName(obj, FlyWordType[dType], true)
    pkgUITool.SetStringByName(obj, FlyWordType[dType], tostring(dVal))
    
    pkgTimer.AddOnceTimer("PlayFlyWord", 0.5, 
        function()
            pkgPoolManager.ReturnToPool(pkgPoolDefination.PoolType.FLY_WORD, obj)
        end)
end