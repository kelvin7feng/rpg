doNameSpace("pkgUIToastMgr")

enStatus = {
    INIT = 0,
    PLAY = 1,
    FINISH = 2,
}

local dDistanceDelta = 5 --间距
local dFlySpeed = 10 --飞行时间
local dStartPercent = 0.6 --起始位置，屏幕百分比
local dEndPercent = 1
local dFadePercent = 0.8
local dMaxFlyCount = 5

le_canvasToast = le_canvasToast or nil
le_toastGo_line1 = le_toastGo_line1 or nil

le_textCpt = le_textCpt or nil

le_dTextHeight = le_dTextHeight or nil

le_tbToast = le_tbToast or {}

le_timer = le_timer or nil

le_dFlyCount = le_dFlyCount or 0

le_tbFlyToast = le_tbFlyToast or {} --队列

le_tbFlyingToast = le_tbFlyingToast or {} --已经在飞的

le_bCleaning = false

local function cleanFlyToast()
    if #le_tbToast == 0 then
        le_bCleaning = true
        local tbFlyToast = {}
        for _, v in ipairs(le_tbFlyToast) do
            if v.toast then
                table.insert(tbFlyToast, v)
            end
        end
        le_tbFlyToast = tbFlyToast
        le_bCleaning = false
    end
end

--获取下一个要飞行的toast
local function getNextToast()
    if le_bCleaning then
        return
    end
    if le_dFlyCount < dMaxFlyCount then
        if #le_tbToast > 0 then
            local tbToastData = table.remove(le_tbToast, 1)
            local dNum = #le_tbFlyToast
            if tbToastData then
                tbToastData.dIndex = dNum + 1
                table.insert(le_tbFlyToast, tbToastData)
            end
        end
    end
end

--过一段时间没有其他的，自己往上飞
local function addFlyTimer(tbData)
    if tbData.timer then
        pkgTimerMgr.delete(tbData.timer)
    end
    local rect = tbData.rect
    local toast = tbData.toast

    local timer = pkgTimerMgr.once(600,function() 
        tbData.bDel = true
        pkgTimerMgr.addWithoutDelay(10, function(dTimer)
            local posOld = rect.anchoredPosition
            local targetPos = UnityEngine.Vector2(posOld.x, pkgCanvasDefination.ReferenceResolutionHeight * dEndPercent)
            rect.anchoredPosition = UnityEngine.Vector2.MoveTowards(posOld, targetPos, dFlySpeed)
            tbData.flyDistance = tbData.flyDistance + dFlySpeed
            if rect.anchoredPosition.y >= targetPos.y * dFadePercent then --渐隐
                local oldAlpha = tbData.canvasGroup.alpha
                tbData.canvasGroup.alpha = oldAlpha - 0.05
            end
            if rect.anchoredPosition.y >= targetPos.y then
                if not pkgUITool.isNull(toast.gameObject) then
                    UnityEngine.GameObject.Destroy(toast.gameObject)
                end
                pkgTimerMgr.delete(dTimer)
                return
            end
        end)
    end)
    tbData.timer = timer
end

--原来队列的依次向上
local function allFlyingUp(dOffset)
    local tbDel = {}
    for dIndex, v in ipairs(le_tbFlyingToast) do
        if v.bDel then
            tbDel[dIndex] = true
        else
            local toast = v.toast
            local rect = v.rect
            local posOld = rect.anchoredPosition

            local dOffsetY = dOffset or v.sizeDeltaY+ dDistanceDelta
            local targetPos = UnityEngine.Vector2(posOld.x, posOld.y + dOffsetY)
            local EndPos = UnityEngine.Vector2(posOld.x, pkgCanvasDefination.ReferenceResolutionHeight * dEndPercent)
            addFlyTimer(v) --去掉原来的定时器，重新延迟

            rect.anchoredPosition = targetPos
            if rect.anchoredPosition.y >= EndPos.y then
                if not pkgUITool.isNull(toast.gameObject) then
                    tbDel[dIndex] = true
                end
            end
        end
    end

    for i = #le_tbFlyingToast, 1, -1 do
        if tbDel[i] then
            table.remove(le_tbFlyingToast, i)
        end
    end
end

local function doFlyAction2()
    local dCount = #le_tbToast
    for i=1, dCount do
        local tbData = table.remove(le_tbToast, 1)
        if tbData then
            tbData.toast.gameObject:SetActive(true)

            allFlyingUp(tbData.sizeDeltaY + dDistanceDelta)
            addFlyTimer(tbData)

            table.insert(le_tbFlyingToast, tbData)
            tbData.dIndexInFlying = #le_tbFlyingToast
        else
            return
        end
    end
