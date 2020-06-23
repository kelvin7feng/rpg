doNameSpace("pkgShopMgr")

function OnUpdateShopInfo(dShopType, tbShopInfo)
    
    if not dShopType or not tbShopInfo then
        return false
    end

    pkgShopDataMgr.SetShopInfo(dShopType, tbShopInfo)
    pkgEventManager.PostEvent(pkgClientEventDefination.ON_UPDATE_SHOP_INFO, dShopType, tbShopInfo)
end

function BuyGoods(dShopType, dId)
    
    if not dShopType or not dId then
        return
    end
    
    pkgSocket.SendToLogic(EVENT_ID.SHOP.BUY_GOODS, dShopType, dId)
end

function OnBuyGoods(dShopType, dId, tbItem)
    
    if not dShopType or not dId or not tbItem then
        return
    end
    
    pkgShopDataMgr.SetGoodsInfo(dShopType, dId, tbItem)
    pkgEventManager.PostEvent(pkgClientEventDefination.ON_BUY_GOODS, dShopType, dId, tbItem)
end

function InitUpdateShopInfo()
    -- 次日6点更新
    local tbShopInfo = pkgShopDataMgr.GetShopInfo(pkgShopCfgMgr.ShopType.NORMAL)
    local dLastUpdateTime = tbShopInfo.dLastUpdateTime
    local dRemainingTime = pkgTimeMgr.GetTomorrowStartTime(dLastUpdateTime) - os.time()
    pkgTimerMgr.once(dRemainingTime * 1000, function()
        pkgSocket.SendToLogic(EVENT_ID.SHOP.UPDATE_SHOP_INFO, pkgShopCfgMgr.ShopType.NORMAL)
    end)
end

function BuyPet(dShopType, dId)
    
    if not dShopType or not dId then
        return
    end
    
    pkgSocket.SendToLogic(EVENT_ID.SHOP.BUY_PET, dShopType, dId)
end

function OnBuyPet(dShopType, dId, tbPetInfo, tbItem)
    
    if not dShopType or not dId or not tbPetInfo then
        return
    end
    
    pkgPetLogic.AddPet(tbPetInfo)
    pkgShopDataMgr.SetGoodsInfo(dShopType, dId, tbItem)

    pkgEventManager.PostEvent(pkgClientEventDefination.ON_BUY_PET, dId)
end