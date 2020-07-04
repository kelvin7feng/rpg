doNameSpace("pkgUITask")

assetbundleTag = "ui"
prefabFile = "Task"

event_listener = 
{
    {pkgClientEventDefination.ONE_ACHIEVEMENT_CHANGED, "updateOneAchievement"},
    {pkgClientEventDefination.ON_UPDATE_ONE_TASK, "updateOneTask"},
    {pkgClientEventDefination.ON_UPDATE_LIVENESS, "updateLivenessReward"},
}

m_dTabBtnCount = 3
m_dCurrentTabId = 1
m_tbTabBtn = m_tbTabBtn or {}
m_tbArea = m_tbArea or {}
m_tbChestReward = m_tbChestReward or {}

m_panelDailyTask = m_panelDailyTask or nil
m_panelWeeklyTask = m_panelWeeklyTask or nil
m_scrollViewDailyTask = m_scrollViewDailyTask or nil
m_scrollViewWeeklyTask = m_scrollViewWeeklyTask or nil
m_scrollViewAchievement = m_scrollViewAchievement or nil

function init()
    local goParent = gameObject.transform:Find("Panel")
    m_panelDailyTask = goParent.transform:Find("Panel1")
    m_panelWeeklyTask = goParent.transform:Find("Panel2")
    m_scrollViewDailyTask = goParent.transform:Find("Panel1/Scroll View/Viewport/Content")
    m_scrollViewWeeklyTask = goParent.transform:Find("Panel2/Scroll View/Viewport/Content")
    m_scrollViewAchievement = goParent.transform:Find("Panel3/Scroll View/Viewport/Content")

    for i=1, m_dTabBtnCount do
        local strKey = "Category/Btn" .. i
        local goTabBtn = goParent.transform:Find(strKey)
        m_tbTabBtn[i] = goTabBtn

        local strArea = "Panel" .. i
        local goArea = goParent.transform:Find(strArea)
        m_tbArea[i] = goArea

        pkgButtonMgr.AddListener(goParent, strKey, function()
            updateTabBtn(i)
            m_dCurrentTabId = i
            m_dSelectedFormula = nil
            updateDetailArea()
        end)
    end

    updateTabBtn(m_dCurrentTabId)

end

function updateTabBtn(dCurrentTabId)
    for i=1, m_dTabBtnCount do
        local goBtn = m_tbTabBtn[i]
        local goArea = m_tbArea[i]
        local goSelect = goBtn.transform:Find("ImgSelect")
        if dCurrentTabId == i then
            goSelect.gameObject:SetActive(true)
            goArea.gameObject:SetActive(true)
        else
            goSelect.gameObject:SetActive(false)
            goArea.gameObject:SetActive(false)
        end    
    end
end

function updateDetailArea()
    if m_dCurrentTabId == 1 then
        local tbTaskData = pkgTaskDataMgr.GetTaskListByType(pkgTaskCfgMgr.TaskType.DAILY)
        updateTaskPanel(m_scrollViewDailyTask, tbTaskData)
        updateLivenessRewardList(pkgTaskCfgMgr.TaskType.DAILY)
    elseif m_dCurrentTabId == 2 then
        local tbTaskData = pkgTaskDataMgr.GetTaskListByType(pkgTaskCfgMgr.TaskType.WEEKLY)
        updateTaskPanel(m_scrollViewWeeklyTask, tbTaskData)
        updateLivenessRewardList(pkgTaskCfgMgr.TaskType.WEEKLY)
    elseif m_dCurrentTabId == 3 then
        updateAchievementPanel()
    end
end

function show()
    updateDetailArea()
    checkDailyRedPoint()
    checkWeeklyRedPoint()
    checkAchievementRedPoint()
end

function checkDailyRedPoint()
    if pkgTaskMgr.CanShowDailyTaskRedPoint() then
        pkgUIRedPointMgr.AddRedPoint(m_tbTabBtn[1].gameObject, "daily_task_red_point")
    else
        pkgUIRedPointMgr.RemoveRedPoint("daily_task_red_point")
    end
end

