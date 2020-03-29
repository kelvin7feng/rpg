doNameSpace("pkgUIMain")

assetbundleTag = "ui"
prefabFile = "Main"

event_listener = {
    {CLIENT_EVENT.PLAYER_HURT, "UpdatePlayerHp"},
    {CLIENT_EVENT.UPDATE_LEVEL, "UpdateLevelInfo"},
    {CLIENT_EVENT.UPDATE_GOODS, "UpdatePlayerInfo"},  
}

-- player info
m_objHpSlider = m_objHpSlider or nil
m_playerHpSlider = m_playerHpSlider or nil
m_txtPlayerName = m_txtPlayerName or nil
m_txtDiamond = m_txtDiamond or nil
m_txtGold = m_txtGold or nil

-- level info
m_txtAfkExp = m_txtAfkExp or nil
m_txtAfkGold = m_txtAfkGold or nil
m_txtLevelName = m_txtLevelName or nil

-- function
m_bottomPanel = m_bottomPanel or nil
m_secondBottomPanel = secondBottomPanel or nil

m_tbBtn = {}
m_dBtnCount = 5
m_dCurBtnIndex = 3

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

m_tbClickFunc = {
    onClickHome, onClickField, onClickBattle, onClickRole, onClickPet
}

local function onClickBottomBtn(btnGo, i)
    m_dCurBtnIndex = i
    
    updateBtn()

    m_tbClickFunc[i]()
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

    pkgFlyWordUI.Init()

    m_txtPlayerName = gameObject.transform:Find("Panel/FloatPanel/PlayerInfo/PlayerName")
    m_txtDiamond = gameObject.transform:Find("Panel/FloatPanel/PlayerInfo/ValuePanel/Diamond/Bg/Text")
    m_txtGold = gameObject.transform:Find("Panel/FloatPanel/PlayerInfo/ValuePanel/Gold/Bg/Text")

    m_objHpSlider = gameObject.transform:Find("Panel/FloatPanel/PlayerInfo/HpProgress/Slider")
    m_playerHpSlider = m_objHpSlider:GetComponent(UnityEngine.UI.Slider)
    m_bottomPanel = gameObject.transform:Find("Panel/BottomPanel")
    m_secondBottomPanel = gameObject.transform:Find("Panel/SecondBottomPanel")
	pkgButtonMgr.AddListener(m_secondBottomPanel, "BtnChallengeBoss", onClickChallengeBoss)

    m_txtLevelName = gameObject.transform:Find("Panel/BattlePanel/LevelInfo/LevelName")
    m_txtAfkExp = gameObject.transform:Find("Panel/BattlePanel/LevelInfo/AfkPanel/Exp/Text")
    m_txtAfkGold = gameObject.transform:Find("Panel/BattlePanel/LevelInfo/AfkPanel/Gold/Text")
    
    for i=1, m_dBtnCount do
        local objBtn = m_bottomPanel.transform:Find("Btn"..i)
        m_tbBtn[i] = objBtn
        pkgButtonMgr.AddBtnListener(objBtn, onClickBottomBtn, i)
    end

    updateBtn()
end

function show()

    UpdatePlayerInfo()

    UpdateLevelInfo()
end

function UpdateLevelInfo(dLevelId)
    
    if not dLevelId then
        dLevelId = pkgUserDataManager.GetLevel()
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

function destroyUI()

end