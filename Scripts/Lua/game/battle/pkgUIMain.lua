doNameSpace("pkgUIMain")

assetbundleTag = "ui"
prefabFile = "Main"

event_listener = {
    {CLIENT_EVENT.PLAYER_HURT, "UpdatePlayerHp"},
    {CLIENT_EVENT.UPDATE_LEVEL, "UpdateLevelName"},
}

m_objHpSlider = m_objHpSlider or nil
m_playerHpSlider = m_playerHpSlider or nil
m_bottomPanel = m_bottomPanel or nil
m_secondBottomPanel = secondBottomPanel or nil
m_levelName = m_levelName or nil

function destroyUI()

end

local function onClickBattle()

end

local function onClickChallengeBoss()
    pkgSocket.SendToLogic(EVENT_ID.CLIENT_BATTLE.CHALLENGE_BOSS)
end

local function onClickPet()

end

function init()

    pkgMinimap.Init()
    pkgFlyWordUI.Init()

    m_objHpSlider = gameObject.transform:Find("Panel/PlayerInfo/HpProgress/Slider")
    m_playerHpSlider = m_objHpSlider:GetComponent(UnityEngine.UI.Slider)
    m_levelName = gameObject.transform:Find("Panel/LevelInfo/LevelName")
    m_bottomPanel = gameObject.transform:Find("Panel/BottomPanel")
    m_secondBottomPanel = gameObject.transform:Find("Panel/SecondBottomPanel")

    pkgButtonMgr.AddListener(m_bottomPanel, "BtnBattle", onClickBattle)
    pkgButtonMgr.AddListener(m_bottomPanel, "BtnPet", onClickPet)
    pkgButtonMgr.AddListener(m_secondBottomPanel, "BtnChallengeBoss", onClickChallengeBoss)
end

function show()
    print("pkgUIMain show")
    SetPlayerHpProgress(pkgSysStat.GetRadioHealth(pkgActorManager.GetMainPlayer()))
    UpdateLevelName(pkgUserDataManager.GetLevel())
end

function UpdateLevelName(dLevelId)
    local txtComponent = m_levelName.gameObject:GetComponent(UnityEngine.UI.Text)
    txtComponent.text = "关卡" .. dLevelId
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