doNameSpace("pkgGuideMgr")

function GetGuideStep()
    local tbGuideInfo = pkgGuideDataMgr.GetGuideInfo()
    return tbGuideInfo.dGuideId
end

function CanShowWelcome()
    
    if GetGuideStep() == pkgGuideCfgMgr.Step.WELCOME_GUIDE then
        return true
    end

    return false
end

function Finish()
    pkgSocket.SendToLogic(EVENT_ID.GUIDE.FINISH)
end

function OnFinish(dGuideId)
    if not dGuideId then
        return false
    end
    
    pkgGuideDataMgr.SetGuideInfo(dGuideId)
end