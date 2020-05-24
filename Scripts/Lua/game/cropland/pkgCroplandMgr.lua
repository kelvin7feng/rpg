doNameSpace("pkgCroplandDataMgr")

function GetLandInfo()
    local tbLandInfo = pkgUserDataManager.GetCropLandInfo()
    return tbLandInfo.tbLand
end

function GetLandInfoByIndex(dIndex)
    local tbInfo = nil
    local tbLandInfo = GetLandInfo()
    if tbLandInfo[dIndex] then
        tbInfo = tbLandInfo[dIndex]
    end
    return tbInfo
end

function GetLandState(dIndex)
    local tbInfo = GetLandInfoByIndex(dIndex)
    return tbInfo.dState
end