end

--执行漂字
local function doFlyAction()
    if le_dFlyCount >= dMaxFlyCount then
        return
    end
    for dIndex, tbData in ipairs( le_tbFlyToast ) do
        local toast = tbData.toast
        if tbData.status == enStatus.INIT then
            local dIndexBefore
            dIndexBefore = dIndex - 1
            local tbDataBefore = le_tbFlyToast[dIndexBefore]
            local bCanFly = false
            if not tbDataBefore then
                bCanFly = true
            else
                if tbDataBefore.flyDistance >= tbDataBefore.sizeDeltaY + dDistanceDelta then --前一个飞行超过高度距离后，才执行当前toast
                    bCanFly = true
                end
            end
            if bCanFly then
                tbData.status = enStatus.PLAY
                le_dFlyCount = le_dFlyCount + 1
                toast.gameObject:SetActive(true)
                local rect = tbData.rect
                pkgTimerMgr.addWithoutDelay(10, function(dTimer)
                    local posOld = rect.anchoredPosition
                    local targetPos = UnityEngine.Vector2(posOld.x, pkgCanvasDefination.ReferenceResolutionHeight * dEndPercent)
                    rect.anchoredPosition = UnityEngine.Vector2.MoveTowards(posOld, targetPos, dFlySpeed)
                    tbData.flyDistance = tbData.flyDistance + dFlySpeed
                    if rect.anchoredPosition.y >= targetPos.y then
                        le_dFlyCount = le_dFlyCount - 1
                        UnityEngine.GameObject.Destroy(toast.gameObject)
                        tbData.toast = nil
                        pkgTimerMgr.delete(dTimer)
                        return
                    end
                end)
            end
        end
    end
end

function Init()
    local function onLoadCompelte(prefab)
        le_canvasToast = UnityEngine.GameObject.Instantiate(prefab)

        pkgCanvasMgr.InitCanvasDefaultAttr(le_canvasToast, pkgCanvasDefination.TOAST_ORDER, true, false)

        local rectTransform = le_canvasToast:GetComponent(UnityEngine.RectTransform)
        rectTransform.offsetMin = UnityEngine.Vector2(0, 0)
        rectTransform.offsetMax = UnityEngine.Vector2(0, 0)
        rectTransform.localScale = UnityEngine.Vector3(1,1,1)

        le_canvasToast.name = "canvasToast"
        le_toastGo_line1 = le_canvasToast.transform:Find("toast")

        UnityEngine.Object.DontDestroyOnLoad(le_canvasToast)
    end

    pkgAssetBundleMgr.LoadAssetBundle("ui", "Toast", onLoadCompelte)
end

local function getLineCount(msg)
    if not le_textCpt then
        local textGo = le_toastGo_line1.transform:Find("Text")
        le_textCpt = textGo.gameObject:GetComponent(UnityEngine.UI.Text)
        le_textCpt.text = ""
        le_dTextHeight = le_textCpt.preferredHeight
    end
    -- 求出单行文本的原始高度
    le_textCpt.text = msg
    local lineCount = math.ceil(le_textCpt.preferredHeight / le_dTextHeight)
    return lineCount
end

function toast(msg, fOpacity)
    if not le_canvasToast then
        return
    end

    local toastGo = le_toastGo_line1
    local toast = pkgUITool.CopyGameObject(toastGo)
    local rect = toast.gameObject:GetComponent(UnityEngine.RectTransform)
    pkgUITool.SetStringByName(toast, "Text", msg)
    if fOpacity then
        pkgUIImageMgr.setOpacity(toast, fOpacity)
    end

    local posOld = rect.anchoredPosition
    local sizeOld = rect.sizeDelta
    local canvasGroup = toast.gameObject:GetComponent(UnityEngine.CanvasGroup)

    rect.sizeDelta = UnityEngine.Vector2(sizeOld.x, sizeOld.y + (getLineCount(msg) - 1) * le_dTextHeight)
    rect.anchoredPosition = UnityEngine.Vector2(posOld.x, pkgCanvasDefination.ReferenceResolutionHeight * dStartPercent - rect.sizeDelta.y)

    local tbToastData = {toast = toast, status = enStatus.INIT, flyTime = 0, flyDistance = 0, rect = rect, sizeDeltaY = rect.sizeDelta.y, canvasGroup = canvasGroup}
    tbToastData.sizeDeltaY = rect.sizeDelta.y
    table.insert(le_tbToast, tbToastData)

    doFlyAction2()
end

_G.Toast = toast
