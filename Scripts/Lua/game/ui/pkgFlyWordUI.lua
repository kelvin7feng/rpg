doNameSpace("pkgFlyWordUI")

flyWordUI = flyWordUI or nil

FlyWordType = {
    [1]             = "TxtNormal",
    NORMAL          = 1,
}

FuncAnimation = {
    [FlyWordType.NORMAL] = "PlayNormal",
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
    
    PlayAnimation(obj, dType)
end

function onPlayComplete(obj, param)
    pkgPoolManager.ReturnToPool(pkgPoolDefination.PoolType.FLY_WORD, obj)
end

function PlayNormal(obj)
    local dTotalTime = 0.8
    local dFadeOutDelay = 0.3
    iTween.ColorFrom(obj, iTween.Hash("a", 1))
    iTween.ColorTo(obj, iTween.Hash("a", 0, "delay", dFadeOutDelay, "time", math.max(0, dTotalTime - 0.3)))
    iTween.MoveTo(obj, iTween.Hash("time", dTotalTime, "y", obj.transform.position.y + 100, "easetype", "easeOutCirc",
                  "onluacomplete", pkgFlyWordUI.onPlayComplete))
end

function PlayAnimation(obj, dType)
    if not FuncAnimation[dType] then
        LOG_WARN("Fly word animation didn't register: " .. dType)
        return
    end
    
    pkgFlyWordUI[FuncAnimation[dType]](obj)    
end