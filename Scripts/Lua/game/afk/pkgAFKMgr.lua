doNameSpace("pkgAFKMgr")

function CanGetward()
    local dLastRewardTime = pkgUserDataManager.GetLastRewardTime()
    if os.time() - dLastRewardTime < 60 then
        return false
    end

    return true
end

function GetReward()
    if not CanGetward() then
        Toast(pkgLanguageMgr.GetStringById(40001))
        return false
    end
    
    pkgSocket.SendToLogic(EVENT_ID.AFK.GET_REWARD)

    return true
end

function OnGetReward(dLastCollectTime)
    pkgAFKDataMgr.SetLastCollectTime(dLastCollectTime)
    pkgEventManager.PostEvent(pkgClientEventDefination.ON_GET_AFK_REWARD)
end