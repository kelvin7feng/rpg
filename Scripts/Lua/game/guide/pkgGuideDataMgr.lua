doNameSpace("pkgGuideDataMgr")

function GetGuideInfo()
    local tbGuideInfo = pkgUserDataManager.GetGuideInfo()
    return tbGuideInfo
end

function SetGuideInfo(dGuideId)
    if not dGuideId then
        return false
    end

    local tbGuideInfo = pkgUserDataManager.GetGuideInfo()
    tbGuideInfo.dGuideId = dGuideId

    return true
end