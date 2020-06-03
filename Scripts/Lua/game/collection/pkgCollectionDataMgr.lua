doNameSpace("pkgCollectionDataMgr")

function GetCropCollectionInfo()
    local tbCollectionInfo = pkgUserDataManager.GetCollectionInfo()
    return tbCollectionInfo[tostring(GOODS_DEF.CROP)] or {}
end

function SetCropCollectionInfo(tbCollection)
    if not tbCollection then
        return false
    end

    local tbCollectionInfo = GetCropCollectionInfo()
    for strId, tbInfo in pairs(tbCollection) do
        tbCollectionInfo[strId] = tbInfo
    end
    return true
end