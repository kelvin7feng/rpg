doNameSpace("pkgUIHpProgress")

assetbundleTag = "ui"
prefabFile = "HpProgressUI"
dSortOrder = 101
event_listener = {
    {pkgClientEventDefination.PLAYER_HP_CHANGE, "UpdateHp"},
    {pkgClientEventDefination.PLAYER_ADD_HP, "AddHp"},
}

m_tbPlayerHpProgress = {}

function init()
    
end

function show()
    m_tbPlayerHpProgress = {}
end

local function setPosition(player, obj)
    local localPosition = pkgPositionTool.GetPopupPos(player, gameObject)
    if localPosition then
        obj.transform.localPosition = localPosition
        local rectTransform = obj:GetComponent(UnityEngine.RectTransform)
        rectTransform.localScale = UnityEngine.Vector3(1, 1, 1)
    end
end

function AddHpProgress(player, dVal)
    
    if not player and not dVal then
        return
    end
          
    local obj = pkgPoolManager.GetFromPool(pkgPoolDefination.PoolType.HP_PROGRESS)

    if gameObject then
        pkgUITool.SetActive(obj, true)
        obj.transform:SetParent(gameObject.transform, false)
        obj.transform.localRotation = UnityEngine.Quaternion.identity
    end

    setPosition(player, obj)

    local objHpSlider = obj.transform:Find("Slider")
    local objCmptSlider = objHpSlider:GetComponent(UnityEngine.UI.Slider)
    objCmptSlider.value = pkgSysStat.GetRadioHealth(player)

    m_tbPlayerHpProgress[player] = {obj = obj, objCmptSlider = objCmptSlider, dMaxVal = dVal, dCurVal = dVal}
end

function UpdateHpPos()
    for player, tbHpProgress in pairs(m_tbPlayerHpProgress) do
        if tbHpProgress.dCurVal > 0 then
            setPosition(player, tbHpProgress.obj)
        end
    end
end

function UpdateHp(player, dVal)
    local tbHpProgress = m_tbPlayerHpProgress[player]
    if not tbHpProgress then
        return
    end

    tbHpProgress.dCurVal = math.max(tbHpProgress.dCurVal - dVal, 0)
    tbHpProgress.objCmptSlider.value = tbHpProgress.dCurVal/tbHpProgress.dMaxVal

    -- 主角血条不销毁
    if tbHpProgress.dCurVal <= 0
        and not pkgActorManager.IsMainPlayer(player) then
        pkgPoolManager.ReturnToPool(pkgPoolDefination.PoolType.HP_PROGRESS, tbHpProgress.obj)
        m_tbPlayerHpProgress[player] = nil
    end
end

function AddHp(player, dVal)
    local tbHpProgress = m_tbPlayerHpProgress[player]
    if not tbHpProgress then
        return
    end

    tbHpProgress.dCurVal = math.min(tbHpProgress.dCurVal + dVal, tbHpProgress.dMaxVal)
    tbHpProgress.objCmptSlider.value = tbHpProgress.dCurVal/tbHpProgress.dMaxVal
end

function RemoveHpProgress(player)
    local tbHpProgress = m_tbPlayerHpProgress[player]
    if not tbHpProgress then
        return
    end

    -- 主角血条不销毁
    if not pkgActorManager.IsMainPlayer(player) then
        pkgPoolManager.ReturnToPool(pkgPoolDefination.PoolType.HP_PROGRESS, tbHpProgress.obj)
        m_tbPlayerHpProgress[player] = nil
    end
end