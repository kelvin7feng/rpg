doNameSpace("pkgPopupTextUI")

assetbundleTag = "ui"
prefabFile = "PopupTextUI"
dSortOrder = 101

PopupType = {
    [1]             = "TxtNormal",
    NORMAL          = 1,
}

FuncAnimation = {
    [PopupType.NORMAL] = "PlayNormal",
}

function init()
    
end

function show()

end

function getPopupPos(player)
    local position = pkgSysPosition.GetTopHeaderPos(player)
    local camera = UnityEngine.Camera.main
    local positionOnScreen = camera:WorldToScreenPoint(position)
    local _, localPosition = UnityEngine.RectTransformUtility.ScreenPointToLocalPointInRectangle(
            Slua.As(gameObject.transform, 
            UnityEngine.RectTransform), 
            positionOnScreen, 
            pkgCanvasMgr.GetUICamera(), 
            Slua.out)
    localPosition.y = localPosition.y + 30

    return localPosition
end

local function setRotation(player, obj)
    local txtValueObj = obj.transform:Find("TxtNormal").gameObject
	local txtValue = txtValueObj:GetComponent(UnityEngine.UI.Text)

    local rectTransform = obj:GetComponent(UnityEngine.RectTransform)
	if pkgActorManager.IsMainPlayer(player) then
		rectTransform.localScale = UnityEngine.Vector3(1, 1, 1)
		txtValueObj.transform.localRotation = UnityEngine.Quaternion.Euler(0, 0, 0)
	else
		rectTransform.localScale = UnityEngine.Vector3(-1, 1, 1)
		txtValueObj.transform.localRotation = UnityEngine.Quaternion.Euler(0, 180, 0)
	end
end

local function setPosition(player, obj)
    local localPosition = getPopupPos(player)
    if localPosition then
        obj.transform.localPosition = localPosition
    end
end

function PlayPopupText(player, dType, dVal)
    
    if not player and not dType and not dVal then
        return
    end
          
    local obj = pkgPoolManager.GetFromPool(pkgPoolDefination.PoolType.POP_UP_TEXT)
    if gameObject then
        obj.transform:SetParent(gameObject.transform, false)
        obj.transform.localRotation = UnityEngine.Quaternion.identity
    end

    setRotation(player, obj)
    setPosition(player, obj)
    
    pkgUITool.SetActiveByName(obj, PopupType[dType], true)
    pkgUITool.SetStringByName(obj, PopupType[dType], tostring(dVal))
    
    PlayAnimation(obj, dType)
end

function onPlayComplete(obj, param)
    pkgPoolManager.ReturnToPool(pkgPoolDefination.PoolType.POP_UP_TEXT, obj)
end

function PlayNormal(obj)
    local dTotalTime = 1
    local dFadeOutDelay = 0.3
    iTween.ColorFrom(obj, iTween.Hash("a", 1))
    iTween.ColorTo(obj, iTween.Hash("a", 1, "delay", dFadeOutDelay, "time", math.max(0, dTotalTime - 0.3), "onluacomplete", pkgPopupTextUI.onPlayComplete))
end

function PlayAnimation(obj, dType)
    if not FuncAnimation[dType] then
        LOG_WARN("Fly word animation didn't register: " .. dType)
        return
    end
    
    pkgPopupTextUI[FuncAnimation[dType]](obj)    
end