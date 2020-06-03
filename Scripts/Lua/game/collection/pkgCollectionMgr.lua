doNameSpace("pkgCollectionMgr")

function OnCollectNew(tbCollection)
    pkgCollectionDataMgr.SetCropCollectionInfo(tbCollection)
    pkgEventManager.PostEvent(pkgClientEventDefination.ON_COLLECTION_NEW_CROP, tbCollection)
end

function GetCropCollectionList()
    local tbCropCollection = pkgCollectionDataMgr.GetCropCollectionInfo()
    return tbCropCollection
end

function HaveCropCollection(dId)
    if not dId then
        return false
    end
    local tbCropCollection = GetCropCollectionList()
    return tbCropCollection[tostring(dId)] and true or false
end