function checkWeeklyRedPoint()
    if pkgTaskMgr.CanShowWeeklyTaskRedPoint() then
        pkgUIRedPointMgr.AddRedPoint(m_tbTabBtn[2].gameObject, "weekly_task_red_point")
    else
        pkgUIRedPointMgr.RemoveRedPoint("weekly_task_red_point")
    end
end

function checkAchievementRedPoint()
    if pkgAchievementMgr.canShowRedPoint() then
        pkgUIRedPointMgr.AddRedPoint(m_tbTabBtn[3].gameObject, "achievement_red_point")
    else
        pkgUIRedPointMgr.RemoveRedPoint("achievement_red_point")
    end
end

function updateLivenessReward(dTaskType)

    if dTaskType ~= m_dCurrentTabId then
        return
    end
    
    if m_dCurrentTabId == 1 then
        updateLivenessRewardList(pkgTaskCfgMgr.TaskType.DAILY)
    elseif m_dCurrentTabId == 2 then
        updateLivenessRewardList(pkgTaskCfgMgr.TaskType.WEEKLY)
    end

    checkDailyRedPoint()
    checkWeeklyRedPoint()
end

function updateOneTask(dTaskType, dTaskId)

    if dTaskType ~= m_dCurrentTabId then
        return
    end

    local tbTask = pkgTaskDataMgr.GetTaskInfoById(dTaskType, dTaskId)
    if not tbTask then
        return
    end

    if m_dCurrentTabId == 1 then
        updateTask(m_scrollViewDailyTask, tbTask, true)
        updateLivenessRewardList(pkgTaskCfgMgr.TaskType.DAILY)
    elseif m_dCurrentTabId == 2 then
        updateTask(m_scrollViewWeeklyTask, tbTask, true)
        updateLivenessRewardList(pkgTaskCfgMgr.TaskType.WEEKLY)
    end

    checkDailyRedPoint()
    checkWeeklyRedPoint()
end

function updateOneAchievement(dType)

    if m_dCurrentTabId ~= 3 then
        return
    end

    local tbAchievementInfo = pkgAchievementMgr.getAchievementByType(dType)
    if not tbAchievementInfo then
        return 
    end
    
    updateAchievement(tbAchievementInfo)

    checkAchievementRedPoint()
end

function updateAchievement(tbAchievementInfo)
    local name = "achievementCell"..tbAchievementInfo.dType
    local goNow = m_scrollViewAchievement.transform:Find(name)
    if pkgUITool.isNull(goNow) then
        goNow = UnityEngine.Object.Instantiate(prefab)
        goNow.name = name
        goNow.transform:SetParent(m_scrollViewAchievement.transform, false)
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
    
    resetScrollViewItems(m_scrollViewAchievement)

    local tbAchievement = pkgAchievementMgr.getAchievement()
    if not tbAchievement or #tbAchievement <= 0 then
        return false
    end

    local function onLoadCompleted(prefab)
        local tbCfg = nil
        local dId = nil
        for i, tbAchievementInfo in ipairs(tbAchievement) do
            local name = "achievementCell"..tbAchievementInfo.dType
            local goNow = m_scrollViewAchievement.transform:Find(name)
            if pkgUITool.isNull(goNow) then
                goNow = UnityEngine.Object.Instantiate(prefab)
                goNow.name = name
                goNow.transform:SetParent(m_scrollViewAchievement.transform, false)
                goNow.transform.localScale = UnityEngine.Vector3.one
            end
            goNow.gameObject:SetActive(true)

            updateAchievement(tbAchievementInfo)
        end
    end

    pkgAssetBundleMgr.LoadAssetBundle(assetbundleTag, "AchievementCell", onLoadCompleted)
end

function updateTaskPanel(panelTask, tbTaskData)
    
    resetScrollViewItems(panelTask)

    if not tbTaskData or #tbTaskData <= 0 then
        return false
    end

    local function onLoadCompleted(prefab)
        local tbCfg = nil
        local dId = nil
        for i, tbTask in ipairs(tbTaskData) do
            local name = "taskCell"..tbTask.dId
            local goNow = panelTask.transform:Find(name)
            if pkgUITool.isNull(goNow) then
                goNow = UnityEngine.Object.Instantiate(prefab)
                goNow.name = name
                goNow.transform:SetParent(panelTask.transform, false)
                goNow.transform.localScale = UnityEngine.Vector3.one
            end
            goNow.gameObject:SetActive(true)

            updateTask(panelTask, tbTask)
        end
    end

    pkgAssetBundleMgr.LoadAssetBundle(assetbundleTag, "TaskCell", onLoadCompleted)
