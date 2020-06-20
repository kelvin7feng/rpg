doNameSpace("pkgUIMain")

assetbundleTag = "ui"
prefabFile = "Main"
dSortOrder = 100

event_listener = {
    {pkgClientEventDefination.UPDATE_BATTLE_LEVEL, "UpdateLevelInfo"},
    {pkgClientEventDefination.UPDATE_GOODS, "UpdatePlayerInfo"},
    {pkgClientEventDefination.UPDATE_USER_LEVEL, "UpdatePlayerInfo"},
    {pkgClientEventDefination.UPDATE_WEAR_EQUIP, "InitEquipList"},  
    {pkgClientEventDefination.UPDATE_TAKE_OFF_EQUIP, "InitEquipList"},  
    {pkgClientEventDefination.UPDATE_GOODS, "InitEquipList"},  
    {pkgClientEventDefination.UPDATE_ACHIEVEMENT, "CheckRedPoint"},
    {pkgClientEventDefination.ON_BOSS_IS_COMING, "OnSpawnBoss"},
    {pkgClientEventDefination.ON_SPAWN_MONSTER, "OnSpawnMonster"},
    {pkgClientEventDefination.ON_KILL_BOSS, "ResetChallengeText"},
    {pkgClientEventDefination.ON_PLAYER_REBORN, "ResetChallengeText"},
    {pkgClientEventDefination.ON_CREATE_MONSTER_CHANGED, "UpdateChallengeBossBtnEffect"},
    {pkgClientEventDefination.UPDATE_WEAR_EQUIP, "UpdateRoleAtrr"},
    {pkgClientEventDefination.UPDATE_TAKE_OFF_EQUIP, "UpdateRoleAtrr"},
    {pkgClientEventDefination.UPDATE_USER_LEVEL, "UpdateRoleAtrr"},
    {pkgClientEventDefination.ON_GET_AFK_REWARD, "UpdateChestBtnEffect"},
}

-- player info
m_objExpSlider = m_objExpSlider or nil
m_playerExpSlider = m_playerExpSlider or nil
m_txtPlayerName = m_txtPlayerName or nil
m_txtDiamond = m_txtDiamond or nil
m_txtGold = m_txtGold or nil
m_txtLevel = m_txtLevel or nil
m_btnTask = m_btnTask or nil
m_panelRoleAttr = m_panelRoleAttr or nil
m_panelRoleModel = m_panelRoleModel or nil
m_tbRoleModel = m_tbRoleModel or nil

-- home panel
m_btnHouse = m_btnHouse or nil

-- level info
m_txtAfkExp = m_txtAfkExp or nil
m_txtAfkGold = m_txtAfkGold or nil
m_txtLevelName = m_txtLevelName or nil

-- function
m_bottomPanel = m_bottomPanel or nil
m_secondBottomPanel = secondBottomPanel or nil
m_btnBag = m_btnBag or nil

-- right panel
m_rightPanel = m_rightPanel or nil
m_rightPanelAnimator = m_rightPanelAnimator or nil
m_bRightPanelStretch = false

-- bottom panel
m_btnChallengeBoss = m_btnChallengeBoss or nil
m_txtChallengeBoss = m_txtChallengeBoss or nil

m_strChllengeBoss = nil
m_strWaitingBoss = nil
m_strBattleWithBoss = nil
m_bIsWaitingBoss = false
m_objChallengeEffectNode = nil

-- chest btn
m_btnAFKReward = m_btnAFKReward or nil
m_objChestEffectNode = nil
m_dChestTimerId = m_dChestTimerId or nil

-- pet
m_panelPetModel = m_panelPetModel or nil
m_tbPetModel = m_tbPetModel or nil

m_tbBtn = {}
m_dBtnCount = 5
m_dCurBtnIndex = 3
m_dCurBattlePage = 3

m_tbEquipSlot = {}

local function onClickChallengeBoss()
    if not pkgBattleLogic.CanChallengeBoss() then
        Toast(pkgLanguageMgr.GetStringById(1105))
        return false
    end

    Toast(pkgLanguageMgr.GetStringById(1102))

    if not pkgBattleLogic.IsNormalState() then
        return
    end
    
    pkgUITool.SetGameObjectString(m_txtChallengeBoss, m_strWaitingBoss)
    if m_objChallengeEffectNode then
        pkgSysEffect.SetEffectActive(m_objChallengeEffectNode, false)
    end

    pkgBattleLogic.SetBattleState(pkgBattleConstMgr.BattleState.WAITING_BOSS)
    pkgSocket.SendToLogic(EVENT_ID.CLIENT_BATTLE.CHALLENGE_BOSS)
