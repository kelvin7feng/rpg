doNameSpace("pkgUIAFKReward")

assetbundleTag = "ui"
prefabFile = "AFKUI"

event_listener = {
    {pkgClientEventDefination.UPDATE_BATTLE_LEVEL, "UpdateLevelInfo"},
}

m_scrollView = m_scrollView or nil
m_txtAfkExp = m_txtAfkExp or nil
m_txtAfkGold = m_txtAfkGold or nil
m_txtLevelName = m_txtLevelName or nil
m_txtAFKTime = m_txtAFKTime or nil
m_dTimerId = m_dTimerId or nil

function init()
    m_scrollView = gameObject.transform:Find("Panel/Scroll View/Viewport/Content")
    m_txtLevelName = gameObject.transform:Find("Panel/PanelBaseInfo/LevelName")
    m_txtAfkExp = gameObject.transform:Find("Panel/PanelBaseInfo/AfkPanel/Exp/Text")
    m_txtAfkGold = gameObject.transform:Find("Panel/PanelBaseInfo/AfkPanel/Gold/Text")
    m_txtAFKTime = gameObject.transform:Find("Panel/PanelBaseInfo/PanelTime/TxtTime")
end

function UpdateLevelName(dLevelId)
    local txtComponent = m_txtLevelName.gameObject:GetComponent(UnityEngine.UI.Text)
    local tbCfg = pkgLevelCfgMgr.GetLevelCfg(dLevelId)
    txtComponent.text = tbCfg.name
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

function deleteTimer()
    if m_dTimerId then
        pkgTimerMgr.delete(m_dTimerId)
        m_dTimerId = nil
    end
end

function show()
    UpdateLevelInfo()

    local dSpan = nil
    local dLastRewardTime = pkgUserDataManager.GetLastRewardTime()
    local function funcCallback()
        dSpan = os.time() - dLastRewardTime
        pkgUITool.SetGameObjectString(m_txtAFKTime, pkgTimeMgr.FormatTimestamp(dSpan))
    end
    m_dTimerId = pkgTimerMgr.addWithoutDelay(1000, funcCallback)

    local function onClickGetReward()
        if pkgAFKMgr.GetReward() then
            close()
            destroyUI() 
        end      
    end

    pkgButtonMgr.AddListener(gameObject, "Panel/Operation/BtnGetReward", onClickGetReward)

    local function onClickCancel()
        close()
        destroyUI()
    end

    pkgButtonMgr.AddListener(gameObject, "Panel/Operation/BtnCancel", onClickCancel)
end

function destroyUI()
    pkgUIBaseViewMgr.destroyUI(pkgUIAFKReward)
end

function close()
    deleteTimer()
end