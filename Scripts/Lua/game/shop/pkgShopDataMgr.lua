doNameSpace("pkgShopDataMgr")

function GetShopInfo(dShopType)
    if not dShopType then
        return nil
    end
    local tbShopInfo = pkgUserDataManager.GetShopInfo()
    return tbShopInfo[dShopType] or {}
end

function SetShopInfo(dShopType, tbInfo)
    local tbShopInfo = pkgUserDataManager.GetShopInfo()
    tbShopInfo[dShopType] = tbInfo

    return true
end

function SetGoodsInfo(dShopType, dId, tbItem)
    
    local tbShopInfo = pkgUserDataManager.GetShopInfo()
    if not tbShopInfo then
        return false
    end
    
    if not tbShopInfo[dShopType] or not tbShopInfo[dShopType].tbGoodsList[dId] then
        return false
    end
    
    tbShopInfo[dShopType].tbGoodsList[dId] = tbItem

    return true
end