end

local function onClickGetAFKReward()
    pkgUIBaseViewMgr.showByViewPath("game/afk/pkgUIAFKReward")
end

local function onClickHome()

end

local function onClickField()
    -- print("onClickField ================= ")
end

local function onClickBattle()
    -- print("onClickBattle ================= ")
end

local function onClickRole(panel)
    local rtParams = {width = 1080, height = 1080}
    local panelRoleModel = panel.transform:Find("Panel/PanelModel")
    if panelRoleModel then
        m_tbRoleModel = pkgUI3DModel.showModelOnUI(panelRoleModel.gameObject, nil, false, rtParams)
        pkgUI3DModel.changeCharacterModel(m_tbRoleModel, "model", "Melee")
    end
end

local function onClickPet(panel)
    pkgUIPetMainMgr.Init(panel)
end

local function onClickBag()
    pkgUIBaseViewMgr.showByViewPath("game/goods/pkgUIGoodsMain")
end

local function onClickTask()
    pkgUIBaseViewMgr.showByViewPath("game/achievement/pkgUIAchievement")
end

local function onClickRightArrow()
    if not m_rightPanelAnimator then
        return
    end

    m_bRightPanelStretch = not m_bRightPanelStretch
    pkgAnimatorMgr.SetBool(m_rightPanelAnimator, "Stretch", m_bRightPanelStretch)
end

local function onClickHouse()
    pkgUIBaseViewMgr.showByViewPath("game/house/pkgUIHouse")
end

local function onClickCropland()
    pkgUIBaseViewMgr.showByViewPath("game/cropland/pkgUICropland")
end

local function onClickShop()
    pkgUIBaseViewMgr.showByViewPath("game/shop/pkgUIShop")
end

m_tbClickFunc = {
    { 
        callBack = onClickHome,
        panelName = "Panel/HomePanel",
        panel = nil,
    },
    { 
        callBack = onClickField,
        panelName = "Panel/FieldPanel",
        panel = nil,
    },
    { 
        callBack = onClickBattle,
        panelName = "Panel/BattlePanel",
        panel = nil,
    },
    { 
        callBack = onClickRole,
        panelName = "Panel/RolePanel",
        panel = nil,
    },
    { 
        callBack = onClickPet,
        panelName = "Panel/PetPanel",
        panel = nil,
    },
}

local function onClickBottomBtn(btnGo, i)
    m_dCurBtnIndex = i
    
    updateBtn()
    updatePanel()

    if m_dCurBtnIndex == m_dCurBattlePage then
        UpdateChallengeBossBtnEffect()
        UpdateChestBtnEffect()
    else
        pkgSysEffect.SetEffectActive(m_objChallengeEffectNode, false)
        pkgSysEffect.SetEffectActive(m_objChestEffectNode, false)
    end
    m_tbClickFunc[i].callBack(m_tbClickFunc[i].panel)
end

function OnSpawnBoss()
    if m_dCurBtnIndex == m_dCurBattlePage then
        Toast(pkgLanguageMgr.GetStringById(1101))
    end

    m_btnChallengeBoss.gameObject:GetComponent(UnityEngine.UI.Button).interactable = false
    pkgUITool.SetGameObjectString(m_txtChallengeBoss, m_strBattleWithBoss)
    pkgSysEffect.SetEffectActive(m_objChallengeEffectNode, false)
    pkgBattleLogic.SetBattleState(pkgBattleConstMgr.BattleState.BATTLE_WITH_BOSS)
end

function OnSpawnMonster()
    UpdateChallengeBossBtnEffect()
end

function updatePanel()
    for i=1, m_dBtnCount do
        local panel = m_tbClickFunc[i].panel
        if i == m_dCurBtnIndex then
            panel.gameObject:SetActive(true)
        else
            panel.gameObject:SetActive(false)
        end
    end
end

function updateBtn()
    for i=1, m_dBtnCount do
        local objBtn = m_tbBtn[i]
        local imgSelect = objBtn.transform:Find("Select")
        if i == m_dCurBtnIndex then
            imgSelect.gameObject:SetActive(true)
        else
            imgSelect.gameObject:SetActive(false)
        end
    end
end

function init()

    m_txtPlayerName = gameObject.transform:Find("Panel/FloatPanel/PlayerInfo/PlayerName")
    m_txtDiamond = gameObject.transform:Find("Panel/FloatPanel/PlayerInfo/ValuePanel/Diamond/Bg/Text")
    m_txtGold = gameObject.transform:Find("Panel/FloatPanel/PlayerInfo/ValuePanel/Gold/Bg/Text")
    m_txtLevel = gameObject.transform:Find("Panel/FloatPanel/PlayerInfo/Level")

    m_objExpSlider = gameObject.transform:Find("Panel/FloatPanel/PlayerInfo/ExpProgress/Slider")
    m_playerExpSlider = m_objExpSlider:GetComponent(UnityEngine.UI.Slider)
    m_bottomPanel = gameObject.transform:Find("Panel/BottomPanel")
    m_secondBottomPanel = gameObject.transform:Find("Panel/SecondBottomPanel")
    m_btnChallengeBoss = gameObject.transform:Find("Panel/SecondBottomPanel/BtnChallengeBoss")
    m_txtChallengeBoss = gameObject.transform:Find("Panel/SecondBottomPanel/BtnChallengeBoss/Text")

    m_panelRoleAttr = gameObject.transform:Find("Panel/RolePanel/Panel/RoleAttr/AttrPanel")
    m_panelRoleModel = gameObject.transform:Find("Panel/RolePanel/Panel/PanelModel")
    m_btnAFKReward = gameObject.transform:Find("Panel/SecondBottomPanel/BtnAFKReward")

	pkgButtonMgr.AddListener(m_secondBottomPanel, "BtnChallengeBoss", onClickChallengeBoss)
	pkgButtonMgr.AddListener(m_secondBottomPanel, "BtnAFKReward", onClickGetAFKReward)

    m_strChllengeBoss = pkgLanguageMgr.GetStringById(1103)
    m_strWaitingBoss = pkgLanguageMgr.GetStringById(1104)
    m_strBattleWithBoss = pkgLanguageMgr.GetStringById(1105)

    m_txtLevelName = gameObject.transform:Find("Panel/BattlePanel/LevelInfo/LevelName")
    m_txtAfkExp = gameObject.transform:Find("Panel/BattlePanel/LevelInfo/AfkPanel/Exp/Text")
    m_txtAfkGold = gameObject.transform:Find("Panel/BattlePanel/LevelInfo/AfkPanel/Gold/Text")

    m_panelPetModel = gameObject.transform:Find("Panel/PetPanel/Panel/PanelModel")
    
    m_rightPanel = gameObject.transform:Find("Panel/RightPanel")
    m_rightPanelAnimator = m_rightPanel:GetComponent(UnityEngine.Animator)

    m_btnTask = gameObject.transform:Find("Panel/RightPanel/Task")
    pkgButtonMgr.AddListener(gameObject, "Panel/RightPanel/Arrow", onClickRightArrow)
    pkgButtonMgr.AddListener(gameObject, "Panel/RightPanel/Task", onClickTask)
    pkgButtonMgr.AddListener(gameObject, "Panel/RightPanel/FoldablePanel/Bag", onClickBag)
    for i=1, m_dBtnCount do
        local objBtn = m_bottomPanel.transform:Find("Btn"..i)
        m_tbBtn[i] = objBtn
        pkgButtonMgr.AddBtnListener(objBtn, onClickBottomBtn, i)

        m_tbClickFunc[i].panel = gameObject.transform:Find(m_tbClickFunc[i].panelName)
    end

    pkgButtonMgr.AddListener(gameObject, "Panel/HomePanel/Panel/BtnHouse", onClickHouse)
    pkgButtonMgr.AddListener(gameObject, "Panel/HomePanel/Panel/BtnCropland", onClickCropland)
    pkgButtonMgr.AddListener(gameObject, "Panel/HomePanel/Panel/BtnShop", onClickShop)

    local function onLoadPopupTextUI()
        pkgPopupTextUI.gameObject.transform:SetParent(gameObject.transform, false)
        pkgPopupTextUI.gameObject.transform:SetAsFirstSibling()
        local rectTransform = pkgPopupTextUI.gameObject:GetComponent(UnityEngine.RectTransform)
        rectTransform.offsetMin = UnityEngine.Vector2(0, 0);
        rectTransform.offsetMax = UnityEngine.Vector2(0, 0);
        rectTransform.localScale = UnityEngine.Vector3(1,1,1)
    end

    local function onLoadHpProgressUI()
        pkgUIHpProgress.gameObject.transform:SetParent(gameObject.transform, false)
        pkgUIHpProgress.gameObject.transform:SetAsFirstSibling()
        local rectTransform = pkgUIHpProgress.gameObject:GetComponent(UnityEngine.RectTransform)
        rectTransform.offsetMin = UnityEngine.Vector2(0, 0);
        rectTransform.offsetMax = UnityEngine.Vector2(0, 0);
        rectTransform.localScale = UnityEngine.Vector3(1,1,1)

        local mainPlayer = pkgActorManager.GetMainPlayer()
        if mainPlayer then
            pkgUIHpProgress.AddHpProgress(mainPlayer, pkgSysStat.GetMaxHealth(mainPlayer))
        end
    end
    
    pkgUIBaseViewMgr.showByViewPath("game/ui/pkgPopupTextUI", onLoadPopupTextUI)
    pkgUIBaseViewMgr.showByViewPath("game/ui/pkgUIHpProgress", onLoadHpProgressUI)

    pkgUIToastMgr.Init()
    
    InitEquipList()
    updateBtn()
    updatePanel()
    UpdateRoleAtrr()
    CheckRedPoint()
    ResetChallengeText()

    DeleteTimer()
    m_dChestTimerId = pkgTimerMgr.addWithoutDelay(1000, function()
        UpdateChestBtnEffect()
    end)
end

function DeleteTimer()
    if m_dChestTimerId then
        pkgTimerMgr.delete(m_dChestTimerId)
        m_dChestTimerId = nil
    end
end

function resetAttrItem()
    for i=0, m_panelRoleAttr.transform.childCount - 1 do
        local goChild = m_panelRoleAttr.transform:GetChild(i).gameObject
        goChild.gameObject:SetActive(false)
    end
end

function UpdateRoleAtrr()
    resetAttrItem()
    local tbRoleAttr = pkgAttrMgr.GetRoleAttrDescList(pkgActorManager.GetMainPlayer().tbAttr)
    for i, strAttr in ipairs(tbRoleAttr) do
        pkgUITool.SetStringByName(m_panelRoleAttr, "TxtAttr"..i, strAttr)
        pkgUITool.SetActiveByName(m_panelRoleAttr, "TxtAttr"..i, true)
    end
end

function ResetChallengeText()
    pkgUITool.SetGameObjectString(m_txtChallengeBoss, m_strChllengeBoss)
    m_btnChallengeBoss.gameObject:GetComponent(UnityEngine.UI.Button).interactable = true
end

function UpdateChallengeBossBtnEffect()
    if m_dCurBtnIndex == m_dCurBattlePage and pkgBattleLogic.CanPlayChallengeEffect() then
        if m_objChallengeEffectNode then
            pkgSysEffect.SetEffectActive(m_objChallengeEffectNode, true)
        else
            m_objChallengeEffectNode = pkgSysEffect.PlayEffect(pkgPoolDefination.PoolType.CHALLENGE_BTN, m_txtChallengeBoss.transform)
        end
    else
        pkgSysEffect.SetEffectActive(m_objChallengeEffectNode, false)
    end
end

function CheckRedPoint()
    if pkgAchievementMgr.canShowRedPoint() then
        pkgUIRedPointMgr.AddRedPoint(m_btnTask.gameObject, "task_red_point")
    else
        pkgUIRedPointMgr.RemoveRedPoint("task_red_point")
    end
end

function show()

    UpdatePlayerInfo()

    UpdateLevelInfo()
end

function UpdateLevelInfo(dLevelId)
    
    if not dLevelId then
        dLevelId = pkgUserDataManager.GetBattleLevel()
    end

    UpdateLevelName(dLevelId)
end

function UpdateLevelName(dLevelId)
    local txtComponent = m_txtLevelName.gameObject:GetComponent(UnityEngine.UI.Text)
    local tbCfg = pkgLevelCfgMgr.GetLevelCfg(dLevelId)
    txtComponent.text = tbCfg.name
end

function UpdatePlayerInfo()

    local mainPlayer = pkgActorManager.GetMainPlayer()
    local txtNameComponent = m_txtPlayerName.gameObject:GetComponent(UnityEngine.UI.Text)
    txtNameComponent.text = pkgUserDataManager.GetName()

    local txtDiamondComponent = m_txtDiamond.gameObject:GetComponent(UnityEngine.UI.Text)
    txtDiamondComponent.text = pkgStringMgr.ConvertNumber2Short(pkgUserDataManager.GetDiamond())
    
    local txtGoldComponent = m_txtGold.gameObject:GetComponent(UnityEngine.UI.Text)
    txtGoldComponent.text = pkgStringMgr.ConvertNumber2Short(pkgUserDataManager.GetGold())

    local txtLevelComponent = m_txtLevel.gameObject:GetComponent(UnityEngine.UI.Text)
    txtLevelComponent.text = pkgUserDataManager.GetLevel()
    
    UpdatePlayerExp(mainPlayer)
end

function UpdatePlayerExp(player)
    if not pkgActorManager.IsMainPlayer(player) then
        return
    end

    local dCurExp = pkgGoodsDataMgr.GetExp()
    local dLevel = pkgUserDataManager.GetLevel()
    local dCfgExp = pkgPlayerLevelCfgMgr.GetLevelExp(dLevel)
    if dCfgExp and dCfgExp > 0 then
        SetPlayerExpProgress(dCurExp/dCfgExp)
    end
end

function SetPlayerExpProgress(dRatio)
    if m_playerExpSlider then
        m_playerExpSlider.value = dRatio
    end
end

function InitEquipList()
    local tbSlots = pkgUserDataManager.GetEquipSlots()
    for i, strEquipId in ipairs(tbSlots) do
        local btnSlot = gameObject.transform:Find("Panel/RolePanel/Panel/BtnPanel/BtnSlot"..i)
        m_tbEquipSlot[i] = btnSlot

        local function onClickEquipSlotBtn(btnGo)
            pkgUIRedPointMgr.RemoveRedPoint("equip_slot_red_point")
            pkgUIBaseViewMgr.showByViewPath("game/equip/pkgUISelectEquip", nil, i) 
        end

        local function onClickDetail(btnGo)
            pkgUIBaseViewMgr.showByViewPath("game/equip/pkgUIEquipDetail", nil, {strEquipId = strEquipId, bIsSlot = true})
        end

        -- set icon
        local tbEquip = pkgUserDataManager.GetEquip(strEquipId)

        local goIcon = btnSlot.transform:Find("icon")
        if tbEquip then
            if pkgUITool.isNull(goIcon) then
                pkgUITool.CreateIcon(tbEquip.cfgId, btnSlot, nil, {onClick = onClickDetail, size = pkgUITool.ICON_SIZE_TYPE.SMALL})
            else
                pkgUITool.UpdateIcon(goIcon, tbEquip.cfgId, nil, {onClick = onClickDetail, size = pkgUITool.ICON_SIZE_TYPE.SMALL})
            end
        else
            if not pkgUITool.isNull(goIcon) then
                UnityEngine.Object.Destroy(goIcon.gameObject)
            end
            pkgButtonMgr.AddBtnListener(btnSlot, onClickEquipSlotBtn)
        end
        
        if pkgEquipMgr.CanShowRedPoint(i) then
            local objRedPoint = btnSlot.transform:Find("redPoint")
            if pkgUITool.isNull(objRedPoint) then
                pkgUIRedPointMgr.AddRedPoint(btnSlot.gameObject, "equip_slot_red_point")
            end
        end
    end
end

function UpdateChestBtnEffect()
    if m_dCurBtnIndex == m_dCurBattlePage and pkgAFKMgr.CanGetward() then
        if m_objChestEffectNode then
            pkgSysEffect.SetEffectActive(m_objChestEffectNode, true)
        else
            m_objChestEffectNode = pkgSysEffect.PlayEffect(pkgPoolDefination.PoolType.CIRCLE_EFFECT, m_btnAFKReward.transform)
        end
    else
        pkgSysEffect.SetEffectActive(m_objChestEffectNode, false)
    end
end

function destroyUI()
    DeleteTimer()
end