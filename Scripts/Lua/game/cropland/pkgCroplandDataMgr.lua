doNameSpace("pkgCroplandDataMgr")

function GetCroplandInfo()
    local tbCroplandInfo = pkgUserDataManager.GetCroplandInfo()
    return tbCroplandInfo
end

function GetLandInfo()
    local tbLandInfo = GetCroplandInfo()
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

function SetLandInfo(tbLandInfo)
    if not tbLandInfo then
        return
    end

    local tbOldInfo = GetLandInfoByIndex(tbLandInfo.dLandId)
    tbOldInfo.dId = tbLandInfo.dId
    tbOldInfo.dState = tbLandInfo.dState
    tbOldInfo.dPlantTime = tbLandInfo.dPlantTime
end