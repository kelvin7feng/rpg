doNameSpace("pkgCollectionDataMgr")

function GetCropCollectionInfo()
    local tbCollectionInfo = pkgUserDataManager.GetCollectionInfo()
    return tbCollectionInfo[tostring(GOODS_DEF.CROP)] or {}
end

function SetCropCollectionInfo(tbCollection)
    if not tbCollection then
        return false
    end

    local tbCollectionInfo = pkgUserDataManager.GetCollectionInfo()
    local tbCropCollectionInfo = tbCollectionInfo[tostring(GOODS_DEF.CROP)]
    if not tbCollectionInfo[tostring(GOODS_DEF.CROP)] then
        tbCollectionInfo[tostring(GOODS_DEF.CROP)] = {}
    end
    for strId, tbInfo in pairs(tbCollection) do
        tbCollectionInfo[tostring(GOODS_DEF.CROP)][strId] = tbInfo
    end
    return true
end