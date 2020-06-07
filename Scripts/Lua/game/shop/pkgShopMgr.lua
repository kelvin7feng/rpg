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
    -- 12点更新
    local dCurTime = os.time()
    local dNextUpdateTime = 86400 - (dCurTime - math.fmod(dCurTime, 86400))
    pkgTimerMgr.once(dNextUpdateTime * 1000, function()
        pkgSocket.SendToLogic(EVENT_ID.SHOP.UPDATE_SHOP_INFO, pkgShopCfgMgr.ShopType.NORMAL)
    end)
end