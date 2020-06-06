doNameSpace("pkgShopMgr")

function OnUpdateShopInfo(dShopType, tbShopInfo)
    if not dShopType or not tbShopInfo then
        return
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
    print("OnBuyGoods ===================== ", dShopType, dId, tbItem)
    if not dShopType or not dId or not tbItem then
        return
    end
    LOG_TABLE(tbItem)
    pkgShopDataMgr.SetGoodsInfo(dShopType, dId, tbItem)
    pkgEventManager.PostEvent(pkgClientEventDefination.ON_BUY_GOODS, dShopType, dId, tbItem)
end
