doNameSpace("pkgHouseMgr")

function OnError(dErrorCode)
    --print("pkgHouseMgr ============= OnError")
    local dLangId = pkgHomeCfgMgr.LangMap[dErrorCode]
    if dLangId then
        Toast(pkgLanguageMgr.GetStringById(dLangId))
    end
end

function OnLevelUp(dLevel)
    --print("pkgHouseMgr ============= OnLevelUp")
    pkgHouseDataMgr.SetLevel(dLevel)
    pkgEventManager.PostEvent(pkgClientEventDefination.ON_HOUSE_LEVEL_UP)
end

function OnUpgrade(dStar, dLevel)
    --print("pkgHouseMgr ============= OnUpgrade")
    pkgHouseDataMgr.SetStar(dStar)
    pkgHouseDataMgr.SetLevel(dLevel)
    pkgEventManager.PostEvent(pkgClientEventDefination.ON_HOUSE_UPGRADE)
end

-- to do
function CanLevelUp()
    return true
end

function LevelUp()
    if not CanLevelUp() then
        return false
    end
    pkgSocket.SendToLogic(EVENT_ID.HOME.LEVEL_UP)
end

-- to do
function CanUpgrade()
    return true
end

function Upgrade()
    if not CanUpgrade() then
        return false
    end
    pkgSocket.SendToLogic(EVENT_ID.HOME.UPGRADE)
end