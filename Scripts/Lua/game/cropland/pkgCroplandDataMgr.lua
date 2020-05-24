doNameSpace("pkgCroplandDataMgr")

function GetCroplandInfo()
    local tbCroplandInfo = pkgUserDataManager.GetCroplandInfo()
    return tbCroplandInfo.tbLand
end