end

function updateTask(panelTask, tbTask, bSetLast)
    local name = "taskCell"..tbTask.dId
    local goNow = panelTask.transform:Find(name)
    if pkgUITool.isNull(goNow) then
        goNow = UnityEngine.Object.Instantiate(prefab)
        goNow.name = name
        goNow.transform:SetParent(panelTask.transform, false)
        goNow.transform.localScale = UnityEngine.Vector3.one
    end
    local dId = tbTask.dId
    if dId <= 0 then
        goNow.gameObject:SetActive(false)
        return
    end
    goNow.gameObject:SetActive(true)

    local tbCfg = nil
    local dTaskType = nil
    if m_dCurrentTabId == 1 then
        dTaskType = pkgTaskCfgMgr.TaskType.DAILY
    elseif m_dCurrentTabId == 2 then
        dTaskType = pkgTaskCfgMgr.TaskType.WEEKLY
    end
    tbCfg = pkgTaskCfgMgr.GetTaskCfgById(dTaskType, dId)

    pkgUITool.SetStringByName(goNow, "ImgLiveness/TxtLivenetssCount", tbCfg.liveness)
    pkgUITool.SetStringByName(goNow, "desc", pkgLanguageMgr.FormatStr(tbCfg.desc, tbCfg.target))
    pkgUITool.SetStringByName(goNow, "processSlider/Text", string.format("%d/%d", tbTask.dProgress, tbCfg.target))

    local slider = goNow.transform:Find("processSlider")
    local sliderComponent = slider:GetComponent(UnityEngine.UI.Slider)
    local dProgressVal = math.min(tbTask.dProgress/tbCfg.target, 1)
    sliderComponent.value = dProgressVal

    if dProgressVal >= 1 then
        pkgUITool.SetActiveByName(goNow, "btnGo", false)
        pkgUITool.SetActiveByName(goNow, "btnProcessing", false)
        if tbTask.dState ~= pkgTaskCfgMgr.TaskState.DONE then
            pkgUITool.SetActiveByName(goNow, "btnReward", true)
            pkgUITool.SetActiveByName(goNow, "processSlider", true)
            pkgUITool.SetActiveByName(goNow, "TxtDone", false)
            pkgButtonMgr.AddListener(goNow, "btnReward", function ( ... )
                pkgTaskMgr.GetReward(dTaskType, tbCfg.id)
            end)
        else
            pkgUITool.SetActiveByName(goNow, "btnReward", false)
            pkgUITool.SetActiveByName(goNow, "processSlider", false)
            pkgUITool.SetActiveByName(goNow, "TxtDone", true)
            pkgUIImageMgr.SetGrayRecursive(goNow, true)

            if bSetLast then
                goNow.transform:SetAsLastSibling()
            end
        end
    else
        pkgUITool.SetActiveByName(goNow, "btnReward", false)
        if tbCfg.redirect > 0 then
            pkgUITool.SetActiveByName(goNow, "btnGo", true)
            pkgUITool.SetActiveByName(goNow, "btnProcessing", false)
            pkgButtonMgr.AddListener(goNow, "btnGo", function ( ... )
                pkgRedirectMgr.redirectPage(tbCfg.redirect, pkgUITask)
            end)
        else
            pkgUITool.SetActiveByName(goNow, "btnGo", false)
            pkgUITool.SetActiveByName(goNow, "btnProcessing", true)
        end
    end    
end

function resetScrollViewItems(scrollView)
    for i=0, scrollView.transform.childCount-1 do
        local goChild = scrollView.transform:GetChild(i)
        if goChild then
            goChild.gameObject:SetActive(false)
        end
    end
end

function updateLivenessRewardList(dTaskType)

    local tbLivenessRewardCfg = pkgTaskCfgMgr.GetLivenessRewardList(dTaskType)
    if dTaskType == pkgTaskCfgMgr.TaskType.DAILY then
        panelTask = m_panelDailyTask
        tbTaskInfo = pkgTaskDataMgr.GetTaskByType(pkgTaskCfgMgr.TaskType.DAILY)
    elseif dTaskType == pkgTaskCfgMgr.TaskType.WEEKLY then
        panelTask = m_panelWeeklyTask
        tbTaskInfo = pkgTaskDataMgr.GetTaskByType(pkgTaskCfgMgr.TaskType.WEEKLY)
    end

    local dLivenessCount = tbTaskInfo.dLiveness
    local objProgress = panelTask.transform:Find("LivenessReward/ProgressBg/Progress")
    local sliderLiveness = objProgress:GetComponent(ue.UI.Slider)
    sliderLiveness.value = dLivenessCount/100
    pkgUITool.SetStringByName(panelTask, "LivenessReward/ImgLiveness/TxtLivenetssCount", dLivenessCount)

    local objChest = objProgress:Find("RewardItem").gameObject 
    objChest:SetActive(false)
    
    local dWidth = objProgress:GetComponent(ue.RectTransform).sizeDelta.x
    m_tbChestReward = {}
    for _, tbCfg in ipairs(tbLivenessRewardCfg) do
        local dLiveness = tbCfg.liveness
        local strName = "RewardItem" .. dLiveness
        
        local chestItem = objProgress:Find(strName)
        if pkgUITool.isNull(chestItem) then
            chestItem = ue.GameObject.Instantiate(objChest)
            chestItem.transform:SetParent(objProgress, false)
            chestItem.gameObject.name = strName
        end

        local rect = chestItem:GetComponent(ue.RectTransform)
        local x = dWidth * dLiveness * 0.01
        rect.anchoredPosition = ue.Vector2(x, rect.anchoredPosition.y)
        chestItem.gameObject:SetActive(true)

        local txtLiveness = chestItem.transform:Find("TxtLiveness"):GetComponent(ue.UI.Text)
        txtLiveness.text = dLiveness

        local objBoxEffect = chestItem.transform:Find("UI_Effect")
        local effect = objBoxEffect.transform:Find("effect")
        local dLivenessState = pkgTaskMgr.GetLivenessRewardState(dTaskType, dLiveness)
        if dLivenessState == pkgTaskCfgMgr.LivenessState.NOT_ENOUGH then
            pkgUITool.ResetImage("chest", "bx_3", chestItem)
            if effect then
                effect.gameObject:SetActive(false)
            end
        elseif dLivenessState == pkgTaskCfgMgr.LivenessState.CAN_GET then
            pkgUITool.ResetImage("chest", "bx_3", chestItem)
            -- add effect
            if effect then
                effect.gameObject:SetActive(true)
            else
                local objNode = pkgSysEffect.PlayEffect(pkgPoolDefination.PoolType.CIRCLE_EFFECT, objBoxEffect.transform)
                objNode.obj.name = "effect"
            end
        elseif dLivenessState == pkgTaskCfgMgr.LivenessState.GOT then
            pkgUITool.ResetImage("chest", "bx_33", chestItem)
            if effect then
                effect.gameObject:SetActive(false)
            end
        end

        pkgButtonMgr.AddBtnListener(chestItem, function ( ... )
            if dLivenessState == pkgTaskCfgMgr.LivenessState.NOT_ENOUGH then
                Toast(pkgLanguageMgr.GetStringById(1201))
                return
            elseif dLivenessState == pkgTaskCfgMgr.LivenessState.GOT then
                Toast(pkgLanguageMgr.GetStringById(1202))
                return
            end

            pkgSocket.SendToLogic(EVENT_ID.TASK.GET_LIVENESS_REWARD, dTaskType, dLiveness)
        end)
    end
end

function destroyUI()
    m_dTabBtnCount = 3
    m_dCurrentTabId = 1
    m_tbTabBtn = {}
    m_tbArea = {}
    m_tbChestReward = {}
    m_scrollViewDailyTask = nil
    m_scrollViewWeeklyTask = nil
    m_scrollViewAchievement = nil
    pkgUIBaseViewMgr.destroyUI(pkgUITask) 
end