doNameSpace("pkgPopupTextUI")

assetbundleTag = "ui"
prefabFile = "PopupTextUI"
dSortOrder = 101

PopupType = {
    [1]             = "TxtNormal",
    [2]             = "TxtCritical",
    [3]             = "TxtMiss",
    NORMAL          = 1,
    CRITICAL        = 2,
    MISS            = 3,
}

FuncAnimation = {
    [PopupType.NORMAL] = "PlayNormal",
    [PopupType.CRITICAL] = "PlayCritical",
    [PopupType.MISS] = "PlayMiss",
}

function init()
    
end

function show()

end

local function setRotation(player, obj)
    local txtValueObj = obj.transform:Find("TxtNormal/Text").gameObject
    local txtCriticalObj = obj.transform:Find("TxtCritical/Text").gameObject
    local txtMissObj = obj.transform:Find("TxtMiss/Text").gameObject
    
    local rectTransform = obj:GetComponent(UnityEngine.RectTransform)
	if pkgActorManager.IsMainPlayer(player) then
		rectTransform.localScale = UnityEngine.Vector3(1, 1, 1)
		txtValueObj.transform.localRotation = UnityEngine.Quaternion.Euler(0, 0, 0)
		txtCriticalObj.transform.localRotation = UnityEngine.Quaternion.Euler(0, 0, 0)
		txtMissObj.transform.localRotation = UnityEngine.Quaternion.Euler(0, 0, 0)
	else
		rectTransform.localScale = UnityEngine.Vector3(-1, 1, 1)
		txtValueObj.transform.localRotation = UnityEngine.Quaternion.Euler(0, 180, 0)
		txtCriticalObj.transform.localRotation = UnityEngine.Quaternion.Euler(0, 180, 0)
		txtMissObj.transform.localRotation = UnityEngine.Quaternion.Euler(0, 180, 0)
    end
end

local function setPosition(player, obj)
    local localPosition = pkgPositionTool.GetPopupPos(player, gameObject)
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
    
    PlayAnimation(obj, dType, dVal)
end

function onPlayComplete(obj, param)
    pkgUITool.SetActiveByName(obj, PopupType[1], false)
    pkgUITool.SetActiveByName(obj, PopupType[2], false)
    pkgUITool.SetActiveByName(obj, PopupType[3], false)
    pkgPoolManager.ReturnToPool(pkgPoolDefination.PoolType.POP_UP_TEXT, obj)
end

function PlayNormal(obj, dType, dVal)
    pkgUITool.SetActiveByName(obj, PopupType[dType], true)
    pkgUITool.SetStringByName(obj, PopupType[dType] .. "/Text", tostring(dVal))
end

function PlayCritical(obj, dType, dVal)
    pkgUITool.SetActiveByName(obj, PopupType[dType], true)
end

function PlayMiss(obj, dType, dVal)
    pkgUITool.SetActiveByName(obj, PopupType[dType], true)
end

function PlayAnimation(obj, dType, dVal)
    if not FuncAnimation[dType] then
        LOG_WARN("Fly word animation didn't register: " .. dType)
        return
    end
    
    pkgPopupTextUI[FuncAnimation[dType]](obj, dType, dVal)
    
    pkgTimerMgr.once(2000, function()
        pkgPopupTextUI.onPlayComplete(obj)
    end)
end