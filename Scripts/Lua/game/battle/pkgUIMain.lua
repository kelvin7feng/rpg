doNameSpace("pkgUIMain")

assetbundleTag = "ui"
prefabFile = "Main"
dSortOrder = 100

event_listener = {
    {pkgClientEventDefination.PLAYER_HP_CHANGE, "UpdatePlayerHp"},
    {pkgClientEventDefination.UPDATE_LEVEL, "UpdateLevelInfo"},
    {pkgClientEventDefination.UPDATE_GOODS, "UpdatePlayerInfo"},
    {pkgClientEventDefination.UPDATE_USER_LEVEL, "UpdatePlayerInfo"},
    {pkgClientEventDefination.UPDATE_WEAR_EQUIP, "InitEquipList"},  
    {pkgClientEventDefination.UPDATE_TAKE_OFF_EQUIP, "InitEquipList"},  
}

-- player info
m_objHpSlider = m_objHpSlider or nil
m_playerHpSlider = m_playerHpSlider or nil
m_txtPlayerName = m_txtPlayerName or nil
m_txtDiamond = m_txtDiamond or nil
m_txtGold = m_txtGold or nil
m_txtLevel = m_txtLevel or nil

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

m_tbBtn = {}
m_dBtnCount = 5
m_dCurBtnIndex = 3

m_tbEquipSlot = {}

local function onClickChallengeBoss()
    pkgSocket.SendToLogic(EVENT_ID.CLIENT_BATTLE.CHALLENGE_BOSS)
end

local function onClickHome()
    print("onClickHome ================= ")
end

local function onClickField()
    print("onClickField ================= ")
end

local function onClickBattle()
    print("onClickBattle ================= ")
end

local function onClickRole()
    print("onClickRole ================= ")
end

local function onClickPet()
    print("onClickPet ================= ")
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

    m_tbClickFunc[i].callBack()
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

    m_objHpSlider = gameObject.transform:Find("Panel/FloatPanel/PlayerInfo/HpProgress/Slider")
    m_playerHpSlider = m_objHpSlider:GetComponent(UnityEngine.UI.Slider)
    m_bottomPanel = gameObject.transform:Find("Panel/BottomPanel")
    m_secondBottomPanel = gameObject.transform:Find("Panel/SecondBottomPanel")
	pkgButtonMgr.AddListener(m_secondBottomPanel, "BtnChallengeBoss", onClickChallengeBoss)

    m_txtLevelName = gameObject.transform:Find("Panel/BattlePanel/LevelInfo/LevelName")
    m_txtAfkExp = gameObject.transform:Find("Panel/BattlePanel/LevelInfo/AfkPanel/Exp/Text")
    m_txtAfkGold = gameObject.transform:Find("Panel/BattlePanel/LevelInfo/AfkPanel/Gold/Text")
    
    m_rightPanel = gameObject.transform:Find("Panel/RightPanel")
    m_rightPanelAnimator = m_rightPanel:GetComponent(UnityEngine.Animator)

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

    local function onLoadPopupTextUI()
        pkgPopupTextUI.gameObject.transform:SetParent(gameObject.transform, false)
        pkgPopupTextUI.gameObject.transform:SetAsFirstSibling()
        local rectTransform = pkgPopupTextUI.gameObject:GetComponent(UnityEngine.RectTransform)
        rectTransform.offsetMin = UnityEngine.Vector2(0, 0);
        rectTransform.offsetMax = UnityEngine.Vector2(0, 0);
        rectTransform.localScale = UnityEngine.Vector3(1,1,1)
    end

    pkgUIBaseViewMgr.showByViewPath("game/ui/pkgPopupTextUI", onLoadPopupTextUI)
    
    InitEquipList()
    updateBtn()
    updatePanel()
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
    
    local tbCfg = pkgAFKCfgMgr.GetAFKCfg(dLevelId)
    if not tbCfg then
        LOG_ERROR("GetAFKCfg can not find level id:", dLevelId)
        return
    end

    local dExp = tbCfg.exp
    local dGold = tbCfg.gold
    
    pkgUITool.UpdateGameObjectText(m_txtAfkExp, 1, dExp)
    pkgUITool.UpdateGameObjectText(m_txtAfkGold, 2, dGold)

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
    txtDiamondComponent.text = pkgUserDataManager.GetDiamond()
    
    local txtGoldComponent = m_txtGold.gameObject:GetComponent(UnityEngine.UI.Text)
    txtGoldComponent.text = pkgUserDataManager.GetGold()

    local txtLevelComponent = m_txtLevel.gameObject:GetComponent(UnityEngine.UI.Text)
    txtLevelComponent.text = pkgUserDataManager.GetLevel()
    
    SetPlayerHpProgress(pkgSysStat.GetRadioHealth(mainPlayer))
end

function UpdatePlayerHp(player)
    if not pkgActorManager.IsMainPlayer(player) then
        return
    end
    SetPlayerHpProgress(pkgSysStat.GetRadioHealth(pkgActorManager.GetMainPlayer()))
end

function SetPlayerHpProgress(dRatio)
    if m_playerHpSlider then
        m_playerHpSlider.value = dRatio
    end
end

function InitEquipList()
    local tbSlots = pkgUserDataManager.GetEquipSlots()
    for i, strEquipId in ipairs(tbSlots) do
        local btnSlot = gameObject.transform:Find("Panel/RolePanel/Panel/BtnPanel/BtnSlot"..i)
        m_tbEquipSlot[i] = btnSlot

        local function onClickEquipSlotBtn(btnGo)
            pkgUIBaseViewMgr.showByViewPath("game/equip/pkgUISelectEquip", nil, i) 
        end

        local function onClickDetail(btnGo)
            pkgUIBaseViewMgr.showByViewPath("game/equip/pkgUIEquipDetail", nil, strEquipId)
        end

        -- set icon
        local tbEquip = pkgUserDataManager.GetEquip(strEquipId)
        pkgButtonMgr.RemoveGameObjectListeners(btnSlot)

        local icon = btnSlot.transform:Find("icon")
        if tbEquip then
            if not icon then
                pkgUITool.CreateIcon(tbEquip.cfgId, btnSlot, nil, {onClick = onClickDetail, size = pkgUITool.ICON_SIZE_TYPE.SMALL})
            else
                icon.gameObject:SetActive(true)
            end            
        else
            if icon then
                icon.gameObject:SetActive(false)
            end
            pkgButtonMgr.AddBtnListener(btnSlot, onClickEquipSlotBtn)
        end
        
    end
end

function destroyUI()

end