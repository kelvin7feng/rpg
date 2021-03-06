doNameSpace("pkgUIAchievement")

assetbundleTag = "ui"
prefabFile = "Achievement"

event_listener = 
{
    -- {pkgClientEventDefination.UPDATE_ACHIEVEMENT, "updateAchievementPanel"},
    {pkgClientEventDefination.ONE_ACHIEVEMENT_CHANGED, "updateOneAchievement"},
    {pkgClientEventDefination.UPDATE_LEVEL, "updateAchievementPanel"},
}

le_panelAchievementScrollView = le_panelAchievementScrollView or nil

function init()
    local goParent = gameObject.transform:Find("Panel")
    le_panelAchievementScrollView = goParent.transform:Find("AchievementPanel/ScrollView/Viewport/Content")
end

function show()
    updateAchievementPanel()
end

function updateOneAchievement(dType)

    local tbAchievementInfo = pkgAchievementMgr.getAchievementByType(dType)
    if not tbAchievementInfo then
        return 
    end
    
    updateAchievement(tbAchievementInfo)
end

function updateAchievement(tbAchievementInfo)
    local name = "achievementCell"..tbAchievementInfo.dType
    local goNow = le_panelAchievementScrollView.transform:Find(name)
    if pkgUITool.isNull(goNow) then
        goNow = UnityEngine.Object.Instantiate(prefab)
        goNow.name = name
        goNow.transform:SetParent(le_panelAchievementScrollView.transform, false)
        goNow.transform.localScale = UnityEngine.Vector3.one
    end
    local dId = tbAchievementInfo.dId
    if dId <= 0 then
        goNow.gameObject:SetActive(false)
        return
    end
    goNow.gameObject:SetActive(true)

    local tbCfg = pkgAchievementCfgMgr.getAchievementCfg(dId)
    pkgUITool.SetStringByName(goNow, "desc", pkgAchievementCfgMgr.getDesc(dId))
    pkgUITool.SetStringByName(goNow, "processSlider/Text", string.format("%d/%d", tbAchievementInfo.dProcess, tbCfg.target))

    local slider = goNow.transform:Find("processSlider")
    local sliderComponent = slider:GetComponent(UnityEngine.UI.Slider)
    local dProcessVal = math.min(tbAchievementInfo.dProcess/tbCfg.target, 1)
    sliderComponent.value = dProcessVal

    if dProcessVal >= 1 then
        pkgUITool.SetActiveByName(goNow, "btnGo", false)
        pkgUITool.SetActiveByName(goNow, "btnProcessing", false)
        pkgUITool.SetActiveByName(goNow, "btnReward", true)
        pkgButtonMgr.AddListener(goNow, "btnReward", function ( ... )
            pkgAchievementMgr.getReward(tbCfg.id)
        end)
    else
        pkgUITool.SetActiveByName(goNow, "btnReward", false)
        if tbCfg.redirect > 0 then
            pkgUITool.SetActiveByName(goNow, "btnGo", true)
            pkgUITool.SetActiveByName(goNow, "btnProcessing", false)
            pkgButtonMgr.AddListener(goNow, "btnGo", function ( ... )
                pkgRedirectMgr.redirectPage(tbCfg.redirect, pkgUIAchievement)
            end)
        else
            pkgUITool.SetActiveByName(goNow, "btnGo", false)
            pkgUITool.SetActiveByName(goNow, "btnProcessing", true)
        end
    end
    
    local panelReward = goNow.transform:Find("reward")
    panelReward.gameObject:SetActive(true)

    local tbReward = pkgAchievementCfgMgr.getRewardCfg(tbCfg.id)
    
    for i, tbGoods in ipairs(tbReward) do
        local dGoodsId, dCfgCount = unpack(tbGoods)
        if dGoodsId > 0 and dCfgCount > 0 then
            local strIconName = "goods".. i
            local goIcon = panelReward.transform:Find(strIconName)
            local tbArgs = {iconName = strIconName, count = dCfgCount, size = pkgUITool.ICON_SIZE_TYPE.MINI}
            if pkgUITool.isNull(goIcon) then
                pkgUITool.CreateIcon(dGoodsId, panelReward, nil, tbArgs)
            else
                pkgUITool.UpdateIcon(goIcon, dGoodsId, nil, tbArgs)
            end
        end
    end
end

function updateAchievementPanel()
    
    resetScrollViewItems()

    local tbAchievement = pkgAchievementMgr.getAchievement()
    if not tbAchievement or #tbAchievement <= 0 then
        return false
    end

    local function onLoadCompleted(prefab)
        local tbCfg = nil
        local dId = nil
        for i, tbAchievementInfo in ipairs(tbAchievement) do
            local name = "achievementCell"..tbAchievementInfo.dType
            local goNow = le_panelAchievementScrollView.transform:Find(name)
            if pkgUITool.isNull(goNow) then
                goNow = UnityEngine.Object.Instantiate(prefab)
                goNow.name = name
                goNow.transform:SetParent(le_panelAchievementScrollView.transform, false)
                goNow.transform.localScale = UnityEngine.Vector3.one
            end
            goNow.gameObject:SetActive(true)

            updateAchievement(tbAchievementInfo)
        end
    end

    pkgAssetBundleMgr.LoadAssetBundle(assetbundleTag, "AchievementCell", onLoadCompleted)
end

function resetScrollViewItems()
    for i=0, le_panelAchievementScrollView.transform.childCount-1 do
        local goChild = le_panelAchievementScrollView.transform:GetChild(i)
        if goChild then
            goChild.gameObject:SetActive(false)
        end
    end
end

function destroyUI()
    pkgUIBaseViewMgr.destroyUI(pkgUIAchievement